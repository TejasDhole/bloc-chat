
part of 'authentication_bloc.dart';
abstract class AuthEvent {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}


