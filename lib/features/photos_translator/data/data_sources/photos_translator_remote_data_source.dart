import 'dart:io';
import 'package:vido/core/domain/entities/pdf_file.dart';
import '../../domain/entities/translation.dart';
import '../../domain/entities/translations_file.dart';

abstract class PhotosTranslatorRemoteDataSource{
  Future<TranslationsFile> createTranslationsFile(String name, int parentId, String accessToken);
  Future<int> addTranslation(int fileId, Translation translation, String accessToken);
  Future<PdfFile> endTranslationFile(int id, String accessToken);
  Future<void> createFolder(String name, int parentId, String accessToken);
  Future<void> createPdfFile(String name, File pdf, int parentId, String accessToken);
}