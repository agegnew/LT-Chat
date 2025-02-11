import 'package:flutter/material.dart';
import '../../domain/entities/message_entity.dart';

class MessageStatusIcon extends StatelessWidget {
  final MessageStatus status;

  const MessageStatusIcon({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color = Colors.white;

    switch (status) {
      case MessageStatus.sending:
        icon = Icons.access_time;    // clock
        break;
      case MessageStatus.sent:
        icon = Icons.check;          // one check
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;       // two checks
        break;
      case MessageStatus.read:
        icon = Icons.done_all;       // two checks
        color = Colors.blueAccent;   // or some highlight
        break;
    }

    return Icon(icon, size: 16, color: color);
  }
}
