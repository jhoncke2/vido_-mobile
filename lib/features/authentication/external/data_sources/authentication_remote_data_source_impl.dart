import 'package:http/http.dart' as http;
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/features/authentication/domain/entities/user.dart';
import '../../../../core/external/remote_data_source.dart';
import '../../data/data_sources/authentication_remote_data_source.dart';
import 'authentication_remote_adapter.dart';

class AuthenticationRemoteDataSourceImpl extends RemoteDataSource implements AuthenticationRemoteDataSource{
  static const authBaseApi = 'auth/';
  final http.Client client;
  final AuthenticationRemoteAdapter adapter;
  AuthenticationRemoteDataSourceImpl({
    required this.client,
    required this.adapter
  });
  @override
  Future<String> login(User user)async{
    try{
      final response = await super.executeGeneralService(() async{
        final body = adapter.getStringJsonFromUser(user);
        return await client.post(
          super.getUri('${RemoteDataSource.baseApiUncodedPath}${authBaseApi}login'),
          headers: createJsonContentTypeHeaders(),
          body: body
        );
      });
      return adapter.getAccessTokenFromResponse(response.body);
    }catch(exception){
      throw const ServerException(type: ServerExceptionType.LOGIN, message: 'Credenciales inválidas');
    }
  }
  
  @override
  Future<String> refreshAccessToken(String oldAccessToken) {
    // TODO: implement refreshAccessToken
    throw UnimplementedError();
  }
}