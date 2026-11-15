import 'package:flutter/widgets.dart';

import 'motion.dart';
import 'motion_scope.dart';
import 'still_transition.dart';

/// Swaps [child] with a slide that becomes a cross-fade under Reduce Motion.
///
/// [AnimatedSwitcher] only transitions when the next child is a new widget.
/// Give each distinct child its own [Key].
class StillSwitcher extends StatelessWidget {
  /// Creates a switcher.
  const StillSwitcher({
    super.key,
    required this.child,
    this.motion = StillMotion.slideUp,
    this.duration,
    this.travel,
  });

  /// The child currently on screen.
  final Widget child;

  /// Travel used while motion is allowed.
  final StillMotion motion;

  /// Length of the swap. Defaults to [MotionScheme.medium].
  final Duration? duration;

  /// Slide distance in logical pixels. Defaults to [MotionScheme.travel].
  final double? travel;

  @override
  Widget build(BuildContext context) {
    final resolved = MotionScope.of(context);
    final resolvedDuration = resolved.resolve(
      duration ?? resolved.scheme.medium,
    );
    return AnimatedSwitcher(
      duration: resolvedDuration,
      reverseDuration: resolvedDuration,
      switchInCurve: Curves.linear,
      switchOutCurve: Curves.linear,
      layoutBuilder: (current, previous) {
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          children: <Widget>[
            ...previous,
            if (current != null) current,
          ],
        );
      },
      transitionBuilder: (child, animation) {
        return StillTransition(
          animation: animation,
          motion: motion,
          travel: travel,
          child: child,
        );
      },
      child: child,
    );
  }
}
