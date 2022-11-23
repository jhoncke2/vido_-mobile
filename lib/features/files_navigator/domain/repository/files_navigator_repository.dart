import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/entities/app_file.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigator_failure.dart';
import 'package:vido/core/domain/entities/pdf_file.dart';

abstract class FilesNavigatorRepository{
  Future<Either<FilesNavigatorFailure, void>> loadFolderChildren(int? id);
  Future<Either<FilesNavigatorFailure, void>> loadFolderBrothers();
  Future<Either<FilesNavigatorFailure, File>> loadFilePdf(PdfFile file);
  Future<Either<FilesNavigatorFailure, File>> loadAppearancePdf(SearchAppearance appearance);
  Future<Either<FilesNavigatorFailure, List<SearchAppearance>>> search(String text);
  Future<Either<FilesNavigatorFailure, List<Map<String, dynamic>>>> generateIcr(List<int> ids);
  Future<Either<FilesNavigatorFailure, AppFile>> getCurrentFile();
}