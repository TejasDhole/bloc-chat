import 'package:hive/hive.dart';
import '../models/message_model.dart';

class ChatMessageRepo {
   Box<ChatMessage>? chatBox;
  final String userId;

  ChatMessageRepo({required this.userId});

  Future<void> init() async {
    if(!Hive.isBoxOpen('conversationBox_$userId')) {
      chatBox = await Hive.openBox<ChatMessage>('conversationBox_$userId');
    } else {
      chatBox = Hive.box<ChatMessage>('conversationBox_$userId');
    }
  }

  void addMessage(ChatMessage message) {
    chatBox?.add(message);
  }

  void dispose() {
    Hive.close();
  }
}
class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 1; // Unique identifier for this type

  @override
  ChatMessage read(BinaryReader reader) {
    final fields = reader.readMap() as Map<dynamic, dynamic>;
    return ChatMessage(
      userId: fields['userId'] as String,
      message: fields['message'] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer.writeMap({
      'userId': obj.userId,
      'message': obj.message,
    });
  }
}
