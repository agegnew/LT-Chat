enum MessageStatus { sending, sent, delivered, read }

class MessageEntity {
  final String id;
  final String content;
  final DateTime timestamp;
  final String senderId;
  final String receiverId;
  final String? fileUrl; // For attachments like images, docs, etc.
  final MessageStatus status;  // new field

  MessageEntity({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.senderId,
    required this.receiverId,
    this.fileUrl,
    this.status = MessageStatus.sending,
  });
}
