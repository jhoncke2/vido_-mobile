import 'package:vido/features/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:vido/features/authentication/domain/entities/user.dart';

class AuthenticationRemoteDataSourceFake implements AuthenticationRemoteDataSource{
  @override
  Future<String> login(User user)async{
    return 'the_access_token_xyz';
  }

  @override
  Future<String> refreshAccessToken(String oldAccessToken)async{
    return oldAccessToken.substring(0, (oldAccessToken.length/2).ceil()) + 'new_acc_token';
  }
}