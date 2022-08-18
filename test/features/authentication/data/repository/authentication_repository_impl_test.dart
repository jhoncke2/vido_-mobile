import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/features/authentication/data/data_sources/authentication_local_data_source.dart';
import 'package:vido/features/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:vido/features/authentication/data/repository/authentication_repository_impl.dart';
import 'package:vido/features/authentication/domain/entities/user.dart';
import 'package:vido/features/authentication/domain/failures/failures.dart';

import 'authentication_repository_impl_test.mocks.dart';

late AuthenticationRepositoryImpl authenticationRepository;
late MockAuthenticationRemoteDataSource remoteDataSource;
late MockAuthenticationLocalDataSource localDataSource;

@GenerateMocks([
  AuthenticationRemoteDataSource,
  AuthenticationLocalDataSource
])
void main(){
  setUp((){
    localDataSource = MockAuthenticationLocalDataSource();
    remoteDataSource = MockAuthenticationRemoteDataSource();
    authenticationRepository = AuthenticationRepositoryImpl(
      remoteDataSource: remoteDataSource, 
      localDataSource: localDataSource
    );
  });

  group('login', _testLoginGroup);
  group('logout', _testLogoutGroup);
  group('re login', _testReloginGroup);
}

void _testLoginGroup(){
  late User tUser;
  late String tNewAccessToken;
  setUp((){
    tUser = const User(email: 'email', password: 'password');
    tNewAccessToken = 'access_token';
  });

  test('shold call the specified methods', ()async{
    when(remoteDataSource.login(any)).thenAnswer((_) async => tNewAccessToken);
    await authenticationRepository.login(tUser);
    verify(remoteDataSource.login(tUser));
    verify(localDataSource.setUser(tUser));
    verify(localDataSource.setAccessToken(tNewAccessToken));
  });

  test('should return the expected result when all goes good', ()async{
    when(remoteDataSource.login(any)).thenAnswer((_) async => tNewAccessToken);
    final result = await authenticationRepository.login(tUser);
    expect(result, const Right(null));
  });

  test('should return the expected result when there is a ServerException', ()async{
    when(remoteDataSource.login(any)).thenThrow(const ServerException(type: ServerExceptionType.UNHAUTORAIZED));
    final result = await authenticationRepository.login(tUser);
    expect(
      result, 
      const Left(AuthenticationFailure(
        exception: ServerException(type: ServerExceptionType.UNHAUTORAIZED),
        message: ''
      )
    ));
  });

  test('should return the expected result when there is a DBException', ()async{
    when(remoteDataSource.login(any)).thenAnswer((_) async => tNewAccessToken);
    when(localDataSource.setAccessToken(any)).thenThrow(const DBException(type: DBExceptionType.PLATFORM));
    final result = await authenticationRepository.login(tUser);
    expect(
      result, 
      const Left( AuthenticationFailure(
        exception: DBException(type: DBExceptionType.PLATFORM),
        message: ''
      ))
    );
  });

  test('should return the expected result when there is a non AppException', ()async{
    when(remoteDataSource.login(any)).thenAnswer((_) async => tNewAccessToken);
    when(localDataSource.setAccessToken(any)).thenThrow(Exception());
    final result = await authenticationRepository.login(tUser);
    expect(
      result, 
      const Left( AuthenticationFailure(
        exception: AppException(AuthenticationRepositoryImpl.nonRecognizedErrorMessage),
        message: AuthenticationRepositoryImpl.nonRecognizedErrorMessage
      ))
    );
  });
}

void _testLogoutGroup(){
  test('should call the specified methods', ()async{
    await authenticationRepository.logout();
    verify(localDataSource.resetApp());
  });

  test('should return the expected result when all goes good', ()async{
    final result = await authenticationRepository.logout();
    expect(result, const Right(null));
  });

  test('should return the expected result when there is a DBException', ()async{
    when(localDataSource.resetApp()).thenThrow(const DBException(type: DBExceptionType.PLATFORM));
    final result = await authenticationRepository.logout();
    expect(
      result, 
      const Left( AuthenticationFailure(
        exception: DBException(type: DBExceptionType.PLATFORM),
        message: ''
      ))
    );
  });

  test('should return the expected result when there is a non AppException', ()async{
    when(localDataSource.resetApp()).thenThrow(Exception());
    final result = await authenticationRepository.logout();
    expect(
      result, 
      const Left( AuthenticationFailure(
        exception: AppException(AuthenticationRepositoryImpl.nonRecognizedErrorMessage),
        message: AuthenticationRepositoryImpl.nonRecognizedErrorMessage
      ))
    );
  });
}

void _testReloginGroup(){
  late User tUser;
  late String tAccessToken;
  setUp((){
    tUser = const User(email: 'email', password: 'password');
    tAccessToken = 'access_token';
    when(localDataSource.getUser()).thenAnswer((_) async => tUser);
    when(remoteDataSource.login(any)).thenAnswer((_) async => tAccessToken);
  });

  test('shold call the specified methods', ()async{
    await authenticationRepository.reLogin();
    verify(localDataSource.getUser());
    verify(remoteDataSource.login(tUser));
    verify(localDataSource.setAccessToken(tAccessToken));
  });

  test('should return the expected result when all goes good', ()async{
    final result = await authenticationRepository.reLogin();
    expect(result, const Right(null));
  });

  test('should return the expected result when there is a ServerException', ()async{
    when(remoteDataSource.login(any)).thenThrow(const ServerException(type: ServerExceptionType.UNHAUTORAIZED));
    final result = await authenticationRepository.reLogin();
    expect(
      result, 
      const Left(AuthenticationFailure(
        exception: ServerException(type: ServerExceptionType.UNHAUTORAIZED),
        message: ''
      )
    ));
  });

  test('should return the expected result when there is a DBException', ()async{
    when(remoteDataSource.login(any)).thenAnswer((_) async => tAccessToken);
    when(localDataSource.setAccessToken(any)).thenThrow(const DBException(type: DBExceptionType.PLATFORM));
    final result = await authenticationRepository.reLogin();
    expect(
      result, 
      const Left( AuthenticationFailure(
        exception: DBException(type: DBExceptionType.PLATFORM),
        message: ''
      ))
    );
  });

  test('should return the expected result when there is a non AppException', ()async{
    when(remoteDataSource.login(any)).thenAnswer((_) async => tAccessToken);
    when(localDataSource.setAccessToken(any)).thenThrow(Exception());
    final result = await authenticationRepository.reLogin();
    expect(
      result, 
      const Left( AuthenticationFailure(
        exception: AppException(AuthenticationRepositoryImpl.nonRecognizedErrorMessage),
        message: AuthenticationRepositoryImpl.nonRecognizedErrorMessage
      ))
    );
  });
}