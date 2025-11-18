import 'dart:convert';
import '../services/api_service.dart';
import '../utils/logger.dart';
import '../utils/result.dart';

/// Authentication API service
class AuthApiService {
  final ApiService _apiService;

  AuthApiService(this._apiService);

  /// Send OTP to email
  Future<Result<Map<String, dynamic>>> sendOtp(String email) async {
    try {
      final response = await _apiService.post(
        '/auth/send-otp',
        body: {'email': email},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AppLogger.info('OTP sent to $email');
        return Result.success(data);
      } else {
        final error = jsonDecode(response.body);
        return Result.failure(
          ApiFailure(
            message: error['detail'] ?? 'Failed to send OTP',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Send OTP error', e, stackTrace);

      // Better error message for network issues
      String errorMessage = 'Network error. Please check your connection.';
      if (e.toString().contains('Cannot connect to server')) {
        errorMessage =
            'Cannot connect to server. Make sure the backend is running.';
      }

      return Result.failure(UnexpectedFailure(message: errorMessage, error: e));
    }
  }

  /// Verify OTP and get access token
  Future<Result<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/verify-otp',
        body: {'email': email, 'otp': otp},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['access_token'];

        // Store the token in API service
        _apiService.setAccessToken(accessToken);

        AppLogger.info('OTP verified for $email');
        return Result.success(data);
      } else {
        final error = jsonDecode(response.body);
        return Result.failure(
          ApiFailure(
            message: error['detail'] ?? 'Invalid OTP',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Verify OTP error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Network error', error: e),
      );
    }
  }

  /// Get current user info
  Future<Result<Map<String, dynamic>>> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/me', requiresAuth: true);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Result.success(data);
      } else {
        final error = jsonDecode(response.body);
        return Result.failure(
          ApiFailure(
            message: error['detail'] ?? 'Failed to get user',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Get current user error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Network error', error: e),
      );
    }
  }

  /// Register user details
  Future<Result<Map<String, dynamic>>> registerDetails({
    required String fullName,
    required String gender,
    required String maritalStatus,
    required String dateOfBirth,
    required String timeOfBirth,
    required String placeOfBirth,
    required String timezone,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/register-details',
        requiresAuth: true,
        body: {
          'full_name': fullName,
          'gender': gender,
          'marital_status': maritalStatus,
          'date_of_birth': dateOfBirth,
          'time_of_birth': timeOfBirth,
          'place_of_birth': placeOfBirth,
          'timezone': timezone,
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        AppLogger.info('User details registered');
        return Result.success(data);
      } else {
        final error = jsonDecode(response.body);
        return Result.failure(
          ApiFailure(
            message: error['detail'] ?? 'Failed to register details',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Register details error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Network error', error: e),
      );
    }
  }

  /// Get user details
  Future<Result<Map<String, dynamic>>> getUserDetails() async {
    try {
      final response = await _apiService.get(
        '/auth/user-details',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Result.success(data);
      } else if (response.statusCode == 404) {
        return Result.failure(
          ApiFailure(message: 'User details not found', statusCode: 404),
        );
      } else {
        final error = jsonDecode(response.body);
        return Result.failure(
          ApiFailure(
            message: error['detail'] ?? 'Failed to get user details',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Get user details error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Network error', error: e),
      );
    }
  }

  /// Update user details (all fields optional)
  Future<Result<Map<String, dynamic>>> updateUserDetails({
    String? fullName,
    String? gender,
    String? maritalStatus,
    String? dateOfBirth,
    String? timeOfBirth,
    String? placeOfBirth,
    String? timezone,
  }) async {
    try {
      // Build request body with only non-null fields
      final Map<String, dynamic> body = {};

      if (fullName != null) body['full_name'] = fullName;
      if (gender != null) body['gender'] = gender;
      if (maritalStatus != null) body['marital_status'] = maritalStatus;
      if (dateOfBirth != null) body['date_of_birth'] = dateOfBirth;
      if (timeOfBirth != null) body['time_of_birth'] = timeOfBirth;
      if (placeOfBirth != null) body['place_of_birth'] = placeOfBirth;
      if (timezone != null) body['timezone'] = timezone;

      final response = await _apiService.put(
        '/auth/user-details',
        requiresAuth: true,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AppLogger.info('User details updated');
        return Result.success(data);
      } else if (response.statusCode == 404) {
        return Result.failure(
          ApiFailure(
            message: 'User details not found. Please register details first.',
            statusCode: 404,
          ),
        );
      } else {
        final error = jsonDecode(response.body);
        return Result.failure(
          ApiFailure(
            message: error['detail'] ?? 'Failed to update user details',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Update user details error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Network error', error: e),
      );
    }
  }

  /// Logout
  Future<Result<void>> logout() async {
    try {
      final response = await _apiService.post(
        '/auth/logout',
        requiresAuth: true,
        body: {},
      );

      if (response.statusCode == 200) {
        _apiService.setAccessToken(null);
        AppLogger.info('User logged out');
        return Result.success(null);
      } else {
        return Result.failure(
          ApiFailure(
            message: 'Failed to logout',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Logout error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Network error', error: e),
      );
    }
  }

  /// Verify token
  Future<Result<Map<String, dynamic>>> verifyToken() async {
    try {
      final response = await _apiService.get(
        '/auth/verify-token',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Result.success(data);
      } else {
        return Result.failure(
          ApiFailure(message: 'Invalid token', statusCode: response.statusCode),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Verify token error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Network error', error: e),
      );
    }
  }
}

/// API failure type
class ApiFailure extends AppFailure {
  final int statusCode;

  ApiFailure({required super.message, this.statusCode = 500, super.error});

  @override
  String get displayMessage => message;
}
