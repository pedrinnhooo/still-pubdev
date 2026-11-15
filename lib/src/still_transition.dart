import 'package:flutter/widgets.dart';

import 'motion.dart';
import 'motion_scope.dart';

/// Plays [motion] against [animation], substituting a cross-fade or an instant
/// cut when [MotionScope] says so.
///
/// [animation] runs from 0 to 1. [intervalBegin] and [intervalEnd] select the
/// slice of that animation this child should use, which is how a stagger
/// shares one controller.
class StillTransition extends StatelessWidget {
  /// Creates a transition.
  const StillTransition({
    super.key,
    required this.animation,
    required this.child,
    this.motion = StillMotion.fade,
    this.travel,
    this.intervalBegin = 0,
    this.intervalEnd = 1,
  }) : assert(
          intervalBegin >= 0 &&
              intervalBegin <= intervalEnd &&
              intervalEnd <= 1,
          'interval must satisfy 0 <= begin <= end <= 1',
        );

  /// Clock for the transition. Zero is the start, one is at rest.
  final Animation<double> animation;

  /// What to move when travel is allowed.
  final StillMotion motion;

  /// Slide distance in logical pixels. Defaults to [MotionScheme.travel].
  final double? travel;

  /// Where in [animation] this child starts moving, from 0 to 1.
  final double intervalBegin;

  /// Where in [animation] this child reaches rest, from 0 to 1.
  final double intervalEnd;

  /// The widget shown at rest.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _Driven(
      animation: animation,
      motion: motion,
      travel: travel,
      intervalBegin: intervalBegin,
      intervalEnd: intervalEnd,
      child: child,
    );
  }
}

class _Driven extends AnimatedWidget {
  const _Driven({
    required Animation<double> animation,
    required this.motion,
    required this.travel,
    required this.intervalBegin,
    required this.intervalEnd,
    required this.child,
  }) : super(listenable: animation);

  final StillMotion motion;
  final double? travel;
  final double intervalBegin;
  final double intervalEnd;
  final Widget child;

  Animation<double> get _animation => listenable as Animation<double>;

  double _progress(Curve curve) {
    final span = intervalEnd - intervalBegin;
    final raw = span <= 0
        ? (_animation.value >= intervalEnd ? 1.0 : 0.0)
        : ((_animation.value - intervalBegin) / span).clamp(0.0, 1.0);
    return curve.transform(raw);
  }

  @override
  Widget build(BuildContext context) {
    final resolved = MotionScope.of(context);
    if (resolved.effect == MotionEffect.none) return child;

    final t = _progress(resolved.curve);
    final faded = Opacity(opacity: t, child: child);
    if (!resolved.travels || motion == StillMotion.fade) return faded;

    if (motion == StillMotion.scale) {
      final from = resolved.scheme.scaleFrom;
      return Transform.scale(scale: from + (1 - from) * t, child: faded);
    }

    final distance = travel ?? resolved.scheme.travel;
    return Transform.translate(
      offset: _begin(context, motion, distance) * (1 - t),
      child: faded,
    );
  }
}

Offset _begin(BuildContext context, StillMotion motion, double travel) {
  switch (motion) {
    case StillMotion.fade:
    case StillMotion.scale:
      return Offset.zero;
    case StillMotion.slideUp:
      return Offset(0, travel);
    case StillMotion.slideDown:
      return Offset(0, -travel);
    case StillMotion.slideFromStart:
      final fromEnd = _endSign(context);
      return Offset(-fromEnd * travel, 0);
    case StillMotion.slideFromEnd:
      return Offset(_endSign(context) * travel, 0);
  }
}

double _endSign(BuildContext context) {
  return Directionality.of(context) == TextDirection.rtl ? -1 : 1;
}
