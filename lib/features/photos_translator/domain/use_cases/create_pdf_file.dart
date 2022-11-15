import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';
import 'package:vido/features/photos_translator/presentation/use_cases/create_pdf_file.dart';
import '../../../../core/domain/use_case_error_handler.dart';
import '../repository/photos_translator_repository.dart';

class CreatePdfFileImpl implements CreatePdfFile{
  final UseCaseErrorHandler errorHandler;
  final PhotosTranslatorRepository repository;
  CreatePdfFileImpl({
    required this.repository,
    required this.errorHandler
  });
  @override
  Future<Either<PhotosTranslatorFailure, void>> call(String name, File pdf)async{
    return await errorHandler.executeFunction<PhotosTranslatorFailure, void>(
      () => repository.createPdfFile(name, pdf)
    );
  }

}