import 'package:dartz/dartz.dart';
import '../../domain/failures/files_navigation_failure.dart';

abstract class LoadFolderChildren{
  Future<Either<FilesNavigationFailure, void>> call(int? id);
}