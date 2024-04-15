import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../models/user_model.dart';
import 'chat_screen.dart';

class ChatUserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contact'),
        backgroundColor: Color(0xFF075E54), // WhatsApp green color
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<UserBloc, List<User>>(
          builder: (context, users) {
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildUserTile(context, users[index]),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF25D366), // WhatsApp green color
        onPressed: () {
          _showAddUsersDialog(context);
        },
        child: Icon(Icons.message),
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, User user) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(userId: user.id),
          ),
        );
      },
      leading: CircleAvatar(
        radius: 24.0,
        backgroundColor: Colors.grey.shade300,
        child: Text(
          user.name.substring(0, 1).toUpperCase(),
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      title: Text(
        user.name,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showAddUsersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        final _userNamesController = TextEditingController();

        return AlertDialog(
          title: Text('Add Users'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _userNamesController,
              decoration: InputDecoration(
                hintText: 'Enter user names, separated by commas',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some user names';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final userNames = _userNamesController.text.split(',');
                  for (final userName in userNames) {
                    if (userName.trim().isNotEmpty) {
                      BlocProvider.of<UserBloc>(context).add(
                        AddUser(user: User(id: Uuid().v4(), name: userName.trim())),
                      );
                    }
                  }
                  _clearUserInput(_userNamesController);
                  Navigator.pop(context);
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                _clearUserInput(_userNamesController);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _clearUserInput(TextEditingController controller) {
    controller.clear();
  }
}
