import 'package:flutter/foundation.dart';

import '../../core/models/chat_message.dart';

class ChatController extends ChangeNotifier {
  final List<ChatMessage> _messages;

  ChatController({List<ChatMessage>? initialMessages})
      : _messages = List.of(initialMessages ?? const []);

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void sendUserMessage(String text) {
    final content = text.trim();
    if (content.isEmpty) return;
    _messages.add(
      ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: content,
        timestamp: DateTime.now(),
        fromUser: true,
      ),
    );
    notifyListeners();

    // Simulate astrologer reply
    Future.delayed(const Duration(milliseconds: 600), () {
      _messages.add(
        ChatMessage(
          id: '${DateTime.now().microsecondsSinceEpoch}-bot',
          text: 'Thanks for your message. Your stars are aligning! ✨',
          timestamp: DateTime.now(),
          fromUser: false,
        ),
      );
      notifyListeners();
    });
  }
}
