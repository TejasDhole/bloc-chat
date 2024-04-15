// services/web_socket_service.dart
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel channel;

  WebSocketService(this.channel);

  Stream<dynamic> get stream => channel.stream;

  void sendMessage(String message) {
    channel.sink.add(message);
  }
}
