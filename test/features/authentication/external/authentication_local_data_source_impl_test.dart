import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/external/persistence.dart';
import 'package:vido/core/external/shared_preferences_manager.dart';
import 'package:vido/features/authentication/domain/entities/user.dart';
import 'package:vido/features/authentication/external/data_sources/authentication_local_data_source_impl.dart';

import 'authentication_local_data_source_impl_test.mocks.dart';

late AuthenticationLocalDataSourceImpl localDataSource;
late MockSharedPreferencesManager preferencesManager;
late MockDatabaseManager dbManager;

@GenerateMocks([
  SharedPreferencesManager,
  DatabaseManager
])
void main(){
  dbManager = MockDatabaseManager();
  preferencesManager = MockSharedPreferencesManager();
  localDataSource = AuthenticationLocalDataSourceImpl(preferencesManager: preferencesManager, dbManager: dbManager);

  group('get access token', _testGetAccessTokenGroup);
  group('set access token', _testSetAccessTokenGroup);
  group('get user', _testGetUserGroup);
  group('set user', _testSetUserGroup);
  group('reset app', _testResetAppGroup);
}

void _testGetAccessTokenGroup(){
  late String tAccessToken;
  setUp((){
    tAccessToken = 'access_token';
    when(preferencesManager.getString(any)).thenAnswer((_) async => tAccessToken);
  });

  test('should call the specified methods', ()async{
    await localDataSource.getAccessToken();
    verify(preferencesManager.getString(AuthenticationLocalDataSourceImpl.accessTokenKey));
  });

  test('shold return the expected result', ()async{
    final result = await localDataSource.getAccessToken();
    expect(result, tAccessToken);
  });
}

void _testSetAccessTokenGroup(){
  late String tAccessToken;
  setUp((){
    tAccessToken = 'access_token';
  });

  test('shold call the specified methods', ()async{
    await localDataSource.setAccessToken(tAccessToken);
    verify(preferencesManager.setString(AuthenticationLocalDataSourceImpl.accessTokenKey, tAccessToken));
  });
}
void _testGetUserGroup(){
  late User tUser;
  setUp((){
    tUser = const User(email: 'email', password: 'password');
    when(preferencesManager.getString(AuthenticationLocalDataSourceImpl.emailKey))
        .thenAnswer((_) async => tUser.email);
    when(preferencesManager.getString(AuthenticationLocalDataSourceImpl.passwordKey))
        .thenAnswer((_) async => tUser.password);
  });

  test('shold call the specified methods', ()async{
    await localDataSource.getUser();
    verify(preferencesManager.getString(AuthenticationLocalDataSourceImpl.emailKey));
    verify(preferencesManager.getString(AuthenticationLocalDataSourceImpl.passwordKey));
  });

  test('should return the expected result', ()async{
    final result = await localDataSource.getUser();
    expect(result, tUser);
  });
}

void _testSetUserGroup(){
  late User tUser;
  setUp((){
    tUser = const User(email: 'email', password: 'password');
  });

  test('shold call the specified methods', ()async{
    await localDataSource.setUser(tUser);
    verify(preferencesManager.setString(AuthenticationLocalDataSourceImpl.emailKey, tUser.email));
    verify(preferencesManager.setString(AuthenticationLocalDataSourceImpl.passwordKey, tUser.password));
  });
}

void _testResetAppGroup(){
  test('shold call the specified methods', ()async{
    await localDataSource.resetApp();
    verify(preferencesManager.remove(AuthenticationLocalDataSourceImpl.accessTokenKey));
    verify(preferencesManager.remove(AuthenticationLocalDataSourceImpl.emailKey));
    verify(preferencesManager.remove(AuthenticationLocalDataSourceImpl.passwordKey));
    verify(dbManager.removeAll(pdfFilesTableName));
    verify(dbManager.removeAll(translationsTableName));
    verify(dbManager.removeAll(translFilesTableName));
  });
}