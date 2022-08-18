import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/domain/failures.dart';
import 'package:vido/core/external/access_token_getter.dart';
import 'package:vido/features/init/domain/use_cases/there_is_authentication_impl.dart';
import 'there_is_authentication_impl_test.mocks.dart';

late ThereIsAuthenticationImpl thereIsAuthentication;
late MockAccessTokenGetter accessTokenGetter;

@GenerateMocks([
  AccessTokenGetter
])
void main(){
  accessTokenGetter = MockAccessTokenGetter();
  thereIsAuthentication = ThereIsAuthenticationImpl(accessTokenGetter: accessTokenGetter);

  test('should call the specified methods', ()async{
    when(accessTokenGetter.getAccessToken()).thenAnswer((_) async => 'token');
    await thereIsAuthentication();
    verify(accessTokenGetter.getAccessToken());
  });

  test('should return the expected result when there is an access token', ()async{
    when(accessTokenGetter.getAccessToken()).thenAnswer((_) async => 'token');
    final result = await thereIsAuthentication();
    expect(result, const Right(true));
  });

  test('shold return the expected result when there is a StorageException with EmptyData type', ()async{
    when(accessTokenGetter.getAccessToken()).thenThrow(const StorageException(message: '', type: StorageExceptionType.EMPTYDATA));
    final result = await thereIsAuthentication();
    expect(result, const Right(false));
  });

  test('shold return the expected result when there is a StorageException with Normal type', ()async{
    when(accessTokenGetter.getAccessToken()).thenThrow(const StorageException(message: '', type: StorageExceptionType.NORMAL));
    final result = await thereIsAuthentication();
     expect(result, const Left(Failure(message: '', exception: StorageException(message: '', type: StorageExceptionType.NORMAL))));
  });

  test('shold return the expected result when there is another Exception from the access token getter', ()async{
    when(accessTokenGetter.getAccessToken()).thenThrow(Exception());
    final result = await thereIsAuthentication();
    expect(result, const Left(Failure(message: '', exception: AppException(''))));
  });
}