import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/features/files_navigator/domain/repository/files_navigator_repository.dart';
import 'package:vido/core/domain/entities/pdf_file.dart';
import '../../../../core/domain/use_case_error_handler.dart';
import '../../presentation/use_cases/load_file_pdf.dart';
import '../failures/files_navigator_failure.dart';

class LoadFilePdfImpl implements LoadFilePdf{
  final UseCaseErrorHandler errorHandler;
  final FilesNavigatorRepository repository;
  const LoadFilePdfImpl({
    required this.repository,
    required this.errorHandler
  });

  @override
  Future<Either<FilesNavigatorFailure, File>> call(PdfFile file)async{
    return await errorHandler.executeFunction(
      () => repository.loadFilePdf(file)
    );
  }

}