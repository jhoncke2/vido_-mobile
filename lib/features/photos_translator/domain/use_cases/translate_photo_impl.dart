import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/translate_photo.dart';

class TranslatePhotoImpl implements TranslatePhoto{
  final PhotosTranslatorRepository repository;
  TranslatePhotoImpl({
    required this.repository
  });
  @override
  Future<Either<PhotosTranslatorFailure, void>> call(String photoUrl)async{
    return await repository.translatePhoto(photoUrl);
  }

}