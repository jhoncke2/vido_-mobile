import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/features/authentication/domain/entities/user.dart';
import 'package:vido/features/authentication/external/data_sources/authentication_remote_adapter.dart';
import 'package:vido/features/authentication/external/data_sources/authentication_remote_data_source_impl.dart';
import 'authentication_remote_data_source_impl_test.mocks.dart';

late AuthenticationRemoteDataSourceImpl remoteDataSource;
late MockClient client;
late MockAuthenticationRemoteAdapter adapter;
@GenerateMocks([
  http.Client,
  AuthenticationRemoteAdapter
])
void main(){
  setUp((){
    adapter = MockAuthenticationRemoteAdapter();
    client = MockClient();
    remoteDataSource = AuthenticationRemoteDataSourceImpl(client: client, adapter: adapter);
  });

  group('login', _testLoginGroup);
}

void _testLoginGroup(){
  late User tUser;
  late Map<String, String> tHeaders;
  late String tStringBody;
  late String tResponseBody;
  late String tAccessToken;
  setUp((){
    tUser = User(email: 'emailX', password: 'pass');
    tHeaders = {'Content-Type': 'application/json'};
    tStringBody = '{"email": "emailX", "password": "pass"}';
    tAccessToken = "access_token";
    tResponseBody = '''
      {
        "data": {
          "headers": {},
          "original": {
            "access_token": "$tAccessToken",
            "token_type": "bearer",
            "expires_in": 36000
          },
          "exception": null
        }
      }
    ''';
    when(adapter.getStringJsonFromUser(any)).thenReturn(tStringBody);
    when(adapter.getAccessTokenFromResponse(any)).thenReturn(tAccessToken);
  });

  test('shold call the specified methods', ()async{
    when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response(tResponseBody, 200));
    await remoteDataSource.login(tUser);
    verify(adapter.getStringJsonFromUser(tUser));
    verify(client.post(any, headers: tHeaders, body: tStringBody));
    verify(adapter.getAccessTokenFromResponse(tResponseBody));
  });

  test('shold return the expected result when all goes good', ()async{
    when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => http.Response(tResponseBody, 200));
    final result = await remoteDataSource.login(tUser);
    expect(result, tAccessToken);
  });

}