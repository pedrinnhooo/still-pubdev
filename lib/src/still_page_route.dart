import 'package:flutter/widgets.dart';

import 'motion.dart';
import 'motion_scope.dart';
import 'still_transition.dart';

/// A page route whose push becomes a cross-fade, or a cut, under the
/// surrounding [MotionScope].
///
/// The default travel is 64 logical pixels from the trailing edge, which reads
/// as a page change without a full-screen slide.
class StillPageRoute<T> extends PageRoute<T> {
  /// Creates a route that builds its page with [builder].
  StillPageRoute({
    required this.builder,
    this.motion = StillMotion.slideFromEnd,
    this.travel = 64,
    super.settings,
    super.fullscreenDialog,
  });

  /// Builds the page.
  final WidgetBuilder builder;

  /// Travel used while motion is allowed.
  final StillMotion motion;

  /// Slide distance in logical pixels.
  final double travel;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => _duration((scheme) => scheme.medium);

  @override
  Duration get reverseTransitionDuration => _duration((scheme) => scheme.fast);

  Duration _duration(Duration Function(MotionScheme scheme) pick) {
    final context = navigator?.context;
    if (context == null) return pick(MotionScheme.standard);
    final motion = MotionScope.unwatched(context);
    if (motion == null) return pick(MotionScheme.standard);
    return motion.resolve(pick(motion.scheme));
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return StillTransition(
      animation: animation,
      motion: motion,
      travel: travel,
      child: child,
    );
  }
}
