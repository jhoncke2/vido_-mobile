import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigator_failure.dart';
import 'package:vido/core/domain/entities/pdf_file.dart';

abstract class LoadFilePdf{
  Future<Either<FilesNavigatorFailure, File>> call(PdfFile file);
}