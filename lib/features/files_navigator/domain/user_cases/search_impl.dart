import 'package:vido/features/files_navigator/domain/failures/files_navigator_failure.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/repository/files_navigator_repository.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/search.dart';
import '../../../../core/domain/use_case_error_handler.dart';

class SearchImpl implements Search{
  final UseCaseErrorHandler errorHandler;
  final FilesNavigatorRepository repository;
  const SearchImpl({
    required this.repository,
    required this.errorHandler
  });
  @override
  Future<Either<FilesNavigatorFailure, List<SearchAppearance>>> call(String text)async{
    return await errorHandler.executeFunction<FilesNavigatorFailure, List<SearchAppearance>>(
      () => repository.search(text)
    );
     
  }
  
}