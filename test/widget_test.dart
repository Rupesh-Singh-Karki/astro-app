import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:astrology/screens/auth/login_screen.dart';
import 'package:astrology/theme/app_theme.dart';

void main() {
  testWidgets('Login screen renders correctly', (tester) async {
    // Test the LoginScreen widget directly to avoid async provider initialization
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          title: 'TrustAstrology',
          theme: AppTheme.light,
          home: const LoginScreen(),
        ),
      ),
    );

    // Wait for the widget to render
    await tester.pump();

    expect(find.text('TrustAstrology'), findsOneWidget);
    expect(find.text('Sign In or Create Account'), findsOneWidget);
    expect(
      find.text('Enter your email to receive a verification code'),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsOneWidget);
  });
}
