import '../models/chat_message.dart';
import '../utils/result.dart';

/// Repository for chat-related data operations.
///
/// This repository handles the data layer for chat functionality.
abstract class ChatRepository {
  /// Get all messages for the current user
  Future<Result<List<ChatMessage>>> getMessages();

  /// Send a message
  Future<Result<ChatMessage>> sendMessage(String text);

  /// Get chat history with pagination
  Future<Result<List<ChatMessage>>> getChatHistory({
    int limit = 50,
    String? before,
  });

  /// Mark messages as read
  Future<Result<void>> markAsRead(List<String> messageIds);

  /// Delete a message
  Future<Result<void>> deleteMessage(String messageId);

  /// Clear all messages
  Future<Result<void>> clearMessages();
}
