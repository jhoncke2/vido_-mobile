import 'package:vido/features/authentication/domain/entities/user.dart';

abstract class AuthenticationRemoteDataSource{
  Future<String> login(User user);
  Future<String> refreshAccessToken(String oldAccessToken);
  Future<int> getUserId(String accessToken);
}