import 'dart:io';
import 'package:vido/core/domain/file_parent_type.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';

abstract class FilesNavigatorRemoteDataSource{
  Future<List<AppFile>> getChildren(int folderId, FileParentType parentType, String accessToken);
  Future<AppFile> getParentWithBrothers(int folderId, String accessToken);
  Future<File> getGeneratedPdf(PdfFile file, String accessToken);
  Future<List<SearchAppearance>> search(String text);
}