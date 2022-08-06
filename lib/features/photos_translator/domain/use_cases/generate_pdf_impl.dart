import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import '../../presentation/use_cases/generate_pdf.dart';

class GeneratePdfImpl implements GeneratePdf{
  final PhotosTranslatorRepository repository;
  const GeneratePdfImpl({
    required this.repository
  });

  @override
  Future<Either<PhotosTranslatorFailure, File>> call(PdfFile file)async{
    return await repository.generatePdf(file);
  }

}