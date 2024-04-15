import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/auth_repo.dart';


part 'authentication_event.dart';
part 'authentication_state.dart';
class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  AuthenticationBloc() : super(AuthInitial());

  AuthRepository _authRepository = AuthRepository();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      yield* _mapLoginEventToState(event);
    } else if (event is RegisterEvent) {
      yield* _mapRegisterEventToState(event);
    }
  }
  Stream<AuthState> _mapLoginEventToState(LoginEvent event) async* {
    yield AuthLoading(); // Notify UI that login is in progress
    try {
      UserData userData = UserData(name: 'John Doe', email: 'tejas@gmail.com', password: '123');
      await _authRepository.registerUser(userData);
      // Perform login logic here
      // For example, you can use Firebase Authentication
      await _authRepository.signInWithEmailAndPassword(event.email, event.password);
      yield AuthSuccess(); // Notify UI that login is successful
    } catch (e) {
      yield AuthFailure(errorMessage: 'Login failed: $e'); // Notify UI that login failed with an error message
    }
  }
  Stream<AuthState> _mapRegisterEventToState(RegisterEvent event) async* {
    yield AuthLoading(); // Notify UI that registration is in progress
    try {
      // Perform registration logic here
      // For example, you can use Firebase Authentication
      await _authRepository.registerWithEmailAndPassword(event.email, event.password);
      yield AuthSuccess(); // Notify UI that registration is successful
    } catch (e) {
      yield AuthFailure(errorMessage: 'Registration failed: $e'); // Notify UI that registration failed with an error message
    }
  }

}
