// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      chatId: json['chatId'] as String,
      chatName: json['chatName'] as String,
      lastMessage: json['lastMessage'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'chatId': instance.chatId,
      'chatName': instance.chatName,
      'lastMessage': instance.lastMessage,
      'timestamp': instance.timestamp.toIso8601String(),
    };
