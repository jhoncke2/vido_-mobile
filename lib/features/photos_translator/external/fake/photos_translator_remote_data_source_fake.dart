import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:vido/core/external/persistence.dart';
import 'package:vido/core/external/remote_data_source.dart';
import 'package:vido/core/utils/http_responses_manager.dart';
import 'package:vido/core/utils/path_provider.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_remote_data_source.dart';
import 'package:vido/core/domain/entities/app_file.dart';
import 'package:vido/core/domain/entities/folder.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
import 'package:vido/core/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/external/photos_translator_local_adapter.dart';
import '../../../files_navigator/external/fake/tree.dart';

class PhotosTranslatorRemoteDataSourceFake extends RemoteDataSourceWithMultiPartRequests implements PhotosTranslatorRemoteDataSource{
  static const _examplePdfUrl = 'www.africau.edu/images/default/sample.pdf';
  final DatabaseManager persistenceManager;
  final PhotosTranslatorLocalAdapter adapter;
  final PathProvider pathProvider;
  final HttpResponsesManager httpResponsesManager;
  final Tree<int, AppFile> filesTree;
  PhotosTranslatorRemoteDataSourceFake({
    required this.persistenceManager,
    required this.adapter,
    required this.pathProvider,
    required this.httpResponsesManager,
    required this.filesTree
  });
  @override
  Future<int> addTranslation(int fileId, Translation translation, String accessToken)async{
    return Random().nextInt(99999999);
  }

  @override
  Future<TranslationsFile> createTranslationsFile(String name, int parentId, String accessToken)async{
    return TranslationsFile(id: Random().nextInt(99999999), name: name, completed: false, translations: const []);
  }

  @override
  Future<PdfFile> endTranslationFile(int id, String accessToken)async{
    final translationsFileJson = await persistenceManager.querySingleOne(translFilesTableName, id);
    final translationsFile = adapter.getTranslationsFileFromJson(translationsFileJson, []);
    final pdfFile = PdfFile(
      id: Random().nextInt(99999999), 
      name: translationsFile.name, 
      url: _examplePdfUrl, 
      parentId: 100,
      canBeRead: true,
      canBeDeleted: true,
      canBeEdited: true
    );
    return pdfFile;
  }
  
  @override
  Future<void> createFolder(String name, int parentId, String accessToken)async{
    final newFolder = Folder(
      id: Random().nextInt(999999999), 
      name: name,
      parentId: parentId, 
      children: [],
      canBeRead: true,
      canBeDeleted: true,
      canBeEdited: true,
      canBeCreatedOnIt: true
    );
    final parentFolder = filesTree.getAt(parentId);
    (parentFolder as Folder).children.add(newFolder);
    filesTree.addAt(parentId, newFolder);
  }

  @override
  Future<void> createPdfFile(String name, File pdf, int parentId, String accessToken)async{
    final pdfFile = PdfFile(
      id: Random().nextInt(9999999),
      name: name,
      url: pdf.path,
      parentId: parentId,
      canBeRead: true,
      canBeDeleted: true,
      canBeEdited: true
    );
    filesTree.addAt(parentId, pdfFile);
  }
}