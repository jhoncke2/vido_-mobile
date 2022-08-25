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
  late User tUserInitial;
  late User tUserUpdated;
  late String tNewAccessToken;
  late int tId;
  setUp((){
    tId = 0;
    tUserInitial = User(email: 'email', password: 'password');
    tUserUpdated = User(id: tId, email: 'email', password: 'password');
    tNewAccessToken = 'access_token';
    when(remoteDataSource.getUserId(any))
        .thenAnswer((_) async => tId);
  });

  test('shold call the specified methods', ()async{
    when(remoteDataSource.login(any)).thenAnswer((_) async => tNewAccessToken);
    await authenticationRepository.login(tUserInitial);
    verify(remoteDataSource.login(tUserInitial));
    verify(remoteDataSource.getUserId(tNewAccessToken));
    verify(localDataSource.setUser(tUserUpdated));
    verify(localDataSource.setAccessToken(tNewAccessToken));
  });

  test('should return the expected result when all goes good', ()async{
    when(remoteDataSource.login(any)).thenAnswer((_) async => tNewAccessToken);
    final result = await authenticationRepository.login(tUserInitial);
    expect(result, const Right(null));
  });

  test('should return the expected result when there is a ServerException', ()async{
    when(remoteDataSource.login(any)).thenThrow(const ServerException(type: ServerExceptionType.UNHAUTORAIZED));
    final result = await authenticationRepository.login(tUserInitial);
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
    final result = await authenticationRepository.login(tUserInitial);
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
    final result = await authenticationRepository.login(tUserInitial);
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
  late User tUserInitial;
  late String tAccessToken;
  late int tNewId;
  late User tUserUpdated;
  setUp((){
    tUserInitial = User(id: 0, email: 'email', password: 'password');
    tAccessToken = 'access_token';
    tNewId = 1;
    tUserUpdated = User(id: tNewId, email: 'email', password: 'password');
    when(localDataSource.getUser()).thenAnswer((_) async => tUserInitial);
    when(remoteDataSource.login(any)).thenAnswer((_) async => tAccessToken);
    when(remoteDataSource.getUserId(any)).thenAnswer((_) async => tNewId);
  });

  test('shold call the specified methods', ()async{
    await authenticationRepository.reLogin();
    verify(localDataSource.getUser());
    verify(remoteDataSource.login(tUserInitial));
    verify(remoteDataSource.getUserId(tAccessToken));
    verify(localDataSource.setUser(tUserUpdated));
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