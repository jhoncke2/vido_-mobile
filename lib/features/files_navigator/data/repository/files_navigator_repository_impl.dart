import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/external/user_extra_info_getter.dart';
import 'package:vido/features/files_navigator/data/app_files_receiver.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_local_data_source.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_remote_data_source.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/domain/repository/files_navigator_repository.dart';
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
      late Folder folder;
      final treeLvl = await localDataSource.getFilesTreeLevel();
      if(id == null){
        if(treeLvl == null || treeLvl == 0){
          final userId = await userExtraInfoGetter.getId();
          folder = await remoteDataSource.getFolder(userId, FileParentType.user, accessToken);
          await localDataSource.setCurrentFileId(folder.id);
        }else{
          final folderId = await localDataSource.getCurrentFileId();
          folder = await remoteDataSource.getFolder(folderId, FileParentType.folder, accessToken);
          await localDataSource.setParentId(folder.parentId!);
        }
        if(treeLvl == null){
          await localDataSource.setFilesTreeLvl(0);
        }
      }else{
        folder = await remoteDataSource.getFolder(id, FileParentType.folder, accessToken);
        await localDataSource.setCurrentFileId(id);
        await localDataSource.setFilesTreeLvl(treeLvl! + 1);
        await localDataSource.setParentId(folder.parentId!);
      }
      await appFilesReceiver.setAppFiles(folder.children);
      
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
    }catch(exception){
      return const Left(FilesNavigationFailure(
        message: 'Ha ocurrido un error inesperado',
        exception: AppException('')
      ));
    }
  }

  @override
  Future<Either<FilesNavigationFailure, void>> loadFolderBrothers()async{
    return await _manageFunctionExceptions(()async{
      final filesTreeLvlInit = (await localDataSource.getFilesTreeLevel())!;
      if(filesTreeLvlInit > 0){
        final accessToken = await userExtraInfoGetter.getAccessToken();
        late int parentId;
        late FileParentType parentType;
        if(filesTreeLvlInit == 1){
          parentId = await userExtraInfoGetter.getId();
          parentType = FileParentType.user;
        }else{
          parentId = await localDataSource.getParentId();
          parentType = FileParentType.folder;
        }
        final folder = await remoteDataSource.getFolder(parentId, parentType, accessToken);
        await appFilesReceiver.setAppFiles(folder.children);
        final filesTreeLevelUpdated = filesTreeLvlInit - 1;
        await localDataSource.setFilesTreeLvl(filesTreeLevelUpdated);
        await localDataSource.setCurrentFileId(folder.id);
        if(filesTreeLevelUpdated > 0){
          await localDataSource.setParentId(folder.parentId!);
        }
      }
      return const Right(null);
    });
  }

  @override
  Future<Either<FilesNavigationFailure, File>> loadFilePdf(PdfFile file)async{
    return await _manageFunctionExceptions(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final pdf = await remoteDataSource.getGeneratedPdf(file.url, accessToken);
      final newParentId = await localDataSource.getCurrentFileId();
      await localDataSource.setParentId(newParentId);
      await localDataSource.setCurrentFileId(file.id);
      final treeLvl = (await localDataSource.getFilesTreeLevel())!;
      await localDataSource.setFilesTreeLvl(treeLvl + 1);
      return Right(pdf);
    });
  }

  @override
  Future<Either<FilesNavigationFailure, List<SearchAppearance>>> search(String text)async{
    return await _manageFunctionExceptions(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final result = await remoteDataSource.search(text, accessToken);
      return Right(result);
    });
  }
  
  @override
  Future<Either<FilesNavigationFailure, File>> loadAppearancePdf(SearchAppearance appearance)async{
    return await _manageFunctionExceptions(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final pdf = await remoteDataSource.getGeneratedPdf(appearance.pdfUrl, accessToken);
      return Right(pdf);
    });
  }
  
  @override
  Future<Either<FilesNavigationFailure, List<Map<String, dynamic>>>> generateIcr(List<int> ids)async{
    return await _manageFunctionExceptions(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final icr = await remoteDataSource.generateIcr(ids, accessToken);
      return Right(icr);
    });
  }
}