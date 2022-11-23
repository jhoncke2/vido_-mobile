import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigator_failure.dart';

abstract class LoadFolderBrothers{
  Future<Either<FilesNavigatorFailure, void>> call();
}