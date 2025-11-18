import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../providers/api_provider.dart';
import '../utils/logger.dart';

/// Chat session model
class ChatSessionModel {
  final String id;
  final String title;
  final DateTime createdAt;
  final int messageCount;

  const ChatSessionModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messageCount,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      messageCount: json['message_count'] as int? ?? 0,
    );
  }
}

/// Chat sessions provider
final chatSessionsProvider = FutureProvider<List<ChatSessionModel>>((
  ref,
) async {
  final chatApiService = ref.watch(chatApiServiceProvider);

  final result = await chatApiService.getChatSessions(limit: 50);

  return result.when(
    success: (data) {
      final sessions = (data as List)
          .map(
            (json) => ChatSessionModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      AppLogger.info('Loaded ${sessions.length} chat sessions');
      return sessions;
    },
    failure: (failure) {
      AppLogger.error('Failed to load chat sessions: ${failure.message}');
      throw failure;
    },
  );
});

/// Current session ID provider
final currentSessionIdProvider = StateProvider<String?>((ref) => null);

/// Typing indicator state provider
final isAiTypingProvider = StateProvider<bool>((ref) => false);

/// Predefined question provider for quick actions
final predefinedQuestionProvider = StateProvider<String?>((ref) => null);

/// Chat messages state for current session
class ChatMessagesNotifier
    extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  ChatMessagesNotifier(this._ref) : super(const AsyncValue.data([]));

  final Ref _ref;

  /// Load messages for a specific session
  Future<void> loadSession(String sessionId) async {
    state = const AsyncValue.loading();

    final chatApiService = _ref.read(chatApiServiceProvider);
    final result = await chatApiService.getChatSession(sessionId);

    result.when(
      success: (data) {
        final messages = (data['messages'] as List).map((msg) {
          final sender = (msg['sender'] as String).toLowerCase();

          return ChatMessage(
            id: msg['id'] as String,
            text: msg['message'] as String,
            fromUser: sender == 'user',
            timestamp: DateTime.parse(msg['created_at'] as String),
          );
        }).toList();

        state = AsyncValue.data(messages);
        AppLogger.info(
          'Loaded ${messages.length} messages for session $sessionId',
        );
      },
      failure: (failure) {
        AppLogger.error('Failed to load session: ${failure.message}');
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  /// Send a message to the astrologer
  Future<void> sendMessage(
    String text, {
    required int birthYear,
    required int birthMonth,
    required int birthDay,
    required int birthHour,
    required int birthMinute,
    required double latitude,
    required double longitude,
    required String timezone,
  }) async {
    if (text.trim().isEmpty) return;

    // Add user message optimistically
    state.whenData((messages) {
      final userMessage = ChatMessage(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        fromUser: true,
        timestamp: DateTime.now(),
      );
      state = AsyncValue.data([...messages, userMessage]);
    });

    // Set typing indicator
    _ref.read(isAiTypingProvider.notifier).state = true;

    // Get current session ID
    final sessionId = _ref.read(currentSessionIdProvider);

    // Call API
    final chatApiService = _ref.read(chatApiServiceProvider);
    final result = await chatApiService.chatWithAstrologer(
      birthYear: birthYear,
      birthMonth: birthMonth,
      birthDay: birthDay,
      birthHour: birthHour,
      birthMinute: birthMinute,
      latitude: latitude,
      longitude: longitude,
      timezone: timezone,
      question: text,
      sessionId: sessionId,
    );

    result.when(
      success: (data) {
        _ref.read(isAiTypingProvider.notifier).state = false;

        final newSessionId = data['session_id'] as String;
        final answer = data['answer'] as String;

        // Update session ID if this was a new conversation
        if (sessionId == null) {
          _ref.read(currentSessionIdProvider.notifier).state = newSessionId;
          // Refresh sessions list
          _ref.invalidate(chatSessionsProvider);
        }

        // Add AI response
        state.whenData((messages) {
          // Remove temp message and add real messages
          final filteredMessages = messages
              .where((m) => !m.id.startsWith('temp_'))
              .toList();

          final userMessage = ChatMessage(
            id: 'user_${DateTime.now().millisecondsSinceEpoch}',
            text: text,
            fromUser: true,
            timestamp: DateTime.now(),
          );

          final aiMessage = ChatMessage(
            id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
            text: answer,
            fromUser: false,
            timestamp: DateTime.now(),
          );

          state = AsyncValue.data([
            ...filteredMessages,
            userMessage,
            aiMessage,
          ]);
        });

        AppLogger.info('Message sent successfully');
      },
      failure: (failure) {
        _ref.read(isAiTypingProvider.notifier).state = false;

        // Remove temp message on error
        state.whenData((messages) {
          final filteredMessages = messages
              .where((m) => !m.id.startsWith('temp_'))
              .toList();
          state = AsyncValue.data(filteredMessages);
        });

        AppLogger.error('Failed to send message: ${failure.message}');

        // Add error message
        state.whenData((messages) {
          final errorMessage = ChatMessage(
            id: 'error_${DateTime.now().millisecondsSinceEpoch}',
            text: 'Failed to send message: ${failure.displayMessage}',
            fromUser: false,
            timestamp: DateTime.now(),
          );
          state = AsyncValue.data([...messages, errorMessage]);
        });
      },
    );
  }

  /// Start a new chat session
  void startNewSession() {
    _ref.read(currentSessionIdProvider.notifier).state = null;
    state = const AsyncValue.data([]);
  }

  /// Delete a chat session
  Future<bool> deleteSession(String sessionId) async {
    final chatApiService = _ref.read(chatApiServiceProvider);
    final result = await chatApiService.deleteSession(sessionId);

    return result.when(
      success: (_) {
        // If deleted session is current, clear it
        final currentId = _ref.read(currentSessionIdProvider);
        if (currentId == sessionId) {
          _ref.read(currentSessionIdProvider.notifier).state = null;
          state = const AsyncValue.data([]);
        }

        // Refresh sessions list
        _ref.invalidate(chatSessionsProvider);

        AppLogger.info('Session deleted successfully: $sessionId');
        return true;
      },
      failure: (failure) {
        AppLogger.error('Failed to delete session: ${failure.message}');
        return false;
      },
    );
  }

  /// Delete a specific message from the current session
  Future<bool> deleteMessage(String messageId) async {
    final sessionId = _ref.read(currentSessionIdProvider);
    if (sessionId == null) {
      AppLogger.error('No active session to delete message from');
      return false;
    }

    final chatApiService = _ref.read(chatApiServiceProvider);
    final result = await chatApiService.deleteMessage(sessionId, messageId);

    return result.when(
      success: (_) {
        // Remove message from local state
        state.whenData((messages) {
          final updatedMessages = messages
              .where((m) => m.id != messageId)
              .toList();
          state = AsyncValue.data(updatedMessages);
        });

        AppLogger.info('Message deleted successfully: $messageId');
        return true;
      },
      failure: (failure) {
        AppLogger.error('Failed to delete message: ${failure.message}');
        return false;
      },
    );
  }
}

/// Provider for chat messages
final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesNotifier, AsyncValue<List<ChatMessage>>>((
      ref,
    ) {
      return ChatMessagesNotifier(ref);
    });
