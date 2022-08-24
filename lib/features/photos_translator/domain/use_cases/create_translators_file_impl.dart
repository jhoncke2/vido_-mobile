import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/create_translations_file.dart';

class CreateTranslationsFileImpl implements CreateTranslationsFile{
  final PhotosTranslatorRepository repository;
  CreateTranslationsFileImpl({
    required this.repository
  });
  @override
  Future<Either<PhotosTranslatorFailure, int>> call(String name)async{
    return await repository.createTranslationsFile(name);
  }

}