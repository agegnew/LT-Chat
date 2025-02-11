import 'package:flutter/material.dart';
import '../../domain/entities/message_entity.dart';
import 'message_item.dart';

class MessageListView extends StatelessWidget {
  final List<MessageEntity> messages;
  final String currentUserId;
  final ImageProvider avatarImage;

  const MessageListView({
    Key? key,
    required this.messages,
    required this.currentUserId,
    required this.avatarImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isSentByMe = message.senderId == currentUserId;

        return MessageItem(
          message: message,
          isSentByMe: isSentByMe,
          avatarImage: avatarImage,
        );
      },
    );
  }
}
