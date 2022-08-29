import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/translate_photo.dart';
import '../../../../core/domain/use_case_error_handler.dart';

class TranslatePhotoImpl implements TranslatePhoto{
  final UseCaseErrorHandler errorHandler;
  final PhotosTranslatorRepository repository;
  TranslatePhotoImpl({
    required this.repository,
    required this.errorHandler
  });
  @override
  Future<Either<PhotosTranslatorFailure, void>> call(String photoUrl)async{
    return await errorHandler.executeFunction(
      () => repository.translatePhoto(photoUrl)
    );
  }
}