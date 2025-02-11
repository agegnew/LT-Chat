import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/message_entity.dart';

class MessageItem extends StatelessWidget {
  final MessageEntity message;
  final bool isSentByMe;
  final ImageProvider avatarImage;

  const MessageItem({
    Key? key,
    required this.message,
    required this.isSentByMe,
    required this.avatarImage,
  }) : super(key: key);

  Widget _buildGlowingAvatar({required double radius, required ImageProvider image}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Colors.cyanAccent, Colors.purpleAccent],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.8),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: image,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
        isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSentByMe)
            _buildGlowingAvatar(radius: 15, image: avatarImage),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: isSentByMe ? Colors.cyanAccent : const Color(0xFFFF41FB),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isSentByMe ? const Radius.circular(20) : Radius.zero,
                  bottomRight: isSentByMe ? Radius.zero : const Radius.circular(20),
                ),
              ),
              child: Text(
                message.content,
                style: GoogleFonts.pressStart2p(
                  fontSize: 10,
                  color: isSentByMe ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isSentByMe)
            _buildGlowingAvatar(radius: 15, image: avatarImage),
        ],
      ),
    );
  }
}
