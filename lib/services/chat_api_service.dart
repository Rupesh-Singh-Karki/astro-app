import 'dart:convert';
import '../services/api_service.dart';
import '../utils/logger.dart';
import '../utils/result.dart';

/// Chat API service
class ChatApiService {
  final ApiService _apiService;

  ChatApiService(this._apiService);

  /// Chat with astrologer
  Future<Result<Map<String, dynamic>>> chatWithAstrologer({
    required int birthYear,
    required int birthMonth,
    required int birthDay,
    required int birthHour,
    required int birthMinute,
    required double latitude,
    required double longitude,
    required String timezone,
    required String question,
    String? sessionId,
  }) async {
    try {
      final body = {
        'birth_year': birthYear,
        'birth_month': birthMonth,
        'birth_day': birthDay,
        'birth_hour': birthHour,
        'birth_minute': birthMinute,
        'location': {
          'latitude': latitude,
          'longitude': longitude,
          'timezone': timezone,
        },
        'question': question,
      };

      if (sessionId != null) {
        body['session_id'] = sessionId;
      }

      final response = await _apiService.post(
        '/chat/astrologer',
        requiresAuth: true,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AppLogger.info('Astrologer chat response received');
        return Result.success(data);
      } else {
        final error = jsonDecode(response.body);
        return Result.failure(
          ApiFailure(
            message: error['detail'] ?? 'Failed to get astrologer response',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Chat with astrologer error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Network error', error: e),
      );
    }
  }

  /// Get all chat sessions
  Future<Result<List<Map<String, dynamic>>>> getChatSessions({
    int limit = 50,
  }) async {
    try {
      final response = await _apiService.get(
        '/chat/sessions?limit=$limit',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        AppLogger.info('Retrieved ${data.length} chat sessions');
        return Result.success(data.cast<Map<String, dynamic>>());
      } else {
        final error = jsonDecode(response.body);
        return Result.failure(
          ApiFailure(
            message: error['detail'] ?? 'Failed to get chat sessions',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Get chat sessions error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Network error', error: e),
      );
    }
  }

  /// Get specific chat session with messages
  Future<Result<Map<String, dynamic>>> getChatSession(String sessionId) async {
    try {
      final response = await _apiService.get(
        '/chat/sessions/$sessionId',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AppLogger.info('Retrieved chat session: $sessionId');
        return Result.success(data);
      } else if (response.statusCode == 404) {
        return Result.failure(
          ApiFailure(message: 'Session not found', statusCode: 404),
        );
      } else {
        final error = jsonDecode(response.body);
        return Result.failure(
          ApiFailure(
            message: error['detail'] ?? 'Failed to get chat session',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Get chat session error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Network error', error: e),
      );
    }
  }

  /// Delete a chat session
  Future<Result<void>> deleteSession(String sessionId) async {
    try {
      final response = await _apiService.delete(
        '/chat/sessions/$sessionId',
        requiresAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.info('Deleted chat session: $sessionId');
        return Result.success(null);
      } else if (response.statusCode == 404) {
        return Result.failure(
          ApiFailure(message: 'Session not found', statusCode: 404),
        );
      } else {
        final error = jsonDecode(response.body);
        return Result.failure(
          ApiFailure(
            message: error['detail'] ?? 'Failed to delete chat session',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Delete chat session error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Network error', error: e),
      );
    }
  }

  /// Delete a specific message from a chat session
  Future<Result<void>> deleteMessage(String sessionId, String messageId) async {
    try {
      final response = await _apiService.delete(
        '/chat/sessions/$sessionId/messages/$messageId',
        requiresAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.info('Deleted message: $messageId from session: $sessionId');
        return Result.success(null);
      } else if (response.statusCode == 404) {
        return Result.failure(
          ApiFailure(message: 'Message or session not found', statusCode: 404),
        );
      } else {
        final error = jsonDecode(response.body);
        return Result.failure(
          ApiFailure(
            message: error['detail'] ?? 'Failed to delete message',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Delete message error', e, stackTrace);
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
