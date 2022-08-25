import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';

abstract class LoadAppearancePdf{
  Future<Either<FilesNavigationFailure, File>> call(SearchAppearance appearance);
}