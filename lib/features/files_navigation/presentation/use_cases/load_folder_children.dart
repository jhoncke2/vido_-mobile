import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigation/domain/failures/files_navigation_failure.dart';

abstract class LoadFolderChildren{
  Future<Either<FilesNavigationFailure, void>> call(int? id);
}