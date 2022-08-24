import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/external/user_extra_info_getter.dart';
import 'package:vido/features/files_navigator/data/app_files_receiver.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_local_data_source.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_remote_data_source.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/domain/repository/files_navigator_repository.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import '../../../../core/domain/file_parent_type.dart';
import '../../../photos_translator/domain/entities/folder.dart';
import '../../domain/failures/files_navigation_failure.dart';

class FilesNavigatorRepositoryImpl implements FilesNavigatorRepository{
  final FilesNavigatorRemoteDataSource remoteDataSource;
  final FilesNavigatorLocalDataSource localDataSource;
  final UserExtraInfoGetter userExtraInfoGetter;
  final AppFilesReceiver appFilesReceiver;

  const FilesNavigatorRepositoryImpl({
    required this.remoteDataSource, 
    required this.localDataSource,
    required this.userExtraInfoGetter,
    required this.appFilesReceiver
  });
  
  @override
  Future<Either<FilesNavigationFailure, void>> loadFolderChildren(int? id)async{
    return await _manageFunctionExceptions(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      late List<AppFile> children;
      late int newFilesTreeLvl;
      if(id == null){
        final userId = await userExtraInfoGetter.getId();
        children = await remoteDataSource.getChildren(userId, FileParentType.user, accessToken);
        newFilesTreeLvl = 0;
      }else{
        children = await remoteDataSource.getChildren(id, FileParentType.folder, accessToken);
        newFilesTreeLvl = (await localDataSource.getFilesTreeLevel()) + 1;
        await localDataSource.setCurrentFileId(id);
      }
      await appFilesReceiver.setAppFiles(children);
      await localDataSource.setFilesTreeLvl(newFilesTreeLvl);
      return const Right(null);
    });
  }
  
  Future<Either<FilesNavigationFailure, T>> _manageFunctionExceptions<T>(
    Future<Either<FilesNavigationFailure, T>> Function() function
  )async{
    try{
      return await function();
    }on AppException catch(exception){
      return Left(FilesNavigationFailure(
        message: exception.message??'Ha ocurrido un error inesperado',
        exception: exception
      ));
    }catch(exception, stackTrace){
      return const Left(FilesNavigationFailure(
        message: 'Ha ocurrido un error inesperado',
        exception: AppException('')
      ));
    }
  }

  @override
  Future<Either<FilesNavigationFailure, void>> loadFolderBrothers()async{
    return await _manageFunctionExceptions(()async{
      final filesTreeLvl = await localDataSource.getFilesTreeLevel();
      if(filesTreeLvl > 0){
        final accessToken = await userExtraInfoGetter.getAccessToken();
        final fileId = await localDataSource.getCurrentFileId();
        final parent = (await remoteDataSource.getParentWithBrothers(fileId, accessToken)) as Folder;
        await appFilesReceiver.setAppFiles(parent.children);
        await localDataSource.setFilesTreeLvl(filesTreeLvl - 1);
        await localDataSource.setCurrentFileId(parent.id);
      }
      return const Right(null);
    });
  }

  @override
  Future<Either<FilesNavigationFailure, File>> loadPdf(PdfFile file)async{
    return await _manageFunctionExceptions(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final pdf = await remoteDataSource.getGeneratedPdf(file, accessToken);
      await localDataSource.setCurrentFileId(file.id);
      final treeLvl = await localDataSource.getFilesTreeLevel();
      await localDataSource.setFilesTreeLvl(treeLvl + 1);
      return Right(pdf);
    });
  }

  @override
  Future<Either<FilesNavigationFailure, List<SearchAppearance>>> search(String text)async{
    return await _manageFunctionExceptions(()async{
      final result = await remoteDataSource.search(text);
      return Right(result);
    });
  }
}