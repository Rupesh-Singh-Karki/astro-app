import '../models/user.dart';
import '../utils/result.dart';

/// Repository for authentication-related data operations.
///
/// This repository handles the data layer for authentication,
/// abstracting away the data source details.
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Result<User>> signIn({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<Result<User>> signUp({
    required String email,
    required String password,
    String? name,
  });

  /// Sign out the current user
  Future<Result<void>> signOut();

  /// Get the currently authenticated user
  Future<Result<User?>> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Send password reset email
  Future<Result<void>> sendPasswordResetEmail(String email);

  /// Update user profile
  Future<Result<User>> updateProfile(User user);
}
