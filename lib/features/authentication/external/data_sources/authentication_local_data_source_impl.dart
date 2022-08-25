import 'package:vido/core/external/persistence.dart';
import 'package:vido/core/external/shared_preferences_manager.dart';
import 'package:vido/features/authentication/domain/entities/user.dart';
import '../../data/data_sources/authentication_local_data_source.dart';

class AuthenticationLocalDataSourceImpl implements AuthenticationLocalDataSource{
  static const accessTokenKey = 'access_token';
  static const id = 'id';
  static const emailKey = 'user';
  static const passwordKey = 'password';
  final SharedPreferencesManager preferencesManager;
  final DatabaseManager dbManager;
  const AuthenticationLocalDataSourceImpl({
    required this.preferencesManager,
    required this.dbManager
  });
  
  @override
  Future<String> getAccessToken()async{
    return await preferencesManager.getString(accessTokenKey);
  }

  @override
  Future<void> setAccessToken(String accessToken)async{
    await preferencesManager.setString(accessTokenKey, accessToken);
  }

  @override
  Future<User> getUser()async{
    final stringId = await preferencesManager.getString(idKey);
    final email = await preferencesManager.getString(emailKey);
    final password = await preferencesManager.getString(passwordKey);
    return User(id: int.parse(stringId), email: email, password: password);
  }

  @override
  Future<void> setUser(User user)async{
    await preferencesManager.setString(idKey, '${user.id}');
    await preferencesManager.setString(emailKey, user.email);
    await preferencesManager.setString(passwordKey, user.password);
  }

  @override
  Future<void> resetApp()async{
    await preferencesManager.clear();
    dbManager.removeAll(pdfFilesTableName);
    dbManager.removeAll(translationsTableName);
    dbManager.removeAll(translFilesTableName);
  }
  
  @override
  Future<int> getId()async{
    final stringId = await preferencesManager.getString(idKey);
    return int.parse(stringId);
  }
}