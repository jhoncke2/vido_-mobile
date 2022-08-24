import '../../domain/entities/translation.dart';
import '../../domain/entities/translations_file.dart';

abstract class PhotosTranslatorLocalDataSource {
  Future<void> createTranslationsFile(TranslationsFile newFile);
  bool get translating;
  Future<void> saveUncompletedTranslation(String photoUrl);
  Future<Translation> translate(Translation uncompletedTranslation, int translationsFileId);
  Future<void> updateTranslation(int fileId, Translation translation);
  Future<void> endTranslationsFileCreation();
  Future<List<TranslationsFile>> getTranslationsFiles();
  Future<TranslationsFile> getTranslationsFile(int fileId);
  Future<TranslationsFile?> getCurrentCreatedFile();
  Future<void> removeTranslationsFile(TranslationsFile file);
}
