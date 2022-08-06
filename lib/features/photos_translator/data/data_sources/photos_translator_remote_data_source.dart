import 'dart:io';

import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import '../../domain/entities/translation.dart';
import '../../domain/entities/translations_file.dart';

abstract class PhotosTranslatorRemoteDataSource{
  Future<TranslationsFile> createTranslationsFile(String name);
  Future<int> addTranslation(int fileId, Translation translation);
  Future<List<PdfFile>> getCompletedPdfFiles();
  Future<PdfFile> endTranslationFile(int id);
  Future<File> getGeneratedPdf(PdfFile file);
}