import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'chat_event.dart';
part 'chat_state.dart';
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final WebSocketChannel channel;
  final String userId; // This parameter is defined

  ChatBloc({required this.channel, required this.userId}) : super(ChatInitial());

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is SendMessage) {
      final messageWithUserId = '${event.userId}: ${event.message}';
      channel.sink.add(messageWithUserId);
      yield ChatMessageSent(message: event.message, userId: event.userId, messages: state.messages);
    } else if (event is ReceiveMessage) {
      yield ChatMessageReceived(message: event.message, userId: event.userId, messages: state.messages);
    }
  }
}
