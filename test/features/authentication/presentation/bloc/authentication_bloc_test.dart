
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/features/authentication/domain/entities/user.dart';
import 'package:vido/features/authentication/domain/failures/failures.dart';
import 'package:vido/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:vido/features/authentication/presentation/use_cases/login.dart';
import 'package:vido/features/authentication/presentation/use_cases/logout.dart';

import 'authentication_bloc_test.mocks.dart';

late AuthenticationBloc authenticationBloc;
late MockLogin login;
late MockLogout logout;

@GenerateMocks([
  Login,
  Logout
])
void main(){
  setUp((){
    logout = MockLogout();
    login = MockLogin();
    authenticationBloc = AuthenticationBloc(login: login, logout: logout);
  });
  group('login', _testLoginGroup);
  group('logout', _testLogoutGroup);
}

void _testLoginGroup(){
  late String tEmail;
  late String tPassword;
  late User tUser;
  group('when email and password are completed', (){
    setUp((){
      tEmail = 'email';
      tPassword = 'password';
      tUser = User(
        email: tEmail,
        password: tPassword
      );
    });

    test('shold call the specified methods', ()async{
      when(login(any)).thenAnswer((_) async => const Right(null));
      authenticationBloc.add(LoginEvent(email: tEmail, password: tPassword));
      await untilCalled(login(tUser));
      verify(login(tUser));
    });

    test('should emit the expected ordered states when all goes good', ()async{
      when(login(any)).thenAnswer((_) async => const Right(null));
      final expectedOrderedStates = [
        OnLoadingAuthentication(),
        OnAuthenticated()
      ];
      expectLater(authenticationBloc.stream, emitsInOrder(expectedOrderedStates));
      authenticationBloc.add(LoginEvent(email: tEmail, password: tPassword));
    });

    test('shold emit the expected ordered states when there is an unauthorized error', ()async{
      when(login(any)).thenAnswer((_) async => const Left(AuthenticationFailure(
        message: 'Credenciales inválidas', 
        exception: ServerException(type: ServerExceptionType.LOGIN, message: 'Credenciales inválidas')
      )));
      final expectedOrderedStates = [
        OnLoadingAuthentication(),
        OnAuthenticationError(message: 'Credenciales inválidas')
      ];
      expectLater(authenticationBloc.stream, emitsInOrder(expectedOrderedStates));
      authenticationBloc.add(LoginEvent(email: tEmail, password: tPassword));
    });
  });

  group('when email is uncompleted', (){
    setUp((){
      tEmail = '';
      tPassword = 'password';
      tUser = User(
        email: tEmail,
        password: tPassword
      );
    });

    test('shold call the specified methods', ()async{
      when(login(any)).thenAnswer((_) async => const Right(null));
      authenticationBloc.add(LoginEvent(email: tEmail, password: tPassword));
      verifyNever(login(tUser));
    });

    test('shold emit the expected ordered states', ()async{
      final expectedOrderedStates = [
        OnEmptyEmailError(message: AuthenticationBloc.emptyEmailErrorMessage)
      ];
      expectLater(authenticationBloc.stream, emitsInOrder(expectedOrderedStates));
      authenticationBloc.add(LoginEvent(email: tEmail, password: tPassword));
    });
  });

  group('when password is uncompleted', (){
    setUp((){
      tEmail = 'email';
      tPassword = '';
      tUser = User(
        email: tEmail,
        password: tPassword
      );
    });

    test('shold call the specified methods', ()async{
      when(login(any)).thenAnswer((_) async => const Right(null));
      authenticationBloc.add(LoginEvent(email: tEmail, password: tPassword));
      verifyNever(login(tUser));
    });

    test('shold emit the expected ordered states', ()async{
      final expectedOrderedStates = [
        OnEmptyPasswordError(message: AuthenticationBloc.emptyPasswordErrorMessage)
      ];
      expectLater(authenticationBloc.stream, emitsInOrder(expectedOrderedStates));
      authenticationBloc.add(LoginEvent(email: tEmail, password: tPassword));
    });
  });
}

void _testLogoutGroup(){
  setUp((){
    authenticationBloc.emit(OnAuthenticated());
  });
  test('should call the specified methods', ()async{
    when(logout()).thenAnswer((_) async => const Right(null));
    authenticationBloc.add(LogoutEvent());
    await untilCalled(logout());
    verify(logout());
  });

  test('should emit the expected ordered states when all goes good', ()async{
    when(logout()).thenAnswer((_) async => const Right(null));
    final expectedOrderedStates = [
      OnLoadingAuthentication(),
      OnUnAuthenticated()
    ];
    expectLater(authenticationBloc.stream, emitsInOrder(expectedOrderedStates));
    authenticationBloc.add(LogoutEvent());
  });

  test('should emit the expected ordered states when there is a Failure', ()async{
    when(logout()).thenAnswer((_) async => const Left(AuthenticationFailure(
      message: 'error message',
      exception: AppException('')
    )));
    final expectedOrderedStates = [
      OnLoadingAuthentication(),
      OnAuthenticationError(message: 'error message'),
      OnAuthenticated()
    ];
    expectLater(authenticationBloc.stream, emitsInOrder(expectedOrderedStates));
    authenticationBloc.add(LogoutEvent());
  });
}