import 'dart:async';
import 'dart:convert'; // for jsonEncode/jsonDecode
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../data/sources/chat_socket_data_source.dart';
import '../views/message_list_view.dart';
import '../views/message_input_bar.dart';

class MessagePage extends StatefulWidget {
  final ChatEntity chat;

  const MessagePage({Key? key, required this.chat}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final ChatSocketDataSource _chatSocketDataSource = ChatSocketDataSource();

  // Local list of messages we display
  List<MessageEntity> _messages = [];

  // Subscription to socket stream
  StreamSubscription? _socketSubscription;

  // Current user id (hardcoded for demo)
  static const String currentUserId = 'user1';

  @override
  void initState() {
    super.initState();
    _initMessages();
    _setupSocket();
  }

  /// Seed the page with some initial messages (similar to your existing logic).
  void _initMessages() {
    final chatId = widget.chat.chatId;
    if (chatId == "chat1") {
      _messages = [
        MessageEntity(
          id: '1',
          content: 'Hi Alice, how are you?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          senderId: 'user1',
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
    } else if (chatId == "chat2") {
      _messages = [
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
    } else if (chatId == "chat3") {
      _messages = [
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
      _messages = [
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

  /// Connect to the socket and listen for incoming messages
  void _setupSocket() {
    _chatSocketDataSource.connect();
    _socketSubscription = _chatSocketDataSource.messagesStream.listen((data) {
      // Assume data is JSON from the server. Parse it:
      try {
        final jsonData = jsonDecode(data);
        // For example, if the server sends:
        // {
        //   "id": "unique_id",
        //   "content": "Hello from server",
        //   "timestamp": 123456789,
        //   "senderId": "bob_id",
        //   "receiverId": "user1"
        // }
        final newMessage = MessageEntity(
          id: jsonData['id'],
          content: jsonData['content'],
          timestamp: DateTime.fromMillisecondsSinceEpoch(jsonData['timestamp']),
          senderId: jsonData['senderId'],
          receiverId: jsonData['receiverId'],
          fileUrl: jsonData['fileUrl'],
        );

        // Optionally, check if this message belongs to the current chat
        if (newMessage.receiverId == currentUserId ||
            newMessage.senderId == currentUserId) {
          setState(() {
            _messages.add(newMessage);
          });
        }
      } catch (e) {
        // Handle parsing error or unexpected data
        debugPrint('Error parsing incoming data: $e');
      }
    });
  }

  /// Sends a message both locally and over the socket
  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final newMessage = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text.trim(),
      timestamp: DateTime.now(),
      senderId: currentUserId,
      receiverId: widget.chat.partnerId ?? widget.chat.chatId,
      fileUrl: null,
    );

    // Update local state
    setState(() {
      _messages.add(newMessage);
    });

    // Convert message to JSON and send to the WebSocket server
    final messageJson = jsonEncode({
      'id': newMessage.id,
      'content': newMessage.content,
      'timestamp': newMessage.timestamp.millisecondsSinceEpoch,
      'senderId': newMessage.senderId,
      'receiverId': newMessage.receiverId,
      'fileUrl': newMessage.fileUrl,
    });
    _chatSocketDataSource.send(messageJson);
  }

  @override
  void dispose() {
    _socketSubscription?.cancel();
    _chatSocketDataSource.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            // You can replace this with your GlowingAvatar widget if desired:
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.chat.avatarUrl != null
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
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: MessageListView(
              messages: _messages,
              currentUserId: currentUserId,
              avatarImage: widget.chat.avatarUrl != null
                  ? NetworkImage(widget.chat.avatarUrl!)
                  : const AssetImage('assets/avatar.jpg') as ImageProvider,
            ),
          ),

          // Message Input Bar
          MessageInputBar(
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
