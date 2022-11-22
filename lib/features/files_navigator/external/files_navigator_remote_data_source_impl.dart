// ignore_for_file: prefer_collection_literals

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:vido/core/domain/file_parent_type.dart';
import 'package:vido/core/external/app_files_remote_adapter.dart';
import 'package:vido/core/external/remote_data_source.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_remote_data_source.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/external/files_navigator_remote_adapter.dart';
import 'package:vido/features/photos_translator/domain/entities/folder.dart';
import 'package:http/http.dart' as http;
import '../../../core/domain/exceptions.dart';
import '../../../core/utils/http_responses_manager.dart';
import '../../../core/utils/path_provider.dart';

class FilesNavigatorRemoteDataSourceImpl extends RemoteDataSource implements FilesNavigatorRemoteDataSource{
  static const baseFilesNavigationUrl = 'file-system';
  static const searchUrl = 'search-pdf/';
  static const icrUrl = 'icr';
  final PathProvider pathProvider;
  final HttpResponsesManager httpResponsesManager;
  final http.Client client;
  final FilesNavigatorRemoteAdapterImpl adapter;
  FilesNavigatorRemoteDataSourceImpl({
    required this.pathProvider,
    required this.httpResponsesManager,
    required this.client,
    required this.adapter
  });
  @override
  Future<Folder> getFolder(int folderId, FileParentType parentType, String accessToken)async{
    final response = await executeGeneralService(()async{
      final body = {
        'directory_id': folderId,
        'type': (parentType == FileParentType.user)? 'root' : 'directorio'
      };
      final result = await client.post(
        getUri('${RemoteDataSource.baseApiUncodedPath}${RemoteDataSource.baseAuthorizedAppPath}$baseFilesNavigationUrl'),
        headers: super.createAuthorizationJsonHeaders(accessToken),
        body: jsonEncode(body)
      );
      return result;
    });
    final folder = adapter.getFolderFromJson(jsonDecode(response.body));
    return folder;
  }

  @override
  Future<File> getGeneratedPdf(String fileUrl, String accessToken)async{
    try{
      Completer<File> completer = Completer();
      final url = fileUrl
          .replaceAll(RegExp('https://'), '')
          .replaceAll('\\', '');
      final urlParts = url.split('/');
      var request = await HttpClient().getUrl(
        Uri.https(urlParts[0], urlParts.sublist(1, urlParts.length).join('/'))
      );
      request.headers.set('Authorization', 'Bearer $accessToken');
      final dirPath = await pathProvider.generatePath();
      final response = await request.close();
      final bytes = await httpResponsesManager.getBytesFromResponse(response);
      final date = DateTime.now();
      final pdf = File('$dirPath/pdf_${date.year}${date.month}${date.day}${date.hour}${date.second}${date.millisecond}');
      await pdf.writeAsBytes(bytes, flush: true);
      completer.complete(pdf);
      return pdf;
    }catch(err, stackTrace){
      print('********************** pdf error ***************************');
      print(err);
      print(stackTrace);
      throw const ServerException(type: ServerExceptionType.NORMAL);
    }
  }

  @override
  Future<List<SearchAppearance>> search(String text, String accessToken)async{
    final response = await super.executeGeneralService(()async{
      return await client.get(
        getUri('${RemoteDataSource.baseApiUncodedPath}${RemoteDataSource.baseAuthorizedAppPath}$searchUrl$text'),
        headers: super.createAuthorizationJsonHeaders(accessToken)
      );
    });
    final appearances = adapter.getApearancesFromJson(jsonDecode(response.body).cast<Map<String, dynamic>>());
    return appearances;
  }
  
  @override
  Future<List<Map<String, dynamic>>> generateIcr(List<int> filesIds, String accessToken)async{
    final response = await super.executeGeneralService(()async{
      final body = {
        'document_id': filesIds
      };
      return await client.post(
        getUri('${RemoteDataSource.baseApiUncodedPath}${RemoteDataSource.baseAuthorizedAppPath}$icrUrl'),
        headers: super.createAuthorizationJsonHeaders(accessToken),
        body: jsonEncode(body)
      );
    });
    final icr = jsonDecode(response.body).cast<Map<String, dynamic>>();
    return icr;
  }
}