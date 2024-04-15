part of 'chat_bloc.dart';

abstract class ChatEvent {
  final String userId;
  ChatEvent({required this.userId});
}

class SendMessage extends ChatEvent {
  final String message;

  SendMessage({required String userId, required this.message}) : super(userId: userId);
}

class ReceiveMessage extends ChatEvent {
  final String message;

  ReceiveMessage({required String userId, required this.message}) : super(userId: userId);
}
