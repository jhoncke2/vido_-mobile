import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';

abstract class FilesNavigatorRepository{
  Future<Either<FilesNavigationFailure, void>> loadFolderChildren(int? id);
  Future<Either<FilesNavigationFailure, void>> loadFolderBrothers();
  Future<Either<FilesNavigationFailure, File>> loadPdf(PdfFile file);
  Future<Either<FilesNavigationFailure, List<SearchAppearance>>> search(String text);
}