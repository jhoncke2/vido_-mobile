import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/entities/app_file.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';

abstract class GetCurrentFile{
  Future<Either<FilesNavigationFailure, AppFile>> call();
}