import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/create_folder.dart';
import '../../../../core/domain/use_case_error_handler.dart';

class CreateFolderImpl implements CreateFolder{
  final UseCaseErrorHandler errorHandler;
  final PhotosTranslatorRepository repository;
  const CreateFolderImpl({
    required this.repository,
    required this.errorHandler
  });
  @override
  Future<Either<PhotosTranslatorFailure, void>> call(String name)async{
    return await errorHandler.executeFunction(
      () => repository.createFolder(name)
    );
  }
}