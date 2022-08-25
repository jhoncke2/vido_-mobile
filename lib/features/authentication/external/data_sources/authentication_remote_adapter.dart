import 'dart:convert';
import 'package:vido/features/authentication/domain/entities/user.dart';

abstract class AuthenticationRemoteAdapter{
  String getStringJsonFromUser(User user);
  String getAccessTokenFromResponse(String response);
  int getIdFromResponse(String response);
}

class AuthenticationRemoteAdapterImpl implements AuthenticationRemoteAdapter{
  @override
  String getStringJsonFromUser(User user) => jsonEncode( {
    'email': user.email,
    'password': user.password
  });
  
  @override
  String getAccessTokenFromResponse(String response) {
    final jsonResponse = jsonDecode(response);
    return jsonResponse['data']['original']['access_token'];
  }
  
  @override
  int getIdFromResponse(String response) {
    final jsonResponse = jsonDecode(response);
    return jsonResponse['data']['original']['id'];
  }
  
}