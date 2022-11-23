import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigator_failure.dart';

abstract class Search{
  Future<Either<FilesNavigatorFailure, List<SearchAppearance>>> call(String text);
}