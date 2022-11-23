import 'package:dartz/dartz.dart';
import '../../domain/failures/files_navigator_failure.dart';

abstract class LoadFolderChildren{
  Future<Either<FilesNavigatorFailure, void>> call(int? id);
}