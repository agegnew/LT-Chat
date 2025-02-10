import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  final String id;
  final String? text;
  final String? fileUrl;
  final String senderId;
  final String receiverId;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    this.text,
    this.fileUrl,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
  });

  // JSON serialization
  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
