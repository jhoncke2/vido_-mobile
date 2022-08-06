import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';

abstract class GeneratePdf{
  Future<Either<PhotosTranslatorFailure, File>> call(PdfFile file);
}