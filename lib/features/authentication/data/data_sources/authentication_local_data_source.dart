import 'package:vido/core/external/user_extra_info_getter.dart';
import 'package:vido/features/authentication/domain/entities/user.dart';

abstract class AuthenticationLocalDataSource implements UserExtraInfoGetter{
  Future<void> setUser(User user);
  Future<User> getUser();
  Future<void> setAccessToken(String accessToken);
  Future<void> resetApp();
}