import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';

abstract class GenerateIcr{
  Future<Either<FilesNavigationFailure, List<Map<String, dynamic>>>> call(List<int> filesIds);
}