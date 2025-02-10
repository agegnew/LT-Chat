// lib/features/chat/data/repositories/chat_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/chat_entity.dart'; // <-- new import
import '../../domain/repositories/chat_repository.dart';
import '../sources/chat_remote_data_source.dart';
import '../models/message_model.dart';
import '../models/chat_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, List<MessageEntity>>> getMessages() async {
    try {
      final modelList = await remoteDataSource.fetchMessages();
      final entities = modelList.map(_mapModelToEntity).toList();
      return Right(entities);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, MessageEntity>> sendMessage(MessageEntity entity) async {
    try {
      final model = _mapEntityToModel(entity);
      final sentModel = await remoteDataSource.sendMessage(model);
      final sentEntity = _mapModelToEntity(sentModel);
      return Right(sentEntity);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  // =============== NEW METHOD ===============
  @override
  Future<Either<Exception, List<ChatEntity>>> getChats() async {
    try {
      // 1) Fetch from remote data source
      final chatModels = await remoteDataSource.fetchChats();

      // 2) Convert ChatModel -> ChatEntity
      final entities = chatModels.map(_mapChatModelToEntity).toList();

      // 3) Return Right side of Either
      return Right(entities);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  // =============== Private helpers ===============
  MessageEntity _mapModelToEntity(MessageModel model) {
    return MessageEntity(
      id: model.id,
      content: model.text ?? '',
      timestamp: model.timestamp,
      senderId: model.senderId,
      receiverId: model.receiverId,
      fileUrl: model.fileUrl,
    );
  }

  MessageModel _mapEntityToModel(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      text: entity.content,
      fileUrl: entity.fileUrl,
      senderId: entity.senderId,
      receiverId: entity.receiverId,
      timestamp: entity.timestamp,
    );
  }

  ChatEntity _mapChatModelToEntity(ChatModel model) {
    return ChatEntity(
      chatId: model.chatId,
      chatName: model.chatName,
      lastMessage: model.lastMessage,
      timestamp: model.timestamp,
    );
  }
}
