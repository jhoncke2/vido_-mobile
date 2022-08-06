import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import '../../domain/entities/pdf_file.dart';

abstract class GetCompletedFiles{
  Future<Either<PhotosTranslatorFailure, List<PdfFile>>> call();
}