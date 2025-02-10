import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/message_model.dart';

// 1) Import ChatModel
import '../models/chat_model.dart';

abstract class ChatRemoteDataSource {
  /// Fetch messages from the backend.
  Future<List<MessageModel>> fetchMessages();

  /// Send a message to the backend.
  Future<MessageModel> sendMessage(MessageModel message);

  // NEW: Fetch a list of chats
  Future<List<ChatModel>> fetchChats();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MessageModel>> fetchMessages() async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null) {
        throw Exception('BASE_URL not found in .env');
      }

      final response = await dio.get('$baseUrl/messages');
      final data = response.data as List<dynamic>;
      return data.map((jsonItem) => MessageModel.fromJson(jsonItem)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MessageModel> sendMessage(MessageModel message) async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null) {
        throw Exception('BASE_URL not found in .env');
      }

      final response = await dio.post(
        '$baseUrl/messages',
        data: message.toJson(),
      );
      return MessageModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // NEW: fetchChats()
  @override
  Future<List<ChatModel>> fetchChats() async {
    try {
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null) {
        throw Exception('BASE_URL not found in .env');
      }

      // For example, the endpoint could be /chats
      final response = await dio.get('$baseUrl/chats');

      /*
        The mock JSON you showed is something like:
        {
          "messages": [...],
          "chats": [
             { "chatId": "chat1", "chatName": "Alice", ... }
          ]
        }
        If your endpoint returns just an array of chats, fine;
        but if the entire JSON includes "chats" as a field,
        you'll need to parse accordingly.
      */

      // If the endpoint directly returns List<ChatModel>, do:
      final data = response.data as List<dynamic>;
      return data.map((jsonItem) => ChatModel.fromJson(jsonItem)).toList();

      // If your endpoint returns a JSON object with a "chats" field, do something like:
      // final Map<String, dynamic> jsonObj = response.data;
      // final List<dynamic> chatsArray = jsonObj["chats"];
      // return chatsArray.map((e) => ChatModel.fromJson(e)).toList();

    } catch (e) {
      rethrow;
    }
  }
}
