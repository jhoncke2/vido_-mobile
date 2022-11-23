import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/entities/app_file.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigator_failure.dart';

abstract class GetCurrentFile{
  Future<Either<FilesNavigatorFailure, AppFile>> call();
}