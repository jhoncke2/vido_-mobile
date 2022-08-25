import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/repository/files_navigator_repository.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import '../../presentation/use_cases/load_file_pdf.dart';
import '../failures/files_navigation_failure.dart';

class LoadFilePdfImpl implements LoadFilePdf{
  final FilesNavigatorRepository repository;
  const LoadFilePdfImpl({
    required this.repository
  });

  @override
  Future<Either<FilesNavigationFailure, File>> call(PdfFile file)async{
    return await repository.loadFilePdf(file);
  }

}