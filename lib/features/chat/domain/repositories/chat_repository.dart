// lib/features/chat/domain/repositories/chat_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/message_entity.dart';
import '../entities/chat_entity.dart';

abstract class ChatRepository {
  Future<Either<Exception, List<MessageEntity>>> getMessages();
  Future<Either<Exception, MessageEntity>> sendMessage(MessageEntity message);
  Future<Either<Exception, List<ChatEntity>>> getChats();

}
