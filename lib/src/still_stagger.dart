import 'package:flutter/widgets.dart';

import 'motion.dart';
import 'motion_scope.dart';
import 'still_transition.dart';

/// Plays [children] in sequence, or all at once when travel is not allowed.
///
/// One clock drives every child, so a reduced or off scope cannot leave the
/// later children waiting on a stagger that was cancelled.
class StillStagger extends StatefulWidget {
  /// Creates a stagger.
  const StillStagger({
    super.key,
    required this.children,
    this.motion = StillMotion.slideUp,
    this.duration,
    this.stagger,
    this.travel,
    this.spacing = 12,
    this.axis = Axis.vertical,
  });

  /// Children in entrance order.
  final List<Widget> children;

  /// Travel used while motion is allowed.
  final StillMotion motion;

  /// Length of one child's entrance. Defaults to [MotionScheme.medium].
  final Duration? duration;

  /// Gap between children. Defaults to [MotionScheme.stagger], and drops to
  /// zero when the scope is not traveling.
  final Duration? stagger;

  /// Slide distance in logical pixels. Defaults to [MotionScheme.travel].
  final double? travel;

  /// Space between children, in logical pixels.
  final double spacing;

  /// Direction of the list. The entrance itself is controlled by [motion].
  final Axis axis;

  @override
  State<StillStagger> createState() => _StillStaggerState();
}

class _StillStaggerState extends State<StillStagger>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  var _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    final totalUs = _timeline(MotionScope.of(context)).totalUs;
    if (totalUs == 0) {
      _controller.duration = const Duration(milliseconds: 1);
      _controller.value = 1;
    } else {
      _controller.duration = Duration(microseconds: totalUs);
      _controller.forward(from: 0);
    }
    _started = true;
  }

  _Timeline _timeline(Motion motion) {
    final base = motion.resolve(widget.duration ?? motion.scheme.medium);
    final step = motion.effect == MotionEffect.full
        ? widget.stagger ?? motion.scheme.stagger
        : Duration.zero;
    final count = widget.children.length;
    final baseUs = base.inMicroseconds;
    final stepUs = step.inMicroseconds;
    final totalUs = count == 0 ? 0 : baseUs + stepUs * (count - 1);
    return _Timeline(totalUs: totalUs, baseUs: baseUs, stepUs: stepUs);
  }

  @override
  Widget build(BuildContext context) {
    final motion = MotionScope.of(context);
    final timeline = _timeline(motion);
    final tiles = <Widget>[];
    for (var i = 0; i < widget.children.length; i++) {
      if (i > 0 && widget.spacing > 0) {
        tiles.add(
          SizedBox(
            width: widget.axis == Axis.horizontal ? widget.spacing : 0,
            height: widget.axis == Axis.vertical ? widget.spacing : 0,
          ),
        );
      }
      final begin = timeline.totalUs == 0
          ? 0.0
          : (timeline.stepUs * i) / timeline.totalUs;
      final end = timeline.totalUs == 0
          ? 1.0
          : (timeline.stepUs * i + timeline.baseUs) / timeline.totalUs;
      tiles.add(
        StillTransition(
          animation: _controller,
          motion: widget.motion,
          travel: widget.travel,
          intervalBegin: begin,
          intervalEnd: end.clamp(0.0, 1.0),
          child: widget.children[i],
        ),
      );
    }

    if (widget.axis == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: tiles,
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: tiles,
    );
  }
}

class _Timeline {
  const _Timeline({
    required this.totalUs,
    required this.baseUs,
    required this.stepUs,
  });

  final int totalUs;
  final int baseUs;
  final int stepUs;
}
