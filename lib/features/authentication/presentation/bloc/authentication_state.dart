part of 'authentication_bloc.dart';
abstract class AuthenticationState extends Equatable{
  @override
  List<Object?> get props => [runtimeType];
}

class OnAuthenticationInit extends AuthenticationState{

}

class OnLoadingAuthentication extends AuthenticationState{

}

class OnAuthenticated extends AuthenticationState{

}

class OnAuthenticationError extends AuthenticationState{
  final String message;
  OnAuthenticationError({
    required this.message
  });
  @override
  List<Object> get props => [message];
}

class OnEmptyEmailError extends OnAuthenticationError {
  OnEmptyEmailError({
    required String message
  }):super(message: message);
}

class OnEmptyPasswordError extends OnAuthenticationError {
  OnEmptyPasswordError({
    required String message
  }):super(message: message);
}

class OnUnAuthenticated extends AuthenticationState{

}