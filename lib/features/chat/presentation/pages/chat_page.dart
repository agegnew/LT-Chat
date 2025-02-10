import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '/features/chat/domain/entities/chat_entity.dart';
import '../bloc/chat_bloc.dart';
import 'message_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  // Controls the slow rotation behind the logo.
  late final AnimationController _rotationController;
  late final Animation<double> _rotationAnimation;

  // Controls the pulsing glow color behind the logo.
  late final AnimationController _glowController;
  late final Animation<Color?> _glowColor1;
  late final Animation<Color?> _glowColor2;

  // For bottom navigation state (e.g., 0 = Home, 1 = Messages).
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Dispatch the event to fetch the chat list when the page initializes.
    context.read<ChatBloc>().add(FetchChatListEvent());

    // 1. Controller for the rotating circle behind the logo.
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // A slow 20-second rotation
    );

    // Rotate from 0 to 1 (a full 360 degrees) repeatedly.
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _rotationController.repeat(); // Start the rotation indefinitely.

    // 2. Controller for pulsing glow colors in the background gradient.
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Shorter, repeated pulse
    )..repeat(reverse: true);

    // Animate from cyanAccent -> purpleAccent for color1,
    // simultaneously from purpleAccent -> cyanAccent for color2.
    // Then it reverses, creating a pulsing color shift.
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

  /// Helper method to build a glowing avatar with gradient border and shadow.
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

  /// Large rotating (and pulsing) glowing logo at the top of the list.
  Widget _buildHeaderLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            // Rebuild each time the glow color pulses.
            return Stack(
              alignment: Alignment.center,
              children: [
                // Rotating glowing circle behind the logo
                RotationTransition(
                  turns: _rotationAnimation, // Slow rotation
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

  /// Single chat item with a fade-and-slide entrance animation + on-tap ripple.
  Widget _buildAnimatedChatItem(ChatEntity chat, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)),
      // Stagger the start slightly for each item
      curve: Curves.easeOut,
      builder: (context, value, child) {
        // 'value' goes from 0 -> 1 during animation
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)), // Slide upward
            child: child,
          ),
        );
      },
      child: Material(
        // Wrap in Material so InkWell can show a ripple.
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to the MessagePage for the selected chat.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MessagePage(chat: chat),
              ),
            );
          },
          child: Stack(
            children: [
              // The colorful gradient behind the card to achieve a glow effect
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purpleAccent, Colors.cyanAccent],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              // Actual chat list item
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 2,
                    color: Colors.purpleAccent,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Glowing avatar for the chat partner
                    _buildGlowingAvatar(
                      radius: 30,
                      image: chat.avatarUrl != null
                          ? NetworkImage(chat.avatarUrl!)
                          : const AssetImage('assets/avatar.jpg')
                      as ImageProvider,
                    ),
                    const SizedBox(width: 20),
                    // Chat name + last message
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat.chatName,
                            style: GoogleFonts.pressStart2p(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 5,
                            width: 80,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.cyanAccent, Colors.purpleAccent],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purpleAccent.withOpacity(0.6),
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            chat.lastMessage ?? '',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the main content of the page: the header logo + the chat list.
  Widget _buildChatList() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        } else if (state is ChatListLoaded) {
          final chats = state.chats;
          // We add 1 extra item count for the top logo.
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: chats.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // First item: the rotating/pulsing logo
                return _buildHeaderLogo();
              } else {
                final chat = chats[index - 1];
                return _buildAnimatedChatItem(chat, index);
              }
            },
          );
        } else {
          return const Center(
            child: Text(
              'No data yet',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }

  /// Handles taps on the bottom navigation bar.
  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // In a real app, you'd navigate or show different pages here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Remove the hamburger menu by omitting the Drawer entirely.
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        // Hide the leading drawer button.
        automaticallyImplyLeading: false,
        title: Text(
          "Chats",
          style: GoogleFonts.pressStart2p(
            fontSize: 16,
            color: Colors.cyanAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildChatList(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Messages",
          ),
        ],
      ),
    );
  }
}
