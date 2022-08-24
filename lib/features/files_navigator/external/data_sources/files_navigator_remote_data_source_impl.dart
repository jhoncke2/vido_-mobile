import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:vido/core/domain/file_parent_type.dart';
import 'package:vido/core/external/app_files_remote_adapter.dart';
import 'package:vido/core/external/remote_data_source.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_remote_data_source.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import 'package:http/http.dart' as http;
import '../../../../core/domain/exceptions.dart';
import '../../../../core/utils/http_responses_manager.dart';
import '../../../../core/utils/path_provider.dart';

class FilesNavigatorRemoteDataSourceImpl extends RemoteDataSource implements FilesNavigatorRemoteDataSource{
  static const baseFilesNavigationUrl = 'file-system';
  static const getGeneratedPdfUrl = 'show-pdf/';
  final PathProvider pathProvider;
  final HttpResponsesManager httpResponsesManager;
  final http.Client client;
  final AppFilesRemoteAdapter adapter;
  FilesNavigatorRemoteDataSourceImpl({
    required this.pathProvider,
    required this.httpResponsesManager,
    required this.client,
    required this.adapter
  });
  @override
  Future<List<AppFile>> getChildren(int folderId, FileParentType parentType, String accessToken)async{
    final response = await executeGeneralService(()async{
      final body = {
        'directory_id': folderId,
        'type': (parentType == FileParentType.user)? 'root' : 'carpeta'
      };
      final result = await client.post(
        getUri('${RemoteDataSource.baseApiUncodedPath}${RemoteDataSource.baseAuthorizedAppPath}$baseFilesNavigationUrl'),
        headers: super.createAuthorizationJsonHeaders(accessToken),
        body: jsonEncode(body)
      );
      return result;
    });
    final appFiles = adapter.getAppFilesFromJson(jsonDecode(response.body).cast<Map<String, dynamic>>());
    return appFiles;
  }
  
  @override
  Future<AppFile> getParentWithBrothers(int folderId, String accessToken)async{
    // TODO: implement getChildren
    throw UnimplementedError();
  }

  @override
  Future<File> getGeneratedPdf(PdfFile file, String accessToken)async{
    try{
      Completer<File> completer = Completer();
      var request = await HttpClient().getUrl(
        getUri('${RemoteDataSource.baseApiUncodedPath}${RemoteDataSource.baseAuthorizedAppPath}$getGeneratedPdfUrl${file.id}')
      );
      final response = await request.close();
      final dirPath = await pathProvider.generatePath();
      final bytes = await httpResponsesManager.getBytesFromResponse(response);
      final pdf = File('$dirPath/pdf_${file.id}');
      await pdf.writeAsBytes(bytes, flush: true);
      completer.complete(pdf);
      return pdf;
    }catch(err, stackTrace){
      print('********************** error ***************************');
      print(err);
      print(stackTrace);
      throw const ServerException(type: ServerExceptionType.NORMAL);
    }
  }

  @override
  Future<List<SearchAppearance>> search(String text)async{
    // TODO: implement search
    throw UnimplementedError();
  }
}