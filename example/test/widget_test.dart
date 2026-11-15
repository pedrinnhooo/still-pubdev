import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:still_example/main.dart';

void main() {
  testWidgets('preference toggle changes the motion decision', (tester) async {
    await tester.pumpWidget(const StillGalleryApp());
    await tester.pump();

    expect(
      find.text('Motion should carry meaning, or get out of the way.'),
      findsOneWidget,
    );
    expect(
      find.text('O movimento deve carregar sentido ou sair do caminho.'),
      findsNothing,
    );
    expect(
      find.text('Travel is on. Slides, scale, and stagger run.'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('Reduced'));
    await tester.tap(find.text('Reduced'));
    await tester.pump();

    expect(
      find.text('Travel is off. What remains is a cross-fade.'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('Off'));
    await tester.tap(find.text('Off'));
    await tester.pump();

    expect(
      find.text('Nothing animates. The next state is already there.'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(const Key('next-quote')));
    await tester.tap(find.byKey(const Key('next-quote')));
    await tester.pump();

    expect(find.text('A cross-fade is still a transition.'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('open-route')));
    await tester.tap(find.byKey(const Key('open-route')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('This page used a short slide'), findsOneWidget);
  });

  testWidgets('proposal dialog explains the package in both languages', (
    tester,
  ) async {
    await tester.pumpWidget(const StillGalleryApp());
    await tester.pump();

    await tester.tap(find.text('The proposal'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 320));

    expect(find.text('PROPOSAL'), findsOneWidget);
    expect(find.textContaining('still makes that choice once'), findsOneWidget);
    expect(
      find.textContaining('O still toma essa decisão uma vez'),
      findsNothing,
    );
  });

  testWidgets('translation button switches the gallery language', (
    tester,
  ) async {
    await tester.pumpWidget(const StillGalleryApp());
    await tester.pump();

    await tester.tap(find.byKey(const Key('translate')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('Português').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.text('O movimento deve carregar sentido ou sair do caminho.'),
      findsOneWidget,
    );
    expect(
      find.text('Motion should carry meaning, or get out of the way.'),
      findsNothing,
    );
    expect(find.text('PT'), findsOneWidget);
  });

  testWidgets('gallery lays out on phone, tablet, and desktop', (tester) async {
    final sizes = <Size>[
      const Size(320, 700),
      const Size(390, 844),
      const Size(768, 1024),
      const Size(1024, 768),
      const Size(1366, 1024),
    ];
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final size in sizes) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(StillGalleryApp(key: ValueKey(size)));
      await tester.pump();
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(const Key('open-proposal')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 320));
      expect(tester.takeException(), isNull);

      await tester.tap(find.byTooltip('Close'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 320));

      await tester.tap(find.byKey(const Key('translate')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('Português').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.byKey(const Key('open-route')));
      await tester.tap(find.byKey(const Key('open-route')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    }
  });
}
