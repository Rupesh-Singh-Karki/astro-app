import '../models/chat_message.dart';
import '../repositories/chat_repository.dart';
import '../utils/result.dart';
import '../utils/logger.dart';

/// Implementation of ChatRepository using dummy/mock data.
class DummyChatRepository implements ChatRepository {
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      text: 'Hello, I am your virtual astrologer. How can I assist you today?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      fromUser: false,
      senderName: 'Astro Guide',
    ),
  ];

  @override
  Future<Result<List<ChatMessage>>> getMessages() async {
    try {
      AppLogger.debug('Fetching messages');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      return Result.success(List.unmodifiable(_messages));
    } catch (e, stackTrace) {
      AppLogger.error('Get messages error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Failed to fetch messages', error: e),
      );
    }
  }

  @override
  Future<Result<ChatMessage>> sendMessage(String text) async {
    try {
      AppLogger.info('Sending message: ${text.substring(0, text.length > 50 ? 50 : text.length)}');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));

      // Create user message
      final userMessage = ChatMessage.userMessage(text: text);
      _messages.add(userMessage);

      // Simulate astrologer reply after a delay
      Future.delayed(const Duration(milliseconds: 600), () {
        final reply = ChatMessage.astrologerMessage(
          text: _generateAstrologerReply(text),
          senderName: 'Astro Guide',
        );
        _messages.add(reply);
      });

      AppLogger.info('Message sent successfully');
      return Result.success(userMessage);
    } catch (e, stackTrace) {
      AppLogger.error('Send message error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Failed to send message', error: e),
      );
    }
  }

  @override
  Future<Result<List<ChatMessage>>> getChatHistory({
    int limit = 50,
    String? before,
  }) async {
    try {
      AppLogger.debug('Fetching chat history (limit: $limit)');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Return messages with pagination
      final messages = _messages.take(limit).toList();
      return Result.success(messages);
    } catch (e, stackTrace) {
      AppLogger.error('Get chat history error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Failed to fetch chat history', error: e),
      );
    }
  }

  @override
  Future<Result<void>> markAsRead(List<String> messageIds) async {
    try {
      AppLogger.debug('Marking ${messageIds.length} messages as read');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 200));

      for (final id in messageIds) {
        final index = _messages.indexWhere((msg) => msg.id == id);
        if (index != -1) {
          _messages[index] = _messages[index].copyWith(isRead: true);
        }
      }

      return Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error('Mark as read error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Failed to mark messages as read', error: e),
      );
    }
  }

  @override
  Future<Result<void>> deleteMessage(String messageId) async {
    try {
      AppLogger.info('Deleting message: $messageId');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      _messages.removeWhere((msg) => msg.id == messageId);

      AppLogger.info('Message deleted successfully');
      return Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error('Delete message error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Failed to delete message', error: e),
      );
    }
  }

  @override
  Future<Result<void>> clearMessages() async {
    try {
      AppLogger.info('Clearing all messages');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      _messages.clear();

      AppLogger.info('Messages cleared successfully');
      return Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error('Clear messages error', e, stackTrace);
      return Result.failure(
        UnexpectedFailure(message: 'Failed to clear messages', error: e),
      );
    }
  }

  /// Generate a simple astrologer reply based on user input
  String _generateAstrologerReply(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('career') || lowerMessage.contains('job')) {
      return 'Your professional path is illuminated by cosmic alignments. Focus on opportunities appearing in the coming weeks. ✨';
    } else if (lowerMessage.contains('love') || lowerMessage.contains('relationship')) {
      return 'The stars suggest a period of emotional growth. Keep your heart open to new possibilities! 💫';
    } else if (lowerMessage.contains('health') || lowerMessage.contains('wellness')) {
      return 'Balance is key for your well-being. The planetary positions encourage mindful practices and self-care. 🌟';
    } else if (lowerMessage.contains('finance') || lowerMessage.contains('money')) {
      return 'Financial stability is within reach. The cosmic energies support careful planning and wise decisions. 💰';
    } else {
      return 'Thank you for your question. The celestial bodies reveal interesting insights about your journey. Would you like to know more? ✨';
    }
  }
}
