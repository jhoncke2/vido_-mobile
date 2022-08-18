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

//TODO: Tener en cuenta caso en que celular se apague y la pérdida de información en inCompletingProcessLastFiles
class PhotosTranslatorRepositoryImpl implements PhotosTranslatorRepository {
  final PhotosTranslatorRemoteDataSource remoteDataSource;
  final PhotosTranslatorLocalDataSource localDataSource;
  final StreamController<List<TranslationsFile>> uncompletedFilesReceiver;
  final StreamController<List<TranslationsFile>> inCompletingProcessFileReceiver;
  final StreamController<List<PdfFile>> pdfFilesReceiver;
  final List<TranslationsFile> inCompletingProcessFiles = [];
  PhotosTranslatorRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.uncompletedFilesReceiver,
    required this.inCompletingProcessFileReceiver,
    required this.pdfFilesReceiver
  });

  @override
  Future<Either<PhotosTranslatorFailure, int>> createTranslatorsFile(String name) async {
    return await _manageFunctionExceptions(()async{
      final newFile = await remoteDataSource.createTranslationsFile(name);
      await localDataSource.createTranslationsFile(newFile);
      return Right(newFile.id);
    });
  }

  @override
  Future<Either<PhotosTranslatorFailure, void>> endPhotosTranslationFile() async {
    return await _manageFunctionExceptions(()async{
      await localDataSource.endTranslationsFileCreation();
      return const Right(null);
    });

  }

  Future<void> _endFile(TranslationsFile endedFile)async{
    final completedFile = await remoteDataSource.endTranslationFile(endedFile.id);
    inCompletingProcessFileReceiver.sink.add(List<TranslationsFile>.from(inCompletingProcessFiles)..add(endedFile));
    inCompletingProcessFiles.removeWhere((f) => f.id == endedFile.id);
    inCompletingProcessFileReceiver.sink.add(List<TranslationsFile>.from(inCompletingProcessFiles));
    await localDataSource.removeTranslationsFile(endedFile);
    await localDataSource.addPdfFile(completedFile);
  }

  @override
  Future<Either<PhotosTranslatorFailure, List<TranslationsFile>>> getUncompletedTranslationsFiles() async {
    return await _manageFunctionExceptions(()async{
      final translationsFiles = await localDataSource.getTranslationsFiles();
      return Right(translationsFiles);
    });
  }

  @override
  Future<Either<PhotosTranslatorFailure, void>> translatePhoto(String? photoUrl) async {
    await localDataSource.saveUncompletedTranslation(photoUrl!);
    await _translateFirstUncompletedPhoto();
    return const Right(null);
  }

  FutureOr<void> _translateFirstUncompletedPhoto() async {
    final uncompletedTranslationsFiles = await localDataSource.getTranslationsFiles();
    uncompletedFilesReceiver.sink.add(uncompletedTranslationsFiles);
    if( !(localDataSource.translating) ){
      for (final translFile in uncompletedTranslationsFiles) {
        for (final translation in translFile.translations) {
          if (translation.text == null) {
            final translationCompleted = await localDataSource.translate(translation, translFile.id);
            await localDataSource.updateTranslation(translFile.id, translationCompleted);
            await remoteDataSource.addTranslation(translFile.id, translationCompleted);
            final createdFile = await localDataSource.getCurrentCreatedFile();
            final uncompletedFile = await localDataSource.getTranslationsFile(translFile.id);

            if((createdFile == null || createdFile.id != uncompletedFile.id) && uncompletedFile.translations.every((t) => t.text != null)){
              await _endFile(uncompletedFile);
              final pdfFiles = await localDataSource.getPdfFiles();
              pdfFilesReceiver.sink.add(pdfFiles);
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
    return await _manageFunctionExceptions<List<PdfFile>>(()async{
      final pdfFiles = await remoteDataSource.getCompletedPdfFiles();
      final translationsFiles = await localDataSource.getTranslationsFiles();
      final pdfFilesUpdated = <PdfFile>[];
      for(final pdfFile in pdfFiles){
        if(!translationsFiles.any((tF) => tF.id == pdfFile.id)){
          pdfFilesUpdated.add(pdfFile);
        }
      }
      await localDataSource.updatePdfFiles(pdfFilesUpdated);
      pdfFilesReceiver.sink.add(pdfFilesUpdated);
      return Right(pdfFilesUpdated);
    });
  }

  @override
  Future<Either<PhotosTranslatorFailure, File>> generatePdf(PdfFile file)async{
    return await _manageFunctionExceptions<File>(()async{
      final pdf = await remoteDataSource.getGeneratedPdf(file);
      return Right(pdf);
    });
  }
  
  @override
  Future<Either<PhotosTranslatorFailure, void>> initPendingTranslations()async{
    await _translateFirstUncompletedPhoto();
    return const Right(null);
  }

  Future<Either<PhotosTranslatorFailure, T>> _manageFunctionExceptions<T>(
    Future<Either<PhotosTranslatorFailure, T>> Function() function
  )async{
    try{
      return await function();
    }on AppException catch(exception){
      return Left(PhotosTranslatorFailure(
        message: exception.message??'Ha ocurrido un error inesperado',
        exception: exception
      ));
    }catch(exception, stackTrace){
      print(stackTrace);
      return const Left(PhotosTranslatorFailure(
        message: 'Ha ocurrido un error inesperado',
        exception: AppException(null)
      ));
    }
  }
}
