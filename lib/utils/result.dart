/// A sealed class representing the result of an operation that can either succeed or fail.
///
/// This pattern provides type-safe error handling and forces explicit
/// handling of both success and error cases.
///
/// Example usage:
/// ```dart
/// Future<Result<User>> fetchUser(String id) async {
///   try {
///     final user = await api.getUser(id);
///     return Result.success(user);
///   } catch (e) {
///     return Result.failure(AppFailure.unexpected('Failed to fetch user'));
///   }
/// }
///
/// final result = await fetchUser('123');
/// if (result.isSuccess) {
///   print('User: ${result.data.name}');
/// } else {
///   print('Error: ${result.failure.message}');
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// Creates a successful result
  factory Result.success(T data) = Success<T>;

  /// Creates a failed result
  factory Result.failure(AppFailure failure) = Failure<T>;

  /// Returns true if the result is a success
  bool get isSuccess => this is Success<T>;

  /// Returns true if the result is a failure
  bool get isFailure => this is Failure<T>;

  /// Gets the data if success, throws if failure
  T get data {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    throw StateError('Result is not a success');
  }

  /// Gets the failure if failure, throws if success
  AppFailure get failure {
    if (this is Failure<T>) {
      return (this as Failure<T>).error;
    }
    throw StateError('Result is not a failure');
  }

  /// Gets the data if success, or null if failure
  T? get dataOrNull => isSuccess ? data : null;

  /// Gets the failure if failure, or null if success
  AppFailure? get failureOrNull => isFailure ? failure : null;

  /// Maps the data if success, otherwise returns the failure
  Result<R> map<R>(R Function(T data) transform) {
    if (this is Success<T>) {
      return Result.success(transform((this as Success<T>).value));
    }
    return Result.failure((this as Failure<T>).error);
  }

  /// Executes the appropriate callback based on the result type
  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure failure) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).value);
    }
    return failure((this as Failure<T>).error);
  }
}

/// Success result
final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

/// Failure result
final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppFailure error;
}

/// Represents different types of failures that can occur in the application.
abstract class AppFailure {
  const AppFailure({required this.message, this.error});

  final String message;
  final Object? error;

  /// Gets a user-friendly message for display
  String get displayMessage => message;
}

/// Network-related failure
class NetworkFailure extends AppFailure {
  const NetworkFailure({
    super.message = 'Network connection failed',
    super.error,
  });
}

/// Server-related failure
class ServerFailure extends AppFailure {
  const ServerFailure({
    super.message = 'Server error occurred',
    super.error,
  });
}

/// Authentication failure
class AuthFailure extends AppFailure {
  const AuthFailure({
    super.message = 'Authentication failed',
    super.error,
  });
}

/// Not found failure
class NotFoundFailure extends AppFailure {
  const NotFoundFailure({
    super.message = 'Resource not found',
    super.error,
  });
}

/// Validation failure
class ValidationFailure extends AppFailure {
  const ValidationFailure({
    super.message = 'Validation failed',
    this.errors,
    super.error,
  });

  final Map<String, String>? errors;
}

/// Permission denied failure
class PermissionDeniedFailure extends AppFailure {
  const PermissionDeniedFailure({
    super.message = 'Permission denied',
    super.error,
  });
}

/// Timeout failure
class TimeoutFailure extends AppFailure {
  const TimeoutFailure({
    super.message = 'Request timed out',
    super.error,
  });
}

/// Unexpected/unknown failure
class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred',
    super.error,
  });
}
