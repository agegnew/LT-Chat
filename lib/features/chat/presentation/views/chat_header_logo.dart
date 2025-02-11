import 'package:flutter/material.dart';

class ChatHeaderLogo extends StatefulWidget {
  const ChatHeaderLogo({Key? key}) : super(key: key);

  @override
  _ChatHeaderLogoState createState() => _ChatHeaderLogoState();
}

class _ChatHeaderLogoState extends State<ChatHeaderLogo>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final Animation<double> _rotationAnimation;

  late final AnimationController _glowController;
  late final Animation<Color?> _glowColor1;
  late final Animation<Color?> _glowColor2;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowColor1 = ColorTween(
      begin: Colors.cyanAccent,
      end: Colors.purpleAccent,
    ).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _glowColor2 = ColorTween(
      begin: Colors.purpleAccent,
      end: Colors.cyanAccent,
    ).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                RotationTransition(
                  turns: _rotationAnimation,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          _glowColor1.value ?? Colors.cyanAccent,
                          _glowColor2.value ?? Colors.purpleAccent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_glowColor1.value ?? Colors.cyanAccent)
                              .withOpacity(0.8),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const CircleAvatar(
                  radius: 90,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
