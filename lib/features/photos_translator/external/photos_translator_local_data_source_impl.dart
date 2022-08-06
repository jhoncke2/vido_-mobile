import 'package:vido/core/external/persistence.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_local_data_source.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/external/photos_translator_remote_adapter.dart';

class PhotosTranslatorLocalDataSourceImpl implements PhotosTranslatorLocalDataSource{
  final PhotosTranslatorRemoteAdapter adapter;
  final PersistenceManager persistenceManager;
  const PhotosTranslatorLocalDataSourceImpl({
    required this.adapter,
    required this.persistenceManager
  });
  
  @override
  Future<void> addCompletedFile(PdfFile file) async {
    // TODO: implement addCompletedFile
    throw UnimplementedError();
  }

  @override
  Future<void> createTranslationFile(TranslationsFile newFile) async {
    // TODO: implement createTranslationFile
    throw UnimplementedError();
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
  Future<void> removeUncompletedFile(TranslationsFile file) async {
    // TODO: implement removeUncompletedFile
    throw UnimplementedError();
  }

  @override
  Future<void> saveUncompletedTranslation(String photoUrl) async {
    // TODO: implement saveUncompletedTranslation
    throw UnimplementedError();
  }

  @override
  Future<void> updateCompletedFiles(List<PdfFile> files) async {
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