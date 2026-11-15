import 'package:flutter/widgets.dart';

/// How a motion scope should treat the platform accessibility flags.
enum MotionPreference {
  /// Follow Reduce Motion and Remove animations.
  platform,

  /// Keep travel, scale, and stagger even if Reduce Motion is on.
  ///
  /// Remove animations is an engine flag. [AnimationController] still snaps
  /// to the end while it is on, including when this preference is selected.
  full,

  /// Cross-fade. No slide, scale, or stagger.
  reduced,

  /// Show the next state immediately.
  off,
}

/// What a widget should do after [MotionPreference] is resolved.
enum MotionEffect {
  /// Slide, scale, and stagger as authored.
  full,

  /// Opacity only. Duration is kept so the cross-fade is visible.
  fade,

  /// No animation.
  none,
}

/// The kind of travel a widget uses when [MotionEffect.full] is active.
enum StillMotion {
  /// Opacity only, even when motion is allowed.
  fade,

  /// Start [MotionScheme.travel] pixels lower and settle upward.
  slideUp,

  /// Start [MotionScheme.travel] pixels higher and settle downward.
  slideDown,

  /// Enter from the leading edge.
  slideFromStart,

  /// Enter from the trailing edge. This is the usual page push.
  slideFromEnd,

  /// Settle from [MotionScheme.scaleFrom] to 1.
  scale,
}

/// Durations and distances shared by the widgets in this package.
///
/// These are not Material motion tokens. The package never imports Material,
/// so the same values work under `WidgetsApp` after the design libraries leave
/// the SDK.
@immutable
class MotionScheme {
  /// Creates a scheme.
  const MotionScheme({
    this.fast = const Duration(milliseconds: 140),
    this.medium = const Duration(milliseconds: 280),
    this.slow = const Duration(milliseconds: 420),
    this.curve = Curves.easeOutCubic,
    this.reducedCurve = Curves.easeOut,
    this.travel = 24,
    this.scaleFrom = 0.96,
    this.stagger = const Duration(milliseconds: 40),
  })  : assert(travel >= 0, 'travel cannot be negative'),
        assert(
          scaleFrom > 0 && scaleFrom <= 1,
          'scaleFrom must be in the range (0, 1]',
        );

  /// Buttons, switches, and other small state changes.
  final Duration fast;

  /// Content swaps and page pushes.
  final Duration medium;

  /// Larger entrances.
  final Duration slow;

  /// Curve used while [MotionEffect.full] is active.
  final Curve curve;

  /// Curve used for a cross-fade.
  final Curve reducedCurve;

  /// Slide distance in logical pixels.
  final double travel;

  /// Starting scale for [StillMotion.scale].
  final double scaleFrom;

  /// Delay between staggered children while motion is allowed.
  final Duration stagger;

  /// The scheme used when a caller does not pass one.
  static const MotionScheme standard = MotionScheme();

  @override
  bool operator ==(Object other) {
    return other is MotionScheme &&
        other.fast == fast &&
        other.medium == medium &&
        other.slow == slow &&
        other.curve == curve &&
        other.reducedCurve == reducedCurve &&
        other.travel == travel &&
        other.scaleFrom == scaleFrom &&
        other.stagger == stagger;
  }

  @override
  int get hashCode => Object.hash(
        fast,
        medium,
        slow,
        curve,
        reducedCurve,
        travel,
        scaleFrom,
        stagger,
      );
}

/// The motion decision for the current subtree.
@immutable
class Motion {
  const Motion._({
    required this.preference,
    required this.scheme,
    required this.effect,
  });

  /// Resolves [preference] against the platform flags.
  ///
  /// [disableAnimations] wins over [reduceMotion] when [preference] is
  /// [MotionPreference.platform]: Remove animations skips the cross-fade,
  /// Reduce Motion keeps it.
  factory Motion.resolve({
    required MotionPreference preference,
    required MotionScheme scheme,
    required bool reduceMotion,
    required bool disableAnimations,
  }) {
    return Motion._(
      preference: preference,
      scheme: scheme,
      effect: _effectFor(
        preference: preference,
        reduceMotion: reduceMotion,
        disableAnimations: disableAnimations,
      ),
    );
  }

  /// Preference that produced [effect].
  final MotionPreference preference;

  /// Distances and durations for this subtree.
  final MotionScheme scheme;

  /// What widgets should render.
  final MotionEffect effect;

  /// Whether slides, scales, and staggers should run.
  bool get travels => effect == MotionEffect.full;

  /// Duration widgets should use for [effect].
  ///
  /// A cross-fade keeps [duration]. [MotionEffect.none] returns
  /// [Duration.zero].
  Duration resolve(Duration duration) {
    if (effect == MotionEffect.none) return Duration.zero;
    return duration;
  }

  /// Delay between staggered children. Always zero unless travel is allowed.
  Duration resolveDelay(Duration delay) {
    if (effect == MotionEffect.full) return delay;
    return Duration.zero;
  }

  /// Curve for [effect].
  Curve get curve {
    switch (effect) {
      case MotionEffect.full:
        return scheme.curve;
      case MotionEffect.fade:
        return scheme.reducedCurve;
      case MotionEffect.none:
        return Curves.linear;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Motion &&
        other.preference == preference &&
        other.scheme == scheme &&
        other.effect == effect;
  }

  @override
  int get hashCode => Object.hash(preference, scheme, effect);

  @override
  String toString() => 'Motion(${preference.name}, ${effect.name})';
}

MotionEffect _effectFor({
  required MotionPreference preference,
  required bool reduceMotion,
  required bool disableAnimations,
}) {
  switch (preference) {
    case MotionPreference.full:
      return MotionEffect.full;
    case MotionPreference.reduced:
      return MotionEffect.fade;
    case MotionPreference.off:
      return MotionEffect.none;
    case MotionPreference.platform:
      if (disableAnimations) return MotionEffect.none;
      if (reduceMotion) return MotionEffect.fade;
      return MotionEffect.full;
  }
}
