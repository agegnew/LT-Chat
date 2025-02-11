import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import 'chat_header_logo.dart';
import 'chat_item.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: chats.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // First item: the rotating/pulsing logo
                return const ChatHeaderLogo();
              } else {
                final chat = chats[index - 1];
                return ChatItem(chat: chat, index: index);
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
}
