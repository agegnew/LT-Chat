// message_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/features/chat/domain/entities/chat_entity.dart';
import '/features/chat/domain/entities/message_entity.dart';

class MessagePage extends StatefulWidget {
  final ChatEntity chat;

  const MessagePage({Key? key, required this.chat}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<MessageEntity> messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Simulate conversation-specific messages based on the chat's id.
    if (widget.chat.chatId == "chat1") {
      // Conversation with Alice.
      messages = [
        MessageEntity(
          id: '1',
          content: 'Hi Alice, how are you?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          senderId: 'user1', // current user
          receiverId: 'alice_id',
          fileUrl: null,
        ),
        MessageEntity(
          id: '2',
          content: 'Hi! I\'m great, thanks for asking.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          senderId: 'alice_id',
          receiverId: 'user1',
          fileUrl: null,
        ),
      ];
    } else if (widget.chat.chatId == "chat2") {
      // Conversation with Bob.
      messages = [
        MessageEntity(
          id: '3',
          content: 'Hey Bob, are you free this weekend?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          senderId: 'user1',
          receiverId: 'bob_id',
          fileUrl: null,
        ),
        MessageEntity(
          id: '4',
          content: 'Sure, let\'s catch up!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
          senderId: 'bob_id',
          receiverId: 'user1',
          fileUrl: null,
        ),
      ];
    } else if (widget.chat.chatId == "chat3") {
      // Conversation with Carol.
      messages = [
        MessageEntity(
          id: '5',
          content: 'Hey Carol, long time no see!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
          senderId: 'user1',
          receiverId: 'carol_id',
          fileUrl: null,
        ),
        MessageEntity(
          id: '6',
          content: 'Indeed, how have you been?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          senderId: 'carol_id',
          receiverId: 'user1',
          fileUrl: null,
        ),
      ];
    } else {
      // Default conversation if none match.
      messages = [
        MessageEntity(
          id: '7',
          content: 'Hello, this is the default conversation.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
          senderId: 'user1',
          receiverId: widget.chat.partnerId ?? widget.chat.chatId,
          fileUrl: null,
        ),
      ];
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      messages.add(MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _controller.text.trim(),
        timestamp: DateTime.now(),
        senderId: 'user1',
        // Use partnerId so that the message goes to the conversation partner.
        receiverId: widget.chat.partnerId ?? widget.chat.chatId,
        fileUrl: null,
      ));
    });
    _controller.clear();
  }

  // Helper for a glowing avatar with gradient border and shadow.
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
    const currentUserId = 'user1';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // Show the chat partner’s glowing avatar and chat name.
        title: Row(
          children: [
            _buildGlowingAvatar(
              radius: 20,
              image: widget.chat.avatarUrl != null
                  ? NetworkImage(widget.chat.avatarUrl!)
                  : const AssetImage('assets/avatar.jpg') as ImageProvider,
            ),
            const SizedBox(width: 8),
            Text(
              widget.chat.chatName,
              style: GoogleFonts.pressStart2p(
                fontSize: 16,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Message list.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSentByMe = message.senderId == currentUserId;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isSentByMe)
                        _buildGlowingAvatar(
                          radius: 15,
                          image: widget.chat.avatarUrl != null
                              ? NetworkImage(widget.chat.avatarUrl!)
                              : const AssetImage('assets/avatar.jpg') as ImageProvider,
                        ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSentByMe ? Colors.cyanAccent : Color(0xFFFF41FB),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: isSentByMe ? const Radius.circular(20) : const Radius.circular(0),
                              bottomRight: isSentByMe ? const Radius.circular(0) : const Radius.circular(20),
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
                        _buildGlowingAvatar(
                          radius: 15,
                          image: const AssetImage('assets/avatar.jpg'),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Message input area.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.grey[900],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: GoogleFonts.pressStart2p(
                      fontSize: 10,
                      color: Colors.white,
                    ),
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
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
