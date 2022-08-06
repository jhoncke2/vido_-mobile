import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import '../../presentation/use_cases/get_completed_files.dart';

class GetCompletedFilesImpl implements GetCompletedFiles{
  final PhotosTranslatorRepository repository;
  GetCompletedFilesImpl({
    required this.repository
  });
  @override
  Future<Either<PhotosTranslatorFailure, List<PdfFile>>> call()async{
    return await repository.getCompletedFiles();
  }

}