import 'package:flutter/material.dart';
import '../../features/auth/login_page.dart';
import '../../features/auth/signup_page.dart';
import '../../features/main_scaffold.dart';
import '../../features/chat/chat_page.dart';
import '../../features/plans/plans_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/language/language_page.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const chat = '/chat';
  static const plans = '/plans';
  static const settingsRoute = '/settings';
  static const language = '/language';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _build(const LoginPage());
      case signup:
        return _build(const SignupPage());
      case home:
        return _build(const MainScaffold());
      case chat:
        return _build(const ChatPage());
      case plans:
        return _build(const PlansPage());
      case settingsRoute:
        return _build(const SettingsPage());
      case language:
        return _build(const LanguagePage());
      default:
        return _build(const LoginPage());
    }
  }

  static MaterialPageRoute _build(Widget child) => MaterialPageRoute(builder: (_) => child);
}
