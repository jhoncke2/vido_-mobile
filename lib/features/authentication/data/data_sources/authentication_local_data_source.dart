import 'package:vido/core/external/access_token_getter.dart';
import 'package:vido/features/authentication/domain/entities/user.dart';

abstract class AuthenticationLocalDataSource implements AccessTokenGetter{
  Future<void> setUser(User user);
  Future<User> getUser();
  Future<void> setAccessToken(String accessToken);
  Future<void> resetApp();
}