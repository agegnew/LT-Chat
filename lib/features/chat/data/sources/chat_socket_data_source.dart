import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatSocketDataSource {
  WebSocketChannel? _channel;
  Stream? _stream;

  /// Connect to the WebSocket server
  void connect() {
    // Load the URL from .env
    final socketUrl = dotenv.env['SOCKET_URL'];

    if (socketUrl == null) {
      throw Exception('SOCKET_URL not found in .env');
    }

    // If we're not already connected, connect now
    if (_channel == null) {
      _channel = IOWebSocketChannel.connect(socketUrl);
      // Convert _channel.stream to a broadcast stream, so multiple listeners can subscribe
      _stream = _channel?.stream.asBroadcastStream();
    }
  }

  /// Returns a broadcast stream of data from the socket
  Stream get messagesStream {
    if (_stream == null) {
      throw Exception('WebSocket not connected. Call connect() first.');
    }
    return _stream!;
  }

  /// Send a message to the WebSocket server
  void send(dynamic data) {
    _channel?.sink.add(data);
  }

  /// Close the WebSocket connection
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _stream = null;
  }
}
