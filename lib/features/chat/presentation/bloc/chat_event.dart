// ------------------------
// chat_event.dart
// ------------------------
part of 'chat_bloc.dart';

abstract class ChatEvent {}

class FetchMessagesEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final MessageEntity message;

  SendMessageEvent(this.message);
}
class FetchChatListEvent extends ChatEvent {}
