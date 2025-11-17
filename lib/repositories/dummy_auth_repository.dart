import '../models/user.dart';
import '../repositories/auth_repository.dart';
import '../utils/result.dart';
import '../utils/logger.dart';

/// Implementation of AuthRepository using dummy/mock data.
///
/// This implementation simulates API calls with delays and provides
/// dummy data for development and testing purposes.
class DummyAuthRepository implements AuthRepository {
  // Simulated in-memory storage
  User? _currentUser;
  final Map<String, String> _users = {
    'test@example.com': 'password123',
  };

  @override
  Future<Result<User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Attempting sign in for: $email');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Validate credentials
      if (_users.containsKey(email) && _users[email] == password) {
        _currentUser = User(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          email: email,
          name: email.split('@').first,
          createdAt: DateTime.now(),
        );

        AppLogger.info('Sign in successful for: $email');
        return Result.success(_currentUser!);
      }

      AppLogger.warning('Sign in failed: Invalid credentials for $email');
      return Result.failure(
        AuthFailure(message: 'Invalid email or password'),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Sign in error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Failed to sign in', error: e),
      );
    }
  }

  @override
  Future<Result<User>> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      AppLogger.info('Attempting sign up for: $email');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 700));

      // Check if user already exists
      if (_users.containsKey(email)) {
        AppLogger.warning('Sign up failed: User already exists $email');
        return Result.failure(
          ValidationFailure(
            message: 'An account with this email already exists',
          ),
        );
      }

      // Register new user
      _users[email] = password;
      _currentUser = User(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        email: email,
        name: name ?? email.split('@').first,
        createdAt: DateTime.now(),
      );

      AppLogger.info('Sign up successful for: $email');
      return Result.success(_currentUser!);
    } catch (e, stackTrace) {
      AppLogger.error('Sign up error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Failed to sign up', error: e),
      );
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      AppLogger.info('Signing out user: ${_currentUser?.email}');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      _currentUser = null;
      
      AppLogger.info('Sign out successful');
      return Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error('Sign out error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Failed to sign out', error: e),
      );
    }
  }

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      AppLogger.debug('Getting current user');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 200));

      return Result.success(_currentUser);
    } catch (e, stackTrace) {
      AppLogger.error('Get current user error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Failed to get current user', error: e),
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      AppLogger.debug('Checking authentication status');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 100));

      return _currentUser != null;
    } catch (e, stackTrace) {
      AppLogger.error('Is authenticated check error', e, stackTrace);
      return false;
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      AppLogger.info('Sending password reset email to: $email');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (!_users.containsKey(email)) {
        AppLogger.warning('Password reset failed: User not found $email');
        return Result.failure(
          NotFoundFailure(message: 'No account found with this email'),
        );
      }

      AppLogger.info('Password reset email sent to: $email');
      return Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error('Send password reset email error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(
          message: 'Failed to send password reset email',
          error: e,
        ),
      );
    }
  }

  @override
  Future<Result<User>> updateProfile(User user) async {
    try {
      AppLogger.info('Updating profile for user: ${user.email}');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (_currentUser?.id != user.id) {
        return Result.failure(
          AuthFailure(message: 'Unauthorized to update this profile'),
        );
      }

      _currentUser = user;
      
      AppLogger.info('Profile updated successfully for: ${user.email}');
      return Result.success(_currentUser!);
    } catch (e, stackTrace) {
      AppLogger.error('Update profile error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Failed to update profile', error: e),
      );
    }
  }
}
