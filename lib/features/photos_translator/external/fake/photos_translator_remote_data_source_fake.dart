import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/external/persistence.dart';
import 'package:vido/core/external/remote_data_source.dart';
import 'package:vido/core/utils/http_responses_manager.dart';
import 'package:vido/core/utils/path_provider.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_remote_data_source.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/external/photos_translator_local_adapter.dart';

class PhotosTranslatorRemoteDataSourceFake extends RemoteDataSourceWithMultiPartRequests implements PhotosTranslatorRemoteDataSource{
  static const _examplePdfUrl = 'www.africau.edu/images/default/sample.pdf';
  final DatabaseManager persistenceManager;
  final PhotosTranslatorLocalAdapter adapter;
  final PathProvider pathProvider;
  final HttpResponsesManager httpResponsesManager;
  PhotosTranslatorRemoteDataSourceFake({
    required this.persistenceManager,
    required this.adapter,
    required this.pathProvider,
    required this.httpResponsesManager
  });
  @override
  Future<int> addTranslation(int fileId, Translation translation)async{
    return Random().nextInt(99999999);
  }

  @override
  Future<TranslationsFile> createTranslationsFile(String name)async{
    return TranslationsFile(id: Random().nextInt(99999999), name: name, completed: false, translations: const []);
  }

  @override
  Future<PdfFile> endTranslationFile(int id)async{
    final translationsFileJson = await persistenceManager.querySingleOne(translFilesTableName, id);
    final translationsFile = adapter.getTranslationsFileFromJson(translationsFileJson, []);
    return PdfFile(id: Random().nextInt(99999999), name: translationsFile.name, url: _examplePdfUrl);
  }

  @override
  Future<List<PdfFile>> getCompletedPdfFiles()async{
    final pdfFilesJson = await persistenceManager.queryAll(pdfFilesTableName);
    return adapter.getPdfFilesFromJson(pdfFilesJson);
  }

  @override
  Future<File> getGeneratedPdf(PdfFile file)async{
    try{
      Completer<File> completer = Completer();
      final pathParts = file.url.split('/');
      var request = await HttpClient().getUrl(
        Uri.https(pathParts[0], pathParts[1])
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
      throw ServerException(type: ServerExceptionType.NORMAL);
    }
  }

}