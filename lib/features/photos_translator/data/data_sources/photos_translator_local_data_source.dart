import '../../domain/entities/pdf_file.dart';
import '../../domain/entities/translation.dart';
import '../../domain/entities/translations_file.dart';

abstract class PhotosTranslatorLocalDataSource {
  Future<void> createTranslationsFile(TranslationsFile newFile);
  Future<bool> get translating;
  Future<void> saveUncompletedTranslation(String photoUrl);
  Future<Translation> translate(Translation uncompletedTranslation, int translationsFileId);
  Future<void> updateTranslation(int fileId, Translation newTranslation, Translation lastTranslation);
  Future<void> endTranslationsFileCreation();
  Future<List<TranslationsFile>> getUncompletedTranslationsFiles();
  Future<TranslationsFile> getUncompletedTranslationsFile(int fileId);
  Future<List<PdfFile>> getCompletedTranslationsFiles();
  Future<void> updatePdfFiles(List<PdfFile> files);
  Future<void> addPdfFile(PdfFile file);
  Future<TranslationsFile?> getCurrentCreatedFile();
  Future<void> removeTranslationsFile(TranslationsFile file);
}
