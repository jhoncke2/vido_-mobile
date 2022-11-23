import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigator_failure.dart';

abstract class GenerateIcr{
  Future<Either<FilesNavigatorFailure, List<Map<String, dynamic>>>> call(List<int> filesIds);
}