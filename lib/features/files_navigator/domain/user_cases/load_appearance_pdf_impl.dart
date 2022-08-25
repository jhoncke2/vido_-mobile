import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/domain/repository/files_navigator_repository.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_appearance_pdf.dart';

class LoadAppearancePdfImpl implements LoadAppearancePdf{
  final FilesNavigatorRepository repository;
  const LoadAppearancePdfImpl({
    required this.repository
  });
  @override
  Future<Either<FilesNavigationFailure, File>> call(SearchAppearance appearance)async{
    return await repository.loadAppearancePdf(appearance);
  }

}