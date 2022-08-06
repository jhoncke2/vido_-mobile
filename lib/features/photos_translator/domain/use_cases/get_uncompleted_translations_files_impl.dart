import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/get_uncompleted_translations_files.dart';

class GetUncompletedTranslationsFilesImpl implements GetUncompletedTranslationsFiles{
  final PhotosTranslatorRepository repository;
  GetUncompletedTranslationsFilesImpl({
    required this.repository
  });
  @override
  Future<Either<PhotosTranslatorFailure, List<TranslationsFile>>> call()async{
    return await repository.getUncompletedTranslationsFiles();
  }
  
}