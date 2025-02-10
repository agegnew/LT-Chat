// lib/features/chat/data/models/chat_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatModel {
  final String chatId;
  final String chatName;
  final String? lastMessage;
  // The mock JSON has a "timestamp" string in ISO format (e.g., "2025-02-02T10:00:00Z")
  final DateTime timestamp;

  ChatModel({
    required this.chatId,
    required this.chatName,
    this.lastMessage,
    required this.timestamp,
  });

  // JSON serialization
  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}
