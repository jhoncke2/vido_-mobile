import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/end_photos_translations_file.dart';

class EndPhotosTranslationsFileImpl implements EndPhotosTranslationsFile{
  final PhotosTranslatorRepository repository;
  EndPhotosTranslationsFileImpl({
    required this.repository
  });
  @override
  Future<Either<PhotosTranslatorFailure, void>> call()async{
    return await repository.endPhotosTranslationFile();
  }

}