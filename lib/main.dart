import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme/app_theme.dart';
import 'providers/auth_state_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/main_scaffold_screen.dart';

/// Entry point of the application
void main() {
  runApp(const ProviderScope(child: TrustAstrologyApp()));
}

/// Root widget of the application
class TrustAstrologyApp extends ConsumerWidget {
  const TrustAstrologyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // Show loading screen while checking authentication
    if (authState.isLoading) {
      return MaterialApp(
        title: 'TrustAstrology',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'TrustAstrology',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light, // Can be changed to ThemeMode.system
      home: authState.isAuthenticated
          ? const MainScaffoldScreen()
          : const LoginScreen(),
    );
  }
}
