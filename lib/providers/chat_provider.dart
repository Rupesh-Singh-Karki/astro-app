import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../repositories/chat_repository.dart';
import '../repositories/dummy_chat_repository.dart';
import '../utils/result.dart';
import '../utils/logger.dart';

/// Provider for the ChatRepository instance
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return DummyChatRepository();
});

/// State notifier for chat messages
class ChatNotifier extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  ChatNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadMessages();
  }

  final ChatRepository _repository;

  /// Load messages
  Future<void> _loadMessages() async {
    state = const AsyncValue.loading();

    final result = await _repository.getMessages();

    state = result.when(
      success: (messages) => AsyncValue.data(messages),
      failure: (failure) {
        AppLogger.error('Failed to load messages: ${failure.message}');
        return AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  /// Send a message
  Future<Result<ChatMessage>> sendMessage(String text) async {
    if (text.trim().isEmpty) {
      return Result.failure(
        ValidationFailure(message: 'Message cannot be empty'),
      );
    }

    final result = await _repository.sendMessage(text.trim());

    if (result.isSuccess) {
      // Add the new message to the state
      state.whenData((messages) {
        state = AsyncValue.data([...messages, result.data]);
      });

      // Simulate astrologer reply after a delay
      Future.delayed(const Duration(milliseconds: 700), () {
        _loadMessages(); // Reload to get the reply
      });
    }

    return result;
  }

  /// Delete a message
  Future<Result<void>> deleteMessage(String messageId) async {
    final result = await _repository.deleteMessage(messageId);

    if (result.isSuccess) {
      state.whenData((messages) {
        state = AsyncValue.data(
          messages.where((msg) => msg.id != messageId).toList(),
        );
      });
    }

    return result;
  }

  /// Clear all messages
  Future<Result<void>> clearMessages() async {
    final result = await _repository.clearMessages();

    if (result.isSuccess) {
      state = const AsyncValue.data([]);
    }

    return result;
  }

  /// Refresh messages
  Future<void> refresh() async {
    await _loadMessages();
  }
}

/// Provider for chat state notifier
final chatProvider =
    StateNotifierProvider<ChatNotifier, AsyncValue<List<ChatMessage>>>((ref) {
      final repository = ref.watch(chatRepositoryProvider);
      return ChatNotifier(repository);
    });

/// Provider for unread message count
final unreadMessagesCountProvider = Provider<int>((ref) {
  final chatState = ref.watch(chatProvider);
  return chatState.when(
    data: (messages) =>
        messages.where((msg) => !msg.isRead && !msg.fromUser).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});
