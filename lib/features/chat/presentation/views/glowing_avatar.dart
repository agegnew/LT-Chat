import 'package:flutter/material.dart';

class GlowingAvatar extends StatelessWidget {
  final double radius;
  final ImageProvider image;

  const GlowingAvatar({
    Key? key,
    required this.radius,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
