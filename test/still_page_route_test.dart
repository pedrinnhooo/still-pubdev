import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:still/still.dart';

import 'support.dart';

void main() {
  testWidgets('page route slides from the trailing edge', (tester) async {
    await _open(tester, MotionPreference.full);
    await tester.pump(const Duration(milliseconds: 16));

    final dx = nearest<Transform>(
      tester,
      find.byKey(const Key('arrived')),
    )!
        .transform
        .getTranslation()
        .x;
    expect(dx, greaterThan(20));

    await tester.pump(const Duration(milliseconds: 280));
    expect(
      nearest<Transform>(
        tester,
        find.byKey(const Key('arrived')),
      )!
          .transform
          .getTranslation()
          .x,
      lessThan(1),
    );
  });

  testWidgets('page route flips travel in RTL', (tester) async {
    await _open(tester, MotionPreference.full,
        textDirection: TextDirection.rtl);
    await tester.pump(const Duration(milliseconds: 16));

    expect(
      nearest<Transform>(
        tester,
        find.byKey(const Key('arrived')),
      )!
          .transform
          .getTranslation()
          .x,
      lessThan(0),
    );
  });

  testWidgets('reduced page route fades without travel', (tester) async {
    await _open(tester, MotionPreference.reduced);
    await tester.pump(const Duration(milliseconds: 40));

    expect(
        nearest<Transform>(tester, find.byKey(const Key('arrived'))), isNull);
    final opacity =
        nearest<Opacity>(tester, find.byKey(const Key('arrived')))!.opacity;
    expect(opacity, greaterThan(0));
    expect(opacity, lessThan(1));
  });

  testWidgets('off page route is already there', (tester) async {
    await _open(tester, MotionPreference.off);

    expect(find.byKey(const Key('arrived')), findsOneWidget);
    expect(nearest<Opacity>(tester, find.byKey(const Key('arrived'))), isNull);
    expect(
        nearest<Transform>(tester, find.byKey(const Key('arrived'))), isNull);
  });
}

Future<void> _open(
  WidgetTester tester,
  MotionPreference preference, {
  TextDirection textDirection = TextDirection.ltr,
}) async {
  await tester.pumpWidget(
    MotionScope(
      preference: preference,
      child: MaterialApp(
        builder: (context, child) {
          return Directionality(textDirection: textDirection, child: child!);
        },
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  StillPageRoute<void>(
                    builder: (_) => const Text('arrived', key: Key('arrived')),
                  ),
                );
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pump();
}
