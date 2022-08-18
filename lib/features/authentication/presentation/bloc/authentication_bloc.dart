import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/features/authentication/domain/entities/user.dart';
import 'package:vido/features/authentication/presentation/use_cases/login.dart';
import 'package:vido/features/authentication/presentation/use_cases/logout.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>{
  static const emptyEmailErrorMessage = 'el campo de correo no puede estar vacío';
  static const emptyPasswordErrorMessage = 'el campo de contraseña no puede estar vacío';
  static const invalidCredentialsErrorMessage = 'credenciales inválidas';

  final Login login;
  final Logout logout;
  AuthenticationBloc({
    required this.login,
    required this.logout
  }) : super(OnAuthenticationInit()){
    on<AuthenticationEvent>((event, emit) async {
      if(event is LoginEvent){
        if(event.email.isEmpty) {
          emit(OnEmptyEmailError(message: emptyEmailErrorMessage));
        } else if(event.password.isEmpty){
          emit(OnEmptyPasswordError(message: emptyPasswordErrorMessage));
        }else{
          emit(OnLoadingAuthentication());
          final user = User(email: event.email, password: event.password);
          final loginResult = await login(user);
          loginResult.fold((failure){
            emit(OnAuthenticationError(message: failure.message));
          }, (r){
            emit(OnAuthenticated());
          });
        }
      }else if(event is LogoutEvent){
        emit(OnLoadingAuthentication());
        final logoutResult = await logout();
        await logoutResult.fold((failure)async{
          emit(OnAuthenticationError(message: failure.message));
          emit(await Future.delayed(
            const Duration(milliseconds: 1500),
            () => OnAuthenticated()
          ));
        }, (_)async{
          emit(OnUnAuthenticated());
        });
      }
    });
  }
  
}