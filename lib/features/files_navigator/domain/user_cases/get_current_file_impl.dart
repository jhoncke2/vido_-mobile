import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigator_failure.dart';
import 'package:vido/core/domain/entities/app_file.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/get_current_file.dart';
import '../../../../core/domain/use_case_error_handler.dart';
import '../repository/files_navigator_repository.dart';

class GetCurrentFileImpl implements GetCurrentFile{
  final UseCaseErrorHandler errorHandler;
  final FilesNavigatorRepository repository;
  const GetCurrentFileImpl({
    required this.repository,
    required this.errorHandler
  });
  
  @override
  Future<Either<FilesNavigatorFailure, AppFile>> call()async{
    return await errorHandler.executeFunction<FilesNavigatorFailure, AppFile>(
      () => repository.getCurrentFile()
    );
  }
}