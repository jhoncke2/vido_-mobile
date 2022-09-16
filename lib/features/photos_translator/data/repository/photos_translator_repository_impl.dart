import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/external/user_extra_info_getter.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_local_data_source.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_remote_data_source.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
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
  Future<Either<PhotosTranslatorFailure, int>> createTranslationsFile(String name, TranslationProccessType proccessType) async {
    return await _manageFunctionExceptions(()async{
      final parentId = await translFileParentFolderGetter.getCurrentFileId();
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final newFile = await remoteDataSource.createTranslationsFile(name, parentId, accessToken);
      newFile.proccessType = proccessType;
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
      print(stackTrace);
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
            final accessToken = await userExtraInfoGetter.getAccessToken();
            late Translation translationCompleted;
            if(translFile.proccessType == TranslationProccessType.icr){
              translationCompleted = await remoteDataSource.translateWithIcr(translFile.id, translation, accessToken);
            }else{
              translationCompleted = await localDataSource.translate(translation, translFile.id);
              await remoteDataSource.addTranslation(translFile.id, translationCompleted, accessToken);
            }
            await localDataSource.updateTranslation(translFile.id, translationCompleted);
            final createdFile = await localDataSource.getCurrentCreatedFile();
            final uncompletedFile = await localDataSource.getTranslationsFile(translFile.id);
            if((createdFile == null || createdFile.id != uncompletedFile.id) && uncompletedFile.translations.every((t) => t.text != null)){
              await _endFile(uncompletedFile);
            }
            await _translateFirstUncompletedPhoto();
            return;
          }
        }
      }
    }
  }

  Future<void> _endFile(TranslationsFile endedFile)async{
    final accessToken = await userExtraInfoGetter.getAccessToken();
    await remoteDataSource.endTranslationFile(endedFile.id, accessToken);
    await localDataSource.removeTranslationsFile(endedFile);
  }

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
}


