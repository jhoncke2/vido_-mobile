import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/end_photos_translations_file.dart';
import '../../../../core/domain/use_case_error_handler.dart';

class EndPhotosTranslationsFileImpl implements EndPhotosTranslationsFile{
  final UseCaseErrorHandler errorHandler;
  final PhotosTranslatorRepository repository;
  EndPhotosTranslationsFileImpl({
    required this.repository,
    required this.errorHandler
  });
  @override
  Future<Either<PhotosTranslatorFailure, void>> call()async{
    return await errorHandler.executeFunction(
      () => repository.endPhotosTranslationFile()
    );
  }
}