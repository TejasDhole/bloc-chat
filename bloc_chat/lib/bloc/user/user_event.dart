

import '../../models/user_model.dart';

abstract class UserEvent {}

class AddUser extends UserEvent {
  final User user;
  AddUser({required this.user});
}