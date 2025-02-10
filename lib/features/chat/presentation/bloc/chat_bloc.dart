// lib/features/chat/presentation/bloc/chat_bloc.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/repositories/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<FetchMessagesEvent>((event, emit) async {
      emit(ChatLoading());
      final eitherMessages = await chatRepository.getMessages();
      eitherMessages.fold(
            (error) => emit(ChatError(error.toString())),
            (messages) => emit(ChatLoaded(messages)),
      );
    });

    on<SendMessageEvent>((event, emit) async {
      emit(ChatLoading());
      final eitherSent = await chatRepository.sendMessage(event.message);
      eitherSent.fold(
            (error) => emit(ChatError(error.toString())),
            (sentMessage) {
          if (state is ChatLoaded) {
            final updatedMessages =
            List<MessageEntity>.from((state as ChatLoaded).messages)
              ..add(sentMessage);
            emit(ChatLoaded(updatedMessages));
          } else {
            emit(ChatLoaded([sentMessage]));
          }
        },
      );
    });

    // ================== NEW ==================
    on<FetchChatListEvent>((event, emit) async {
      // Optionally, you can create a separate "ChatListLoading" state
      emit(ChatLoading());

      final eitherChats = await chatRepository.getChats();
      eitherChats.fold(
            (error) => emit(ChatError(error.toString())),
            (chats) => emit(ChatListLoaded(chats)),
      );
    });
  }
}
