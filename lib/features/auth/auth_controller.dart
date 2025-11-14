import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  bool _loggedIn = false;
  String? _email;

  bool get isLoggedIn => _loggedIn;
  String? get email => _email;

  Future<void> login(String email, String password) async {
    // Simulate async auth
    await Future.delayed(const Duration(milliseconds: 500));
    _email = email;
    _loggedIn = true;
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _email = email;
    _loggedIn = true;
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    _email = null;
    notifyListeners();
  }
}
