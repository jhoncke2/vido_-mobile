part of 'authentication_bloc.dart';
abstract class AuthenticationEvent extends Equatable{
  @override
  List<Object?> get props => [runtimeType];
}

class LoginEvent extends AuthenticationEvent{
  final String email;
  final String password;
  LoginEvent({
    required this.email, 
    required this.password
  });
}

class LogoutEvent extends AuthenticationEvent{

}