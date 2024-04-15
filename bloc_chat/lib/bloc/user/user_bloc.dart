
import 'package:bloc_chat/bloc/user/user_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import '../../repository/Userrepository.dart';

class UserBloc extends Bloc<UserEvent, List<User>> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(userRepository.getUsers());

  @override
  Stream<List<User>> mapEventToState(UserEvent event) async* {
    if (event is AddUser) {
      userRepository.addUser(event.user);
      yield userRepository.getUsers();
    }
  }
}