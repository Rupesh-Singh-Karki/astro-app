import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_controller.dart';
import 'features/auth/login_page.dart';
import 'features/main_scaffold.dart';
import 'features/chat/chat_controller.dart';
import 'core/repositories/dummy_data.dart';

void main() {
  runApp(const TrustAstrologyApp());
}

class TrustAstrologyApp extends StatelessWidget {
  const TrustAstrologyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ChatController(initialMessages: DummyData.initialMessages())),
      ],
      child: Consumer<AuthController>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'TrustAstrology',
            theme: AppTheme.light,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            home: auth.isLoggedIn ? const MainScaffold() : const LoginPage(),
          );
        },
      ),
    );
  }
}
