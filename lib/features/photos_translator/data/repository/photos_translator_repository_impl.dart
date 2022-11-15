import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/external/user_extra_info_getter.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_local_data_source.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_remote_data_source.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import 'package:vido/features/photos_translator/domain/translations_files_receiver.dart';
import '../../../../core/external/translations_file_parent_folder_getter.dart';

//TODO: Tener en cuenta caso en que celular se apague y la pérdida de información en inCompletingProcessLastFiles
class PhotosTranslatorRepositoryImpl implements PhotosTranslatorRepository {
  final PhotosTranslatorRemoteDataSource remoteDataSource;
  final PhotosTranslatorLocalDataSource localDataSource;
  final TranslationsFilesReceiver translationsFilesReceiver;
  final TranslationsFileParentFolderGetter translFileParentFolderGetter;
  final UserExtraInfoGetter userExtraInfoGetter;
  PhotosTranslatorRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.translationsFilesReceiver,
    required this.translFileParentFolderGetter,
    required this.userExtraInfoGetter
  });

  @override
  Future<Either<PhotosTranslatorFailure, int>> createTranslationsFile(String name) async {
    return await _manageFunctionExceptions(()async{
      final parentId = await translFileParentFolderGetter.getCurrentFileId();
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final newFile = await remoteDataSource.createTranslationsFile(name, parentId, accessToken);
      await localDataSource.createTranslationsFile(newFile);
      return Right(newFile.id);
    });
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
      return const Left(PhotosTranslatorFailure(
        message: 'Ha ocurrido un error inesperado',
        exception: AppException(null)
      ));
    }
  }

  @override
  Future<Either<PhotosTranslatorFailure, void>> endPhotosTranslationFile() async {
    return await _manageFunctionExceptions(()async{
      await localDataSource.endTranslationsFileCreation();
      return const Right(null);
    });

  }

  Future<void> _endFile(TranslationsFile endedFile)async{
    final accessToken = await userExtraInfoGetter.getAccessToken();
    await remoteDataSource.endTranslationFile(endedFile.id, accessToken);
    await localDataSource.removeTranslationsFile(endedFile);
  }

  @override
  Future<Either<PhotosTranslatorFailure, void>> translatePhoto(String? photoUrl) async {
    await localDataSource.saveUncompletedTranslation(photoUrl!);
    await _translateFirstUncompletedPhoto();
    return const Right(null);
  }

  FutureOr<void> _translateFirstUncompletedPhoto() async {
    final uncompletedTranslationsFiles = await localDataSource.getTranslationsFiles();
    translationsFilesReceiver.setTranslationsFiles(uncompletedTranslationsFiles);
    if( !(localDataSource.translating) ){
      for (final translFile in uncompletedTranslationsFiles) {
        for (final translation in translFile.translations) {
          if (translation.text == null) {
            final translationCompleted = await localDataSource.translate(translation, translFile.id);
            await localDataSource.updateTranslation(translFile.id, translationCompleted);
            final accessToken = await userExtraInfoGetter.getAccessToken();
            await remoteDataSource.addTranslation(translFile.id, translationCompleted, accessToken);
            await _endCurrentFileIfCompleted(translFile);
            await _translateFirstUncompletedPhoto();
            return;
          }
        }
        await _endCurrentFileIfCompleted(translFile);
      }
    }
  }

  Future<void> _endCurrentFileIfCompleted(TranslationsFile translFile)async{
    final createdFile = await localDataSource.getCurrentCreatedFile();
    final uncompletedFile = await localDataSource.getTranslationsFile(translFile.id);
    if(_canEndFile(uncompletedFile, createdFile)){
      await _endFile(uncompletedFile);
    }
  }

  bool _canEndFile(TranslationsFile uncompletedFile, TranslationsFile? createdFile) => 
      (createdFile == null || createdFile.id != uncompletedFile.id) 
      && uncompletedFile.translations.every((t) => t.text != null);

  @override
  Future<Either<PhotosTranslatorFailure, void>> createFolder(String name)async{
    final accessToken = await userExtraInfoGetter.getAccessToken();
    final currentFileId = await translFileParentFolderGetter.getCurrentFileId();
    await remoteDataSource.createFolder(name, currentFileId, accessToken);
    return const Right(null);
  }

  @override
  Future<Either<PhotosTranslatorFailure, void>> initPendingTranslations()async{
    await _translateFirstUncompletedPhoto();
    return const Right(null);
  }

  @override
  Future<Either<PhotosTranslatorFailure, File>> pickFile()async{
    return await _tryFunction(()async{
      final pdf = await localDataSource.pickPdf();
      return Right(pdf);
    });
  }

  Future<Either<PhotosTranslatorFailure, T>> _tryFunction<T>(Future<Either<PhotosTranslatorFailure, T>> Function() function)async{
    try{
      return await function();
    }on AppException catch(exception){
      return Left(PhotosTranslatorFailure(
        exception: exception,
        message: exception.message??''
      ));
    }on Object{
      return const Left(PhotosTranslatorFailure(
        exception: AppException(''),
        message: ''
      ));
    }
  }

  @override
  Future<Either<PhotosTranslatorFailure, void>> createPdfFile(String name, File file)async{
    return await _tryFunction(()async{
      final parentId = await translFileParentFolderGetter.getCurrentFileId();
      final accessToken = await userExtraInfoGetter.getAccessToken();
      await remoteDataSource.createPdfFile(name, file, parentId, accessToken);
      return const Right(null);
    });
  }
}


