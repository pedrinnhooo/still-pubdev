import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:still/still.dart';

import 'support.dart';

void main() {
  testWidgets('platform follows reduce motion and remove animations', (
    tester,
  ) async {
    late Motion motion;

    Future<void> pump(MotionPreference preference) {
      return tester.pumpWidget(
        MotionScope(
          preference: preference,
          child: Builder(
            builder: (context) {
              motion = MotionScope.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
    }

    await pump(MotionPreference.platform);
    expect(motion.effect, MotionEffect.full);

    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(reduceMotion: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await pump(MotionPreference.platform);
    expect(motion.effect, MotionEffect.fade);

    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(
      reduceMotion: true,
      disableAnimations: true,
    );
    await pump(MotionPreference.platform);
    expect(motion.effect, MotionEffect.none);

    await pump(MotionPreference.full);
    expect(
      motion.effect,
      MotionEffect.full,
      reason: 'full keeps travel even when Reduce Motion is on',
    );

    await pump(MotionPreference.reduced);
    expect(motion.effect, MotionEffect.fade);

    await pump(MotionPreference.off);
    expect(motion.effect, MotionEffect.none);
  });

  testWidgets('a MediaQuery disableAnimations override wins', (tester) async {
    late Motion motion;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MotionScope(
          child: Builder(
            builder: (context) {
              motion = MotionScope.of(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(motion.effect, MotionEffect.none);
  });

  testWidgets('full slide travels and then settles', (tester) async {
    const box = Key('box');
    await tester.pumpWidget(
      hosted(
        const StillEntrance(child: SizedBox(key: box, width: 8, height: 8)),
        scheme: const MotionScheme(travel: 48),
      ),
    );

    final start = nearest<Transform>(tester, find.byKey(box));
    expect(start, isNotNull);
    expect(start!.transform.getTranslation().y, greaterThan(20));
    expect(nearest<Opacity>(tester, find.byKey(box))!.opacity, lessThan(0.5));

    await tester.pump(const Duration(milliseconds: 280));

    expect(
      nearest<Transform>(tester, find.byKey(box))!.transform.getTranslation().y,
      lessThan(1),
    );
    expect(
        nearest<Opacity>(tester, find.byKey(box))!.opacity, greaterThan(0.95));
  });

  testWidgets('reduced motion fades in place', (tester) async {
    const box = Key('box');
    await tester.pumpWidget(
      hosted(
        const StillEntrance(child: SizedBox(key: box, width: 8, height: 8)),
        preference: MotionPreference.reduced,
      ),
    );
    await tester.pump(const Duration(milliseconds: 40));

    expect(nearest<Transform>(tester, find.byKey(box)), isNull);
    final opacity = nearest<Opacity>(tester, find.byKey(box))!.opacity;
    expect(opacity, greaterThan(0));
    expect(opacity, lessThan(1));
  });

  testWidgets('off shows the child immediately', (tester) async {
    const box = Key('box');
    await tester.pumpWidget(
      hosted(
        const StillEntrance(child: SizedBox(key: box, width: 8, height: 8)),
        preference: MotionPreference.off,
      ),
    );

    expect(find.byKey(box), findsOneWidget);
    expect(nearest<Opacity>(tester, find.byKey(box)), isNull);
    expect(nearest<Transform>(tester, find.byKey(box)), isNull);
  });

  testWidgets('switcher slides the incoming child', (tester) async {
    Future<void> show(Widget child) {
      return tester.pumpWidget(
        hosted(StillSwitcher(motion: StillMotion.slideUp, child: child)),
      );
    }

    await show(const Text('one', key: ValueKey('one')));
    await tester.pump();
    await show(const Text('two', key: ValueKey('two')));
    await tester.pump(const Duration(milliseconds: 40));

    expect(find.text('two'), findsOneWidget);
    expect(
      nearest<Transform>(tester, find.text('two'))!
          .transform
          .getTranslation()
          .y,
      greaterThan(0),
    );

    await tester.pumpWidget(
      hosted(
        const StillSwitcher(child: Text('three', key: ValueKey('three'))),
        preference: MotionPreference.off,
      ),
    );
    await tester.pump();
    await tester.pumpWidget(
      hosted(
        const StillSwitcher(child: Text('four', key: ValueKey('four'))),
        preference: MotionPreference.off,
      ),
    );
    await tester.pump();

    expect(find.text('four'), findsOneWidget);
    expect(nearest<Opacity>(tester, find.text('four')), isNull);
  });

  testWidgets('stagger waits only while travel is allowed', (tester) async {
    Widget stagger(MotionPreference preference) {
      return hosted(
        StillStagger(
          key: ValueKey(preference),
          duration: const Duration(milliseconds: 100),
          stagger: const Duration(milliseconds: 100),
          children: const [
            SizedBox(key: Key('c0'), width: 8, height: 8),
            SizedBox(key: Key('c1'), width: 8, height: 8),
            SizedBox(key: Key('c2'), width: 8, height: 8),
          ],
        ),
        preference: preference,
      );
    }

    await tester.pumpWidget(stagger(MotionPreference.full));
    await tester.pump(const Duration(milliseconds: 50));

    expect(nearest<Opacity>(tester, find.byKey(const Key('c0')))!.opacity,
        greaterThan(0));
    expect(nearest<Opacity>(tester, find.byKey(const Key('c1')))!.opacity, 0);
    expect(nearest<Opacity>(tester, find.byKey(const Key('c2')))!.opacity, 0);

    await tester.pumpWidget(stagger(MotionPreference.reduced));
    await tester.pump(const Duration(milliseconds: 50));

    final first =
        nearest<Opacity>(tester, find.byKey(const Key('c0')))!.opacity;
    final second =
        nearest<Opacity>(tester, find.byKey(const Key('c1')))!.opacity;
    expect(first, greaterThan(0));
    expect(second, closeTo(first, 0.001));
    expect(nearest<Transform>(tester, find.byKey(const Key('c0'))), isNull);
  });

  testWidgets('missing scope explains itself', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: StillEntrance(child: SizedBox.shrink()),
      ),
    );

    final Object? exception = tester.takeException();
    expect(exception, isFlutterError);
    expect('$exception', contains('no MotionScope'));
  });
}
