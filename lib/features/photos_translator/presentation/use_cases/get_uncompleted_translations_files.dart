import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';

abstract class GetUncompletedTranslationsFiles{
  Future<Either<PhotosTranslatorFailure, List<TranslationsFile>>> call();
}