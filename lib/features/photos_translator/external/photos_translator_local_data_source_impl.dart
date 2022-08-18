import 'package:vido/core/external/persistence.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_local_data_source.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/external/photos_translator_local_adapter.dart';

class PhotosTranslatorLocalDataSourceImpl implements PhotosTranslatorLocalDataSource{
  final PhotosTranslatorLocalAdapter adapter;
  final PersistenceManager persistenceManager;
  const PhotosTranslatorLocalDataSourceImpl({
    required this.adapter,
    required this.persistenceManager
  });
  
  @override
  Future<void> addPdfFile(PdfFile file) async {
    final fileJson = adapter.getJsonFromPdfFile(file);
    await persistenceManager.insert(pdfFilesTableName, fileJson);
  }

  @override
  Future<void> createTranslationsFile(TranslationsFile newFile) async {
    final fileJson = adapter.getJsonFromTranslationsFile(newFile);
    await persistenceManager.insert(translFilesTableName, fileJson);
  }

  @override
  Future<void> endTranslationsFileCreation() async {
    // TODO: implement endTranslationsFileCreation
    throw UnimplementedError();
  }

  @override
  Future<List<PdfFile>> getCompletedTranslationsFiles() async {
    // TODO: implement getCompletedTranslationsFiles
    throw UnimplementedError();
  }

  @override
  Future<TranslationsFile?> getCurrentCreatedFile() async {
    // TODO: implement getCurrentCreatedFile
    throw UnimplementedError();
  }

  @override
  Future<TranslationsFile> getUncompletedTranslationsFile(int fileId) async {
    // TODO: implement getUncompletedTranslationsFile
    throw UnimplementedError();
  }

  @override
  Future<List<TranslationsFile>> getUncompletedTranslationsFiles() async {
    // TODO: implement getUncompletedTranslationsFiles
    throw UnimplementedError();
  }

  @override
  Future<void> removeTranslationsFile(TranslationsFile file) async {
    // TODO: implement removeUncompletedFile
    throw UnimplementedError();
  }

  @override
  Future<void> saveUncompletedTranslation(String photoUrl) async {
    // TODO: implement saveUncompletedTranslation
    throw UnimplementedError();
  }

  @override
  Future<void> updatePdfFiles(List<PdfFile> files) async {
    // TODO: implement setCompletedFiles
    throw UnimplementedError();
  }

  @override
  Future<Translation> translate(Translation uncompletedTranslation, int translationsFileId) async {
    // TODO: implement translate
    throw UnimplementedError();
  }

  @override
  // TODO: implement translating
  Future<bool> get translating async => throw UnimplementedError();

  @override
  Future<void> updateTranslation(int fileId, Translation newTranslation, Translation lastTranslation) async {
    // TODO: implement updateTranslation
    throw UnimplementedError();
  }

}