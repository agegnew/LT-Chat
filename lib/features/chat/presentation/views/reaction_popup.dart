import 'package:flutter/material.dart';

class ReactionPopup extends StatelessWidget {
  final void Function(String) onReactionSelected;

  const ReactionPopup({Key? key, required this.onReactionSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // A simple row of emojis
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Text("👍"),
          onPressed: () => onReactionSelected("👍"),
        ),
        IconButton(
          icon: const Text("❤️"),
          onPressed: () => onReactionSelected("❤️"),
        ),
        IconButton(
          icon: const Text("😂"),
          onPressed: () => onReactionSelected("😂"),
        ),
      ],
    );
  }
}
