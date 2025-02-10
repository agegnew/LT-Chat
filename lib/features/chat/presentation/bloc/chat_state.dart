// ------------------------
// chat_state.dart
// ------------------------
part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MessageEntity> messages;

  ChatLoaded(this.messages);
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}
class ChatListLoaded extends ChatState {
  final List<ChatEntity> chats;
  ChatListLoaded(this.chats);
}