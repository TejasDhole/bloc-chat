import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String message;

  ChatMessage({required this.userId, required this.message});
}
