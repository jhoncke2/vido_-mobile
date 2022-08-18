import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';

abstract class PhotosTranslatorRepository{
  Future<Either<PhotosTranslatorFailure, int>> createTranslatorsFile(String name);
  Future<Either<PhotosTranslatorFailure, void>> translatePhoto(String photoUrl);
  Future<Either<PhotosTranslatorFailure, void>> endPhotosTranslationFile();
  Future<Either<PhotosTranslatorFailure, List<TranslationsFile>>> getUncompletedTranslationsFiles();
  Future<Either<PhotosTranslatorFailure, List<PdfFile>>> getCompletedFiles();
  Future<Either<PhotosTranslatorFailure, File>> generatePdf(PdfFile file);
  Future<Either<PhotosTranslatorFailure, void>> initPendingTranslations();
}