

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/chatSession.dart';
import '../../repository/chatRepo.dart';

part 'chat_list_state.dart';
part 'chat_list_event.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository chatRepository;

  ChatListBloc({required this.chatRepository}) : super(ChatListInitial());

  @override
  Stream<ChatListState> mapEventToState(ChatListEvent event) async* {
    if (event is LoadChats) {
      yield ChatListLoadingState();
      try {
        final chats = await chatRepository.getChats();
        yield ChatListLoadedState(chats);
      } catch (_) {
        yield ChatListErrorState('Failed to load chats');
      }
    } else if (event is AddChat) {
      try {
        await chatRepository.addChat(event.chat);
        final chats = await chatRepository.getChats();
        yield ChatListLoadedState(chats);
      } catch (_) {
        yield ChatListErrorState('Failed to add chat');
      }
    } else if (event is DeleteChat) {
      try {
        await chatRepository.deleteChat(event.chatId.toString());
        final chats = await chatRepository.getChats();
        yield ChatListLoadedState(chats);
      } catch (_) {
        yield ChatListErrorState('Failed to delete chat');
      }
    }
  }
}
