import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';
import 'package:still/still.dart';

/// Widget previews for the three effects. Open them from the Flutter previewer.
@Preview(name: 'Full', group: 'still', size: Size(360, 140), wrapper: wrapFull)
Widget fullEntrance() => const PreviewEntrance();

/// Reduced-motion preview.
@Preview(
  name: 'Reduced',
  group: 'still',
  size: Size(360, 140),
  wrapper: wrapReduced,
)
Widget reducedEntrance() => const PreviewEntrance();

/// Animations-off preview.
@Preview(name: 'Off', group: 'still', size: Size(360, 140), wrapper: wrapOff)
Widget offEntrance() => const PreviewEntrance();

/// Wraps a preview in a scope that keeps travel on.
Widget wrapFull(Widget child) => _wrap(MotionPreference.full, child);

/// Wraps a preview in a cross-fade scope.
Widget wrapReduced(Widget child) => _wrap(MotionPreference.reduced, child);

/// Wraps a preview in a scope that cuts.
Widget wrapOff(Widget child) => _wrap(MotionPreference.off, child);

Widget _wrap(MotionPreference preference, Widget child) {
  return MotionScope(
    preference: preference,
    scheme: const MotionScheme(travel: 28),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: const Color(0xFF070B12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: DefaultTextStyle(
            style: const TextStyle(color: Color(0xFFE8F2FC)),
            child: child,
          ),
        ),
      ),
    ),
  );
}

/// The entrance shown by the previews.
class PreviewEntrance extends StatelessWidget {
  /// Creates the preview entrance.
  const PreviewEntrance({super.key});

  @override
  Widget build(BuildContext context) {
    return const StillEntrance(
      motion: StillMotion.slideUp,
      child: Text(
        'Slide, fade, or cut.',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      ),
    );
  }
}
