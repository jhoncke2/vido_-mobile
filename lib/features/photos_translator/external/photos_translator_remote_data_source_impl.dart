import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:vido/core/domain/exceptions.dart';
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
  static const basePhotosTranslatorApi = 'ocr_app/';
  static const getCompletedPdfFilesUrl = 'list-files';
  static const createTranslationsFileUrl = 'add-file';
  static const addTranslationUrl = 'add-pagine/';
  static const endTranslationsFileUrl = 'show-file/';
  static const getGeneratedPdfUrl = 'show-pdf/';
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
  Future<List<PdfFile>> getCompletedPdfFiles()async{
    final http.Response response = await super.executeGeneralService(()async{
      return await client.get(
        getUri('${RemoteDataSource.baseApiUncodedPath}$basePhotosTranslatorApi$getCompletedPdfFilesUrl')
      );
    });
    return await super.getResponseData(()async{
      final jsonResponse = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return adapter.getPdfFilesFromJson(jsonResponse);
    });
  }

  @override
  Future<TranslationsFile> createTranslationsFile(String name)async{
    final http.Response response = await super.executeGeneralService(()async{
      return await client.post(
        getUri('${RemoteDataSource.baseApiUncodedPath}$basePhotosTranslatorApi$createTranslationsFileUrl'),
        body: jsonEncode({
          'name': name,
          'directory_id': 1
        }),
        headers: { 
          'Content-Type': 'Application/json'
        }
      );
    });
    final jsonResponse = await super.getResponseData(()async => jsonDecode(response.body));
    return adapter.getTranslationsFileFromJson(jsonResponse);
  }

  @override
  Future<int> addTranslation(int fileId, Translation translation)async{
    final headers = {
      'Content-Type':'application/x-www-form-urlencoded'
    };
    final fields = {
      'text': translation.text??''
    };
    final fileInfo = {
      'field_name': 'image',
      'file': File(translation.imgUrl)
    };
    final response = await executeMultiPartRequestWithOneFile('${RemoteDataSource.baseApiUncodedPath}$basePhotosTranslatorApi$addTranslationUrl$fileId', headers, fields, fileInfo);
    return await super.getResponseData(
      () async => adapter.getTranslationFromJson( jsonDecode(response.body) ).id!
    );
  }

  @override
  Future<PdfFile> endTranslationFile(int id)async{
    final http.Response response = await super.executeGeneralService(()async{
      return await client.get(
        getUri('${RemoteDataSource.baseApiUncodedPath}$basePhotosTranslatorApi$endTranslationsFileUrl$id')
      );
    });
    return await super.getResponseData(
      () async => adapter.getPdfFileFromJson( 
        jsonDecode(response.body) 
      )
    );
  }
  
  @override
  Future<File> getGeneratedPdf(PdfFile file)async{
    try{
      Completer<File> completer = Completer();
      var request = await HttpClient().getUrl(
        getUri('${RemoteDataSource.baseApiUncodedPath}$basePhotosTranslatorApi$getGeneratedPdfUrl${file.id}')
      );
      final dirPath = await pathProvider.generatePath();
      final response = await request.close();
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
}