import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageInputBar extends StatefulWidget {
  final Function(String) onSend;

  const MessageInputBar({Key? key, required this.onSend}) : super(key: key);

  @override
  _MessageInputBarState createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // OPTIONAL: Add icons for file uploads or voice recording here
          // IconButton(
          //   icon: const Icon(Icons.attach_file, color: Colors.cyanAccent),
          //   onPressed: () {
          //     // TODO: Implement file picker & upload logic
          //   },
          // ),
          // IconButton(
          //   icon: const Icon(Icons.mic, color: Colors.cyanAccent),
          //   onPressed: () {
          //     // TODO: Implement voice recording logic
          //   },
          // ),

          Expanded(
            child: TextField(
              controller: _controller,
              style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: GoogleFonts.pressStart2p(
                  fontSize: 10,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.cyanAccent),
            onPressed: _handleSend,
          ),
        ],
      ),
    );
  }
}
