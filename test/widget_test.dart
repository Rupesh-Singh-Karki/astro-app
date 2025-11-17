// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:astrology/main.dart';

void main() {
  testWidgets('App renders Login screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TrustAstrologyApp()));

    // Wait for all async operations to complete
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('TrustAstrology'), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
