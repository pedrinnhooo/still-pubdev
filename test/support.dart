import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:still/still.dart';

T? nearest<T extends Widget>(WidgetTester tester, Finder of) {
  T? found;
  tester.element(of).visitAncestorElements((ancestor) {
    final widget = ancestor.widget;
    if (widget is T) {
      found = widget;
      return false;
    }
    return true;
  });
  return found;
}

Widget hosted(Widget child,
    {MotionPreference preference = MotionPreference.full,
    MotionScheme scheme = MotionScheme.standard}) {
  return MotionScope(
    preference: preference,
    scheme: scheme,
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}
