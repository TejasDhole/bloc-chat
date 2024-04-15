part of 'chat_list_bloc.dart';

sealed class ChatListState extends Equatable {
  const ChatListState();
}

final class ChatListInitial extends ChatListState {
  @override
  List<Object> get props => [];
}
final class ChatListLoadingState extends ChatListState {


  @override
  List<Object> get props => [];
}
final class ChatListLoadedState extends ChatListState {

  final List<ChatSession> chatList;

  const ChatListLoadedState(this.chatList);
  @override
  List<Object> get props => [chatList];
}
final class ChatListErrorState extends ChatListState {
  final String errorMessage;

  const ChatListErrorState(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
