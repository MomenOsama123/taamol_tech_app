// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taamol_tech/main.dart';

void main() {
  testWidgets('Onboarding advances to the next slide', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TkamolTechApp());
    await tester.pumpAndSettle();

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('التالي'), findsOneWidget);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();

    expect(find.text('الطابعات والأحبار ومستلزمات المكاتب'), findsOneWidget);
  });
}
