import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypingIndicator extends StatelessWidget {
  final String userName;  // e.g., "Alice"
  const TypingIndicator({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        children: [
          // Could be an animated dot icon or similar
          const SizedBox(width: 4),
          Text(
            "$userName is typing...",
            style: GoogleFonts.pressStart2p(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
