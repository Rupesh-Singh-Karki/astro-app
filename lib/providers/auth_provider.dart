import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/dummy_auth_repository.dart';
import '../utils/result.dart';
import '../utils/logger.dart';

/// Provider for the AuthRepository instance
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return DummyAuthRepository();
});

/// State notifier for authentication
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier(this._repository) : super(const AsyncValue.loading()) {
    _initializeAuth();
  }

  final AuthRepository _repository;

  /// Initialize authentication state
  Future<void> _initializeAuth() async {
    state = const AsyncValue.loading();
    final result = await _repository.getCurrentUser();
    
    state = result.when(
      success: (user) => AsyncValue.data(user),
      failure: (failure) {
        AppLogger.error('Failed to initialize auth: ${failure.message}');
        return const AsyncValue.data(null);
      },
    );
  }

  /// Sign in with email and password
  Future<Result<User>> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    
    final result = await _repository.signIn(
      email: email,
      password: password,
    );

    state = result.when(
      success: (user) => AsyncValue.data(user),
      failure: (failure) {
        AppLogger.error('Sign in failed: ${failure.message}');
        return const AsyncValue.data(null);
      },
    );

    return result;
  }

  /// Sign up with email and password
  Future<Result<User>> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AsyncValue.loading();
    
    final result = await _repository.signUp(
      email: email,
      password: password,
      name: name,
    );

    state = result.when(
      success: (user) => AsyncValue.data(user),
      failure: (failure) {
        AppLogger.error('Sign up failed: ${failure.message}');
        return const AsyncValue.data(null);
      },
    );

    return result;
  }

  /// Sign out
  Future<Result<void>> signOut() async {
    final result = await _repository.signOut();
    
    if (result.isSuccess) {
      state = const AsyncValue.data(null);
    }

    return result;
  }

  /// Update user profile
  Future<Result<User>> updateProfile(User user) async {
    final result = await _repository.updateProfile(user);
    
    if (result.isSuccess) {
      state = AsyncValue.data(result.data);
    }

    return result;
  }

  /// Send password reset email
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    return await _repository.sendPasswordResetEmail(email);
  }
}

/// Provider for auth state notifier
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Provider for current user (null if not authenticated)
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});
