import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/domain/failures.dart';
import 'package:vido/core/external/user_extra_info_getter.dart';
import 'package:vido/features/init/domain/use_cases/there_is_authentication_impl.dart';
import 'there_is_authentication_impl_test.mocks.dart';

late ThereIsAuthenticationImpl thereIsAuthentication;
late MockUserExtraInfoGetter userExtraInfoGetter;

@GenerateMocks([
  UserExtraInfoGetter
])
void main(){
  userExtraInfoGetter = MockUserExtraInfoGetter();
  thereIsAuthentication = ThereIsAuthenticationImpl(accessTokenGetter: userExtraInfoGetter);

  test('should call the specified methods', ()async{
    when(userExtraInfoGetter.getAccessToken()).thenAnswer((_) async => 'token');
    await thereIsAuthentication();
    verify(userExtraInfoGetter.getAccessToken());
  });

  test('should return the expected result when there is an access token', ()async{
    when(userExtraInfoGetter.getAccessToken()).thenAnswer((_) async => 'token');
    final result = await thereIsAuthentication();
    expect(result, const Right(true));
  });

  test('shold return the expected result when there is a StorageException with EmptyData type', ()async{
    when(userExtraInfoGetter.getAccessToken()).thenThrow(const StorageException(message: '', type: StorageExceptionType.EMPTYDATA));
    final result = await thereIsAuthentication();
    expect(result, const Right(false));
  });

  test('shold return the expected result when there is a StorageException with Normal type', ()async{
    when(userExtraInfoGetter.getAccessToken()).thenThrow(const StorageException(message: '', type: StorageExceptionType.NORMAL));
    final result = await thereIsAuthentication();
     expect(result, const Left(Failure(message: '', exception: StorageException(message: '', type: StorageExceptionType.NORMAL))));
  });

  test('shold return the expected result when there is another Exception from the access token getter', ()async{
    when(userExtraInfoGetter.getAccessToken()).thenThrow(Exception());
    final result = await thereIsAuthentication();
    expect(result, const Left(Failure(message: '', exception: AppException(''))));
  });
}