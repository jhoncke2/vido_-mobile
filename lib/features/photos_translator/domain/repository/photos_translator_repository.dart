import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import '../entities/translations_file.dart';

abstract class PhotosTranslatorRepository{
  Future<Either<PhotosTranslatorFailure, int>> createTranslationsFile(String name, TranslationProccessType proccessType);
  Future<Either<PhotosTranslatorFailure, void>> translatePhoto(String photoUrl);
  Future<Either<PhotosTranslatorFailure, void>> endPhotosTranslationFile();
  Future<Either<PhotosTranslatorFailure, void>> createFolder(String name);
  Future<Either<PhotosTranslatorFailure, void>> initPendingTranslations();
}