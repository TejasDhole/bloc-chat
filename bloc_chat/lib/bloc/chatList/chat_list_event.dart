part of 'chat_list_bloc.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object> get props => [];
}

class LoadChats extends ChatListEvent {}

class AddChat extends ChatListEvent {
  final ChatSession chat;

  const AddChat(this.chat);

  @override
  List<Object> get props => [chat];
}

class DeleteChat extends ChatListEvent {
  final String chatId;

  const DeleteChat(this.chatId);

  @override
  List<Object> get props => [chatId];
}