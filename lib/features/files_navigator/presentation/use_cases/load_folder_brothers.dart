import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';

abstract class LoadFolderBrothers{
  Future<Either<FilesNavigationFailure, void>> call();
}