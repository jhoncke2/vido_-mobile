import 'dart:io';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import '../../../../core/domain/file_parent_type.dart';
import '../../domain/entities/translation.dart';
import '../../domain/entities/translations_file.dart';

abstract class PhotosTranslatorRemoteDataSource{
  Future<TranslationsFile> createTranslationsFile(String name, int parentId, FileParentType parentType, String accessToken);
  Future<int> addTranslation(int fileId, Translation translation, String accessToken);
  Future<PdfFile> endTranslationFile(int id, String accessToken);
  Future<void> createFolder(String name, int parentId, FileParentType parentType, String accessToken);
}