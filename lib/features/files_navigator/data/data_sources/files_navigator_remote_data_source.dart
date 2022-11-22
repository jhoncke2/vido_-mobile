import 'dart:io';
import 'package:vido/core/domain/file_parent_type.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/core/domain/entities/folder.dart';

abstract class FilesNavigatorRemoteDataSource{
  Future<Folder> getFolder(int folderId, FileParentType parentType, String accessToken);
  Future<File> getGeneratedPdf(String fileUrl, String accessToken);
  Future<List<SearchAppearance>> search(String text, String accessToken);
  Future<List<Map<String, dynamic>>> generateIcr(List<int> filesIds, String accessToken);
}