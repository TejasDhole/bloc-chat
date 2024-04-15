
import 'package:hive/hive.dart';

import '../models/chatSession.dart';

class ChatRepository {
  // final chatBox = Hive.box<ChatSession>('chatBox');

  late Box<ChatSession> chatBox;

  void init() async {
    if (!Hive.isBoxOpen('chatBox')) {
      chatBox = await Hive.openBox<ChatSession>('chatBox');
    } else {
      chatBox = Hive.box<ChatSession>('chatBox');
    }
  }


  Future<void> addChat(ChatSession chat) async {
    await chatBox.put(chat.sessionId, chat);
    await chatBox.flush();
  }

  Future<List<ChatSession>> getChats() async {
    return chatBox.values.toList();
  }

  Future<void> deleteChat(String chatId) async {
    await chatBox.delete(chatId);
  }
}