import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/create_folder.dart';

class CreateFolderImpl implements CreateFolder{
  final PhotosTranslatorRepository repository;
  const CreateFolderImpl({
    required this.repository
  });
  @override
  Future<Either<PhotosTranslatorFailure, void>> call(String name)async{
    return await repository.createFolder(name);
  }
}