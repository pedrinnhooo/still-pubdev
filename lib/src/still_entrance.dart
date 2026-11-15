import 'package:flutter/widgets.dart';

import 'motion.dart';
import 'motion_scope.dart';
import 'still_transition.dart';

/// Brings [child] in once.
///
/// Changing the [Key] plays the entrance again. A Reduce Motion scope fades
/// the child in place. An off scope shows it immediately.
class StillEntrance extends StatefulWidget {
  /// Creates an entrance.
  const StillEntrance({
    super.key,
    required this.child,
    this.motion = StillMotion.slideUp,
    this.duration,
    this.delay = Duration.zero,
    this.travel,
  });

  /// The widget shown at rest.
  final Widget child;

  /// Travel used while motion is allowed.
  final StillMotion motion;

  /// Length of the entrance. Defaults to [MotionScheme.medium].
  final Duration? duration;

  /// Wait before the entrance. Ignored unless travel is allowed.
  final Duration delay;

  /// Slide distance in logical pixels. Defaults to [MotionScheme.travel].
  final double? travel;

  @override
  State<StillEntrance> createState() => _StillEntranceState();
}

class _StillEntranceState extends State<StillEntrance>
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
    final motion = MotionScope.of(context);
    final duration = motion.resolve(widget.duration ?? motion.scheme.medium);
    final delay = motion.resolveDelay(widget.delay);
    final total = duration + delay;
    if (total == Duration.zero) {
      _controller.duration = const Duration(milliseconds: 1);
      _controller.value = 1;
      _started = true;
      return;
    }
    _controller.duration = total;
    _started = true;
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final motion = MotionScope.of(context);
    final duration = motion.resolve(widget.duration ?? motion.scheme.medium);
    final delay = motion.resolveDelay(widget.delay);
    final totalUs = (duration + delay).inMicroseconds;
    final begin = totalUs == 0 ? 0.0 : delay.inMicroseconds / totalUs;
    return StillTransition(
      animation: _controller,
      motion: widget.motion,
      travel: widget.travel,
      intervalBegin: begin,
      intervalEnd: 1,
      child: widget.child,
    );
  }
}
