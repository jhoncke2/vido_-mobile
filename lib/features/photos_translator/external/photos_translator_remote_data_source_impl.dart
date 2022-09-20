import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:vido/core/external/remote_data_source.dart';
import 'package:vido/core/utils/http_responses_manager.dart';
import 'package:vido/core/utils/path_provider.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/external/photos_translator_remote_adapter.dart';
import '../data/data_sources/photos_translator_remote_data_source.dart';
import 'package:http/http.dart' as http;
import '../domain/entities/translation.dart';
import '../domain/entities/translations_file.dart';

class PhotosTranslatorRemoteDataSourceImpl extends RemoteDataSourceWithMultiPartRequests implements PhotosTranslatorRemoteDataSource{
  static const getCompletedPdfFilesUrl = 'list-files';
  static const createTranslationsFileUrl = 'add-file';
  static const addTranslationUrl = 'add-pagine/';
  static const endTranslationsFileUrl = 'show-file/';
  static const createFolderPdfUrl = 'add-directory';
  static const userParentType = 'user';
  static const folderParentType = 'directory';
  final http.Client client;
  final PhotosTranslatorRemoteAdapter adapter;
  final PathProvider pathProvider;
  final HttpResponsesManager httpResponsesManager;
  
  PhotosTranslatorRemoteDataSourceImpl({
    required this.client,
    required this.adapter,
    required this.pathProvider,
    required this.httpResponsesManager
  });

  @override
  Future<TranslationsFile> createTranslationsFile(String name, int parentId, String accessToken)async{
    final http.Response response = await super.executeGeneralService(()async{
      return await client.post(
        getUri('${RemoteDataSource.baseApiUncodedPath}${RemoteDataSource.baseAuthorizedAppPath}$createTranslationsFileUrl'),
        body: jsonEncode({
          'name': name,
          'directory_id': parentId
        }),
        headers: super.createAuthorizationJsonHeaders(accessToken)
      );
    });
    final jsonResponse = await super.getResponseData(()async => jsonDecode(response.body));
    return adapter.getTranslationsFileFromJson(jsonResponse);
  }

  @override
  Future<int> addTranslation(int fileId, Translation translation, String accessToken)async{
    final headers = super.createAuthorizationMultipartHeaders(accessToken);
    final fields = {
      'text': translation.text??''
    };
    final fileInfo = {
      'field_name': 'image',
      'file': File(translation.imgUrl)
    };
    final response = await executeMultiPartRequestWithOneFile('${RemoteDataSource.baseApiUncodedPath}${RemoteDataSource.baseAuthorizedAppPath}$addTranslationUrl$fileId', headers, fields, fileInfo);
    return await super.getResponseData(
      () async => adapter.getTranslationFromJson( jsonDecode(response.body) ).id!
    );
  }

  @override
  Future<PdfFile> endTranslationFile(int id, String accessToken)async{
    final http.Response response = await super.executeGeneralService(()async{
      return await client.get(
        getUri('${RemoteDataSource.baseApiUncodedPath}${RemoteDataSource.baseAuthorizedAppPath}$endTranslationsFileUrl$id'),
        headers: super.createAuthorizationJsonHeaders(accessToken)
      );
    });
    return await super.getResponseData(
      () async => adapter.getPdfFileFromJson( 
        jsonDecode(response.body) 
      )
    );
  }
  
  @override
  Future<void> createFolder(String name, int parentId, String accessToken)async{
    await super.executeGeneralService(()async{
      final body = {
        'name': name,
        'directory_id': parentId
      };
      return await client.post(
        getUri('${RemoteDataSource.baseApiUncodedPath}${RemoteDataSource.baseAuthorizedAppPath}$createFolderPdfUrl'),
        headers: super.createAuthorizationJsonHeaders(accessToken),
        body: jsonEncode(body)
      );
    });
  }
}