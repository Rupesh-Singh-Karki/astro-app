import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/main_scaffold_screen.dart';

/// Entry point of the application
void main() {
  runApp(
    const ProviderScope(
      child: TrustAstrologyApp(),
    ),
  );
}

/// Root widget of the application
class TrustAstrologyApp extends ConsumerWidget {
  const TrustAstrologyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return MaterialApp(
      title: 'TrustAstrology',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light, // Can be changed to ThemeMode.system
      home: isAuthenticated ? const MainScaffoldScreen() : const LoginScreen(),
    );
  }
}
