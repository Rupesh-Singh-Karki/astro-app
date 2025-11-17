/// Represents a chat message in the application.
///
/// Contains message content, metadata, and sender information.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.fromUser,
    this.senderName,
    this.senderImageUrl,
    this.messageType = ChatMessageType.text,
    this.isRead = false,
    this.metadata,
  });

  final String id;
  final String text;
  final DateTime timestamp;
  final bool fromUser;
  final String? senderName;
  final String? senderImageUrl;
  final ChatMessageType messageType;
  final bool isRead;
  final Map<String, dynamic>? metadata;

  /// Creates a copy with updated fields
  ChatMessage copyWith({
    String? id,
    String? text,
    DateTime? timestamp,
    bool? fromUser,
    String? senderName,
    String? senderImageUrl,
    ChatMessageType? messageType,
    bool? isRead,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      fromUser: fromUser ?? this.fromUser,
      senderName: senderName ?? this.senderName,
      senderImageUrl: senderImageUrl ?? this.senderImageUrl,
      messageType: messageType ?? this.messageType,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Creates from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      fromUser: json['fromUser'] as bool,
      senderName: json['senderName'] as String?,
      senderImageUrl: json['senderImageUrl'] as String?,
      messageType: ChatMessageType.values.firstWhere(
        (type) => type.name == json['messageType'],
        orElse: () => ChatMessageType.text,
      ),
      isRead: json['isRead'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'fromUser': fromUser,
      'senderName': senderName,
      'senderImageUrl': senderImageUrl,
      'messageType': messageType.name,
      'isRead': isRead,
      'metadata': metadata,
    };
  }

  /// Factory constructor for user messages
  factory ChatMessage.userMessage({
    required String text,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
      fromUser: true,
      metadata: metadata,
    );
  }

  /// Factory constructor for astrologer/bot messages
  factory ChatMessage.astrologerMessage({
    required String text,
    String? senderName,
    String? senderImageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: '${DateTime.now().microsecondsSinceEpoch}-bot',
      text: text,
      timestamp: DateTime.now(),
      fromUser: false,
      senderName: senderName,
      senderImageUrl: senderImageUrl,
      metadata: metadata,
    );
  }

  @override
  String toString() =>
      'ChatMessage(id: $id, text: ${text.substring(0, text.length > 20 ? 20 : text.length)}..., fromUser: $fromUser)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Types of chat messages
enum ChatMessageType {
  /// Regular text message
  text,

  /// Image message
  image,

  /// System/notification message
  system,

  /// Welcome/greeting message
  greeting,
}
