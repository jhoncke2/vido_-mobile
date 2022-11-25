import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/entities/app_file.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/external/user_extra_info_getter.dart';
import 'package:vido/features/files_navigator/data/app_files_receiver.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_local_data_source.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_remote_data_source.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/domain/repository/files_navigator_repository.dart';
import 'package:vido/core/domain/entities/pdf_file.dart';
import '../../../../core/domain/file_parent_type.dart';
import '../../../../core/domain/entities/folder.dart';
import '../../domain/failures/files_navigator_failure.dart';

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
  Future<Either<FilesNavigatorFailure, void>> loadFolderChildren(int? id)async{
    return await _manageFunctionExceptions(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      late Folder folder;
      final treeLvl = await localDataSource.getFilesTreeLevel();
      if(id == null){
        if(treeLvl == null || treeLvl == 0){
          folder = await _saveUserRootFolder(accessToken);
        }else{
          folder = await _saveNullIdFolder(accessToken, treeLvl);
        }
        if(treeLvl == null){
          await localDataSource.setFilesTreeLvl(0);
        }
      }else{
        folder = await _saveFolderWithIdAndTreeLvl(id, accessToken, treeLvl!);
      }
      await appFilesReceiver.setAppFiles(folder.children);
      return const Right(null);
    });
  }

  Future<Folder> _saveUserRootFolder(String accessToken)async{
    final userId = await userExtraInfoGetter.getId();
    final folder = await remoteDataSource.getFolder(userId, FileParentType.user, accessToken);
    await localDataSource.setCurrentFileId(folder.id);
    await localDataSource.setCurrentFile(folder);
    return folder;
  }

  Future<Folder> _saveNullIdFolder(String accessToken, int treeLvl)async{
    final currentFile = await localDataSource.getCurrentFile();
    late Folder folder;
    if(currentFile is Folder){
      folder = await remoteDataSource.getFolder(currentFile.id, FileParentType.folder, accessToken);
    }else{
      final folderId = await localDataSource.getParentId();
      folder = await remoteDataSource.getFolder(folderId, FileParentType.folder, accessToken);
      await localDataSource.setCurrentFile(folder);
      await localDataSource.setCurrentFileId(folder.id);
      await localDataSource.setFilesTreeLvl(treeLvl - 1);
    }
    await localDataSource.setParentId(folder.parentId!);
    return folder;
  }

  Future<Folder> _saveFolderWithIdAndTreeLvl(int id, String accessToken, int treeLvl)async{
    final folder = await remoteDataSource.getFolder(id, FileParentType.folder, accessToken);
    await localDataSource.setCurrentFileId(id);
    await localDataSource.setFilesTreeLvl(treeLvl + 1);
    await localDataSource.setParentId(folder.parentId!);
    await localDataSource.setCurrentFile(folder);
    return folder;
  }

  
  Future<Either<FilesNavigatorFailure, T>> _manageFunctionExceptions<T>(
    Future<Either<FilesNavigatorFailure, T>> Function() function
  )async{
    try{
      return await function();
    }on AppException catch(exception){
      return Left(FilesNavigatorFailure(
        message: exception.message??'',
        exception: exception
      ));
    }catch(exception, stackTrace){
      print(stackTrace);
      return const Left(FilesNavigatorFailure(
        message: '',
        exception: AppException('')
      ));
    }
  }

  @override
  Future<Either<FilesNavigatorFailure, void>> loadFolderBrothers()async{
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
        await localDataSource.setCurrentFile(folder);
        if(filesTreeLevelUpdated > 0){
          await localDataSource.setParentId(folder.parentId!);
        }
      }
      return const Right(null);
    });
  }

  @override
  Future<Either<FilesNavigatorFailure, File>> loadFilePdf(PdfFile file)async{
    return await _manageFunctionExceptions(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final pdf = await remoteDataSource.getGeneratedPdf(file.url, accessToken);
      final newParentId = await localDataSource.getCurrentFileId();
      await localDataSource.setParentId(newParentId);
      await localDataSource.setCurrentFileId(file.id);
      await localDataSource.setCurrentFile(file);
      final treeLvl = (await localDataSource.getFilesTreeLevel())!;
      await localDataSource.setFilesTreeLvl(treeLvl + 1);
      return Right(pdf);
    });
  }

  @override
  Future<Either<FilesNavigatorFailure, List<SearchAppearance>>> search(String text)async{
    return await _manageFunctionExceptions(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final result = await remoteDataSource.search(text, accessToken);
      return Right(result);
    });
  }
  
  @override
  Future<Either<FilesNavigatorFailure, File>> loadAppearancePdf(SearchAppearance appearance)async{
    return await _manageFunctionExceptions(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final pdf = await remoteDataSource.getGeneratedPdf(appearance.pdfUrl, accessToken);
      return Right(pdf);
    });
  }
  
  @override
  Future<Either<FilesNavigatorFailure, List<Map<String, dynamic>>>> generateIcr(List<int> ids)async{
    return await _manageFunctionExceptions(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final icr = await remoteDataSource.generateIcr(ids, accessToken);
      return Right(icr);
    });
  }

  @override
  Future<Either<FilesNavigatorFailure, AppFile>> getCurrentFile()async{
    return await _manageFunctionExceptions(()async{
      final file = await localDataSource.getCurrentFile();
      return Right(file);
    });
  }
}