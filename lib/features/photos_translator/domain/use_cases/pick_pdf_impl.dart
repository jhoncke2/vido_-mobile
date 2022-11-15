import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';
import 'package:vido/features/photos_translator/presentation/use_cases/pick_pdf.dart';
import '../../../../core/domain/use_case_error_handler.dart';
import '../repository/photos_translator_repository.dart';

class PickPdfImpl implements PickPdf{
  final UseCaseErrorHandler errorHandler;
  final PhotosTranslatorRepository repository;
  PickPdfImpl({
    required this.repository,
    required this.errorHandler
  });
  @override
  Future<Either<PhotosTranslatorFailure, File>> call()async{
    return await errorHandler.executeFunction<PhotosTranslatorFailure, File>(
      () => repository.pickFile()
    );
  }
}