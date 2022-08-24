import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/repository/files_navigator_repository.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/search.dart';

class SearchImpl implements Search{
  final FilesNavigatorRepository repository;
  const SearchImpl({
    required this.repository
  });
  @override
  Future<Either<FilesNavigationFailure, List<SearchAppearance>>> call(String text)async{
    return await repository.search(text);
  }
  
}