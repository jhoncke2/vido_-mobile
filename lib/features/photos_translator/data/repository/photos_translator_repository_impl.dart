import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_local_data_source.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_remote_data_source.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import '../../domain/entities/translation.dart';

//TODO: Tener en cuenta caso en que celular se apague y la pérdida de información en inCompletingProcessLastFiles
class PhotosTranslatorRepositoryImpl implements PhotosTranslatorRepository {
  final PhotosTranslatorRemoteDataSource remoteDataSource;
  final PhotosTranslatorLocalDataSource localDataSource;
  final StreamController<List<TranslationsFile>> uncompletedFilesReceiver;
  final StreamController<List<TranslationsFile>> inCompletingProcessFileReceiver;
  final StreamController<List<PdfFile>> completedFilesReceiver;
  final List<TranslationsFile> inCompletingProcessFiles = [];
  PhotosTranslatorRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.uncompletedFilesReceiver,
    required this.inCompletingProcessFileReceiver,
    required this.completedFilesReceiver
  });

  @override
  Future<Either<PhotosTranslatorFailure, int>> createTranslatorsFile(String name) async {
    final newFile = await remoteDataSource.createTranslationsFile(name);
    await localDataSource.createTranslationFile(newFile);
    return Right(newFile.id);
  }

  @override
  Future<Either<PhotosTranslatorFailure, void>> endPhotosTranslationFile() async {
    await localDataSource.endTranslationsFileCreation();
    return const Right(null);
  }

  Future<void> _endFile(TranslationsFile endedFile)async{
    inCompletingProcessFileReceiver.sink.add(List<TranslationsFile>.from(inCompletingProcessFiles));
    final completedFile = await remoteDataSource.endTranslationFile(endedFile.id);
    inCompletingProcessFiles.removeWhere((f) => f.id == endedFile.id);
    inCompletingProcessFileReceiver.sink.add(List<TranslationsFile>.from(inCompletingProcessFiles));
    await localDataSource.removeUncompletedFile(endedFile);
    await localDataSource.addPdfFile(completedFile);
  }

  @override
  Future<Either<PhotosTranslatorFailure, List<TranslationsFile>>> getUncompletedTranslationsFiles() async {
    final translationsFiles = await localDataSource.getUncompletedTranslationsFiles();
    return Right(translationsFiles);
  }

  @override
  Future<Either<PhotosTranslatorFailure, void>> translatePhoto(String? photoUrl) async {
    await localDataSource.saveUncompletedTranslation(photoUrl!);
    await _translateFirstUncompletedPhoto();
    return const Right(null);
  }

  FutureOr<void> _translateFirstUncompletedPhoto() async {
    final uncompletedTranslationsFiles = await localDataSource.getUncompletedTranslationsFiles();
    uncompletedFilesReceiver.sink.add(uncompletedTranslationsFiles);
    if( !(await localDataSource.translating) ){
      for (final translFile in uncompletedTranslationsFiles) {
        for (final translation in translFile.translations) {
          if (translation.text == null) {
            final translationUpdated = await localDataSource.translate(translation, translFile.id);
            final newTransId = await remoteDataSource.addTranslation(translFile.id, translationUpdated);
            final translationWithNewId = Translation(
              id: newTransId,
              text: translationUpdated.text,
              imgUrl: translationUpdated.imgUrl
            );
            await localDataSource.updateTranslation(translFile.id, translationWithNewId, translation);
            final createdFile = await localDataSource.getCurrentCreatedFile();
            final uncompletedFile = await localDataSource.getUncompletedTranslationsFile(translFile.id);

            if((createdFile == null || createdFile.id != uncompletedFile.id) && uncompletedFile.translations.every((t) => t.text != null)){
              await _endFile(uncompletedFile);
              final completedFiles = await localDataSource.getCompletedTranslationsFiles();
              completedFilesReceiver.sink.add(completedFiles);
            }
            await _translateFirstUncompletedPhoto();
            return;
          }
        }
      }
    }
  }
  
  @override
  Future<Either<PhotosTranslatorFailure, List<PdfFile>>> getCompletedFiles()async{
    try{
      final pdfFiles = await remoteDataSource.getCompletedPdfFiles();
      await localDataSource.updatePdfFiles(pdfFiles);
      completedFilesReceiver.sink.add(pdfFiles);
      return Right(pdfFiles);
    }on ServerException	 catch(err){
      return Left(PhotosTranslatorFailure(err.message));
    }catch(err){
      return Left(PhotosTranslatorFailure('Ha ocurrido un error inesperado: ${err.toString()}'));
    }
  }

  @override
  Future<Either<PhotosTranslatorFailure, File>> generatePdf(PdfFile file)async{
    final pdf = await remoteDataSource.getGeneratedPdf(file);
    return Right(pdf);
  }
}
