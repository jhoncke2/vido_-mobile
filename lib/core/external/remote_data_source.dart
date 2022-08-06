import 'dart:io';
import 'package:http/http.dart' as http;
import '../domain/exceptions.dart';

abstract class RemoteDataSource{
  static const baseHost = 'https://';
  static const baseUrl = 'vido.com.co';
  static const baseApiUncodedPath = 'api/ocr_app/';

  //Uri getUri(String uncodedPath)=>Uri.http(BASE_URL, uncodedPath);
  Uri getUri(String uncodedPath)=>Uri.https(baseUrl, uncodedPath);

  Map<String, String> createSingleAuthorizationHeaders(String accessToken){
    return {
      'Authorization':'Bearer $accessToken'
    };
  }

  Map<String, String> createAuthorizationJsonHeaders(String accessToken){
    return {
      'Authorization':'Bearer $accessToken',
      'Content-Type':'application/json'
    };
  }

  Map<String, String> createJsonContentTypeHeaders(){
    return {
      'Content-Type':'application/json'
    };
  }

  Future<http.Response> executeGeneralService(
    Future<http.Response> Function() service
  )async{
    try{
      final http.Response response = await service();
      final int statusCode = response.statusCode;
      if([200, 201].contains( statusCode ) ) {
        return response;
      } else if(statusCode == 401) {
        throw ServerException(type: ServerExceptionType.UNHAUTORAIZED);
      } else {
        throw Exception();
      }
    }on ServerException{ 
      rethrow; 
    }
    catch(exception){
      throw ServerException(type: ServerExceptionType.NORMAL);
    }
  }

  Future<dynamic> getResponseData(
    Future<dynamic> Function() function
  )async{
    try{
      return await function();
    }catch(exception, stackTrace){
      print(stackTrace);
      throw ServerException(type: ServerExceptionType.NORMAL);
    }
  }
}

abstract class RemoteDataSourceWithMultiPartRequests extends RemoteDataSource{

  Future<http.Response> executeMultiPartRequestWithOneFile(String requestUrl, Map<String, String> headers, Map<String, String> fields, Map<String, dynamic> fileInfo)async{
    final http.MultipartRequest request = await _generateMultiPartRequestWithOneFile(requestUrl, headers, fields, fileInfo);
    final response = await _sendMultiPartRequest(request);
    return response;
  }

  Future<http.MultipartRequest> _generateMultiPartRequestWithOneFile(String requestUrl, Map<String, String> headers, Map<String, String> fields, Map<String, dynamic> fileInfo)async{
    final http.MultipartRequest request = _generateBasicMultiPartRequest(requestUrl, headers, fields);
    final File file = fileInfo['file'];
    request.files.add(http.MultipartFile(
      fileInfo['field_name'],
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: file.path.split('/').last
    ));
    return request;
  }

  http.MultipartRequest _generateBasicMultiPartRequest(String requestUrl, Map<String, String> headers, Map<String, String> fields){
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse('${RemoteDataSource.baseHost}${RemoteDataSource.baseUrl}/$requestUrl')
    );
    request.headers.addAll(headers);
    request.fields.addAll(fields);
    return request;
  }

  Future<http.Response> _sendMultiPartRequest(http.MultipartRequest request)async{
    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);
    return response;
  }
} 