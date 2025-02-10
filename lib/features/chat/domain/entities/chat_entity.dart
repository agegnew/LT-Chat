class ChatEntity {
  final String chatId;
  final String chatName;
  final String? lastMessage;
  final DateTime timestamp;
  final String? avatarUrl; // Profile avatar URL.
  final String? partnerId; // NEW: Unique identifier for the chat partner.

  ChatEntity({
    required this.chatId,
    required this.chatName,
    this.lastMessage,
    required this.timestamp,
    this.avatarUrl,
    this.partnerId,
  });
}
