import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/api_provider.dart';
import '../utils/logger.dart';

/// Authentication state
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = true,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Authentication state notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._ref) : super(const AuthState()) {
    _initializeAuth();
  }

  final Ref _ref;
  static const String _tokenKey = 'auth_token';

  /// Initialize authentication state by checking stored token
  Future<void> _initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token != null && token.isNotEmpty) {
        // Set token in API service
        _ref.read(apiServiceProvider).setAccessToken(token);

        // Verify token with backend
        final authApiService = _ref.read(authApiServiceProvider);
        final result = await authApiService.verifyToken();

        result.when(
          success: (_) {
            AppLogger.info('Token verified successfully');
            state = state.copyWith(isAuthenticated: true, isLoading: false);
          },
          failure: (failure) {
            AppLogger.warning('Token verification failed: ${failure.message}');
            // Token is invalid, clear it
            _clearToken();
            state = state.copyWith(isAuthenticated: false, isLoading: false);
          },
        );
      } else {
        state = state.copyWith(isAuthenticated: false, isLoading: false);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error initializing auth', e, stackTrace);
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: 'Failed to initialize authentication',
      );
    }
  }

  /// Store authentication token
  Future<void> setToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      _ref.read(apiServiceProvider).setAccessToken(token);
      state = state.copyWith(isAuthenticated: true);
      AppLogger.info('Token stored successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Error storing token', e, stackTrace);
    }
  }

  /// Clear authentication token
  Future<void> _clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      _ref.read(apiServiceProvider).setAccessToken(null);
      AppLogger.info('Token cleared');
    } catch (e, stackTrace) {
      AppLogger.error('Error clearing token', e, stackTrace);
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Call logout API
      final authApiService = _ref.read(authApiServiceProvider);
      await authApiService.logout();
    } catch (e) {
      AppLogger.warning('Logout API call failed: $e');
      // Continue with local logout even if API fails
    }

    // Clear token locally
    await _clearToken();
    state = state.copyWith(isAuthenticated: false);
    AppLogger.info('User logged out');
  }

  /// Refresh authentication state
  Future<void> refresh() async {
    await _initializeAuth();
  }
}

/// Provider for authentication state
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((
  ref,
) {
  return AuthStateNotifier(ref);
});
