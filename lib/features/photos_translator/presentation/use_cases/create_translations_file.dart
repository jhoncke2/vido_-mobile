import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import '../../domain/entities/translations_file.dart';

abstract class CreateTranslationsFile{
  Future<Either<PhotosTranslatorFailure, int>> call(String name, TranslationProccessType proccessType);
}