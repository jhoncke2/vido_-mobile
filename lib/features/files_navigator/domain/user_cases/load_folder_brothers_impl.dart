import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_folder_brothers.dart';
import '../../../../core/domain/use_case_error_handler.dart';
import '../repository/files_navigator_repository.dart';

class LoadFolderBrothersImpl implements LoadFolderBrothers{
  final UseCaseErrorHandler errorHandler;
  final FilesNavigatorRepository repository;
  const LoadFolderBrothersImpl({
    required this.repository,
    required this.errorHandler
  });
  @override
  Future<Either<FilesNavigationFailure, void>> call()async{
    return await errorHandler.executeFunction(
      () => repository.loadFolderBrothers()
    );
  }
}