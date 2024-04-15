import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../bloc/chat/chat_bloc.dart';
import '../models/message_model.dart';
import '../repository/chatsHistoryRepo.dart';

class ChatScreen extends StatefulWidget {
  final String userId;

  ChatScreen({required this.userId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatMessageRepo chatMessageRepo;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initChatMessageRepo();
  }

  Future<void> initChatMessageRepo() async {
    chatMessageRepo = ChatMessageRepo(userId: widget.userId);
    await chatMessageRepo.init();
    setState(() {
      chatMessageRepo = chatMessageRepo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Add any additional actions here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<Box<ChatMessage>>(
              valueListenable: chatMessageRepo.chatBox!.listenable(),
              builder: (context, box, _) {
                print('Box length: ${box.length}');
                print('Box values: ${box.values.toList().toString()}');
                print('Box keys: ${box.keys.toList().toString()}');

                return ListView.builder(
                  reverse: false, // Start from the bottom
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final message = box.getAt(index)!;
                    return _buildMessageBubble(message);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.userId == widget.userId ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.userId == widget.userId ? Colors.blueAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          message.message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: () {
              _sendMessage();
            },
            child: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
  void _sendMessage() async {
    final message = _textController.text.trim();
    if (message.isNotEmpty) {
      BlocProvider.of<ChatBloc>(context).add(SendMessage(message: message, userId: widget.userId)); // Send message with the existing user ID
      final chatMessage = ChatMessage(userId: widget.userId, message: message);
      try {
        if (!Hive.isBoxOpen('conversationBox_${widget.userId}')) {
          await Hive.openBox<ChatMessage>('conversationBox_${widget.userId}');
        }
        if (Hive.isBoxOpen('conversationBox_${widget.userId}')) {
          Hive.box<ChatMessage>('conversationBox_${widget.userId}').add(chatMessage);
        } else {
          print("Unable to open hive");
          // Handle the case where the box is not open
        }
      } catch (e) {
        print("Error opening Hive box: $e");
      }
      _textController.clear();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
