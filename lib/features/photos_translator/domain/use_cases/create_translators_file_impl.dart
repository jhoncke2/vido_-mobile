import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/create_translations_file.dart';
import '../../../../core/domain/use_case_error_handler.dart';

class CreateTranslationsFileImpl implements CreateTranslationsFile{
  final UseCaseErrorHandler errorHandler;
  final PhotosTranslatorRepository repository;
  CreateTranslationsFileImpl({
    required this.repository,
    required this.errorHandler
  });
  @override
  Future<Either<PhotosTranslatorFailure, int>> call(String name, TranslationProccessType proccessType)async{
    return await errorHandler.executeFunction(
      () => repository.createTranslationsFile(name, proccessType)
    );
  }
}