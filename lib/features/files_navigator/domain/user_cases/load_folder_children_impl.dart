import 'package:vido/core/domain/use_case_error_handler.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/repository/files_navigator_repository.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_folder_children.dart';

class LoadFolderChildrenImpl implements LoadFolderChildren{
  final UseCaseErrorHandler errorHandler;
  final FilesNavigatorRepository repository;
  const LoadFolderChildrenImpl({
    required this.repository,
    required this.errorHandler
  });
  @override
  Future<Either<FilesNavigationFailure, void>> call(int? id)async{
    return await errorHandler.executeFunction<FilesNavigationFailure, void>(
      () => repository.loadFolderChildren(id)
    );
  }
}