import 'package:flutter/widgets.dart';

import 'motion.dart';

/// Provides a [Motion] to the subtree and rebuilds it when accessibility
/// features change.
///
/// Place it above the navigator, typically as the parent of [WidgetsApp] or
/// `MaterialApp`:
///
/// ```dart
/// MotionScope(
///   preference: MotionPreference.platform,
///   child: WidgetsApp(
///     color: const Color(0xFF000000),
///     builder: (context, child) => child ?? const SizedBox.shrink(),
///   ),
/// )
/// ```
///
/// [preference] forces a decision for tests and previews. [MotionPreference.platform]
/// reads Remove animations from [MediaQuery.disableAnimations] and Reduce Motion
/// from [AccessibilityFeatures.reduceMotion]. On Flutter 3.50 and later it also
/// reads `MediaQueryData.reduceMotion`, which is the overridable form of that flag.
class MotionScope extends StatefulWidget {
  /// Creates a scope.
  const MotionScope({
    super.key,
    this.preference = MotionPreference.platform,
    this.scheme = MotionScheme.standard,
    required this.child,
  });

  /// Which decision to apply. Defaults to the platform flags.
  final MotionPreference preference;

  /// Durations and distances for [child].
  final MotionScheme scheme;

  /// The subtree that should follow [preference].
  final Widget child;

  /// The [Motion] for [context].
  ///
  /// Registers a dependency, so the caller rebuilds when the decision changes.
  static Motion of(BuildContext context) {
    final motion = maybeOf(context);
    if (motion != null) return motion;
    throw FlutterError(
      'MotionScope.of() was called with a context that has no MotionScope.\n'
      'Wrap the app in MotionScope, above WidgetsApp or MaterialApp.',
    );
  }

  /// The [Motion] for [context], or null when no [MotionScope] exists.
  static Motion? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_MotionModel>();
    return scope?.motion;
  }

  /// The [Motion] above [context], without registering a dependency.
  ///
  /// Routes call this while they are being installed. That moment is not a
  /// build, so [of] cannot be used. Widgets should use [of].
  static Motion? unwatched(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<_MotionModel>();
    final widget = element?.widget;
    if (widget is _MotionModel) return widget.motion;
    return null;
  }

  @override
  State<MotionScope> createState() => _MotionScopeState();
}

class _MotionScopeState extends State<MotionScope> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAccessibilityFeatures() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final features = View.of(context).platformDispatcher.accessibilityFeatures;
    final media = MediaQuery.maybeOf(context);
    final reduceFromMedia =
        media == null ? null : _mediaQueryReduceMotion(media);
    return _MotionModel(
      motion: Motion.resolve(
        preference: widget.preference,
        scheme: widget.scheme,
        reduceMotion: reduceFromMedia ?? features.reduceMotion,
        disableAnimations:
            media?.disableAnimations ?? features.disableAnimations,
      ),
      child: widget.child,
    );
  }
}

class _MotionModel extends InheritedWidget {
  const _MotionModel({required this.motion, required super.child});

  final Motion motion;

  @override
  bool updateShouldNotify(_MotionModel oldWidget) => motion != oldWidget.motion;
}

/// Flutter 3.50 adds `MediaQueryData.reduceMotion`. Earlier SDKs only expose
/// Reduce Motion on [AccessibilityFeatures], so the field is read dynamically
/// and the miss is remembered.
bool? _probedReduceMotionField;

bool? _mediaQueryReduceMotion(MediaQueryData data) {
  if (_probedReduceMotionField == false) return null;
  try {
    final Object? value = (data as dynamic).reduceMotion;
    if (value is bool) {
      _probedReduceMotionField = true;
      return value;
    }
    _probedReduceMotionField = false;
    return null;
  } on NoSuchMethodError {
    _probedReduceMotionField = false;
    return null;
  }
}
