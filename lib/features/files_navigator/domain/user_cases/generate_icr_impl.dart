import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/use_case_error_handler.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';
import 'package:vido/features/files_navigator/domain/repository/files_navigator_repository.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/generate_icr.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';

class GenerateIcrImpl implements GenerateIcr{
  final FilesNavigatorRepository repository;
  final UseCaseErrorHandler errorHandler;
  const GenerateIcrImpl({
    required this.repository, 
    required this.errorHandler
  });
  @override
  Future<Either<FilesNavigationFailure, List<Map<String, dynamic>>>> call(List<int> filesIds)async{
    // TODO: implement call
    throw UnimplementedError();
  }

}