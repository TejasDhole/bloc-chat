part of 'chat_bloc.dart';

abstract class ChatState {
  final List<String> messages;
  ChatState(this.messages);
}

class ChatInitial extends ChatState {
  ChatInitial() : super([]);
}

class ChatMessageSent extends ChatState {
  final String message;
  final String userId; // Added userId here
  ChatMessageSent({required this.message, required this.userId, required List<String> messages})
      : super([...messages, message]);
}

class ChatMessageReceived extends ChatState {
  final String message;
  final String userId;
  ChatMessageReceived({required this.message, required this.userId, required List<String> messages})
      : super([...messages, message]);
}
