import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';

abstract class LoadFilePdf{
  Future<Either<FilesNavigationFailure, File>> call(PdfFile file);
}