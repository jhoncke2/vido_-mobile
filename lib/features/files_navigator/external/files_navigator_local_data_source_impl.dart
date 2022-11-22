import 'package:vido/core/domain/entities/app_file.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/external/shared_preferences_manager.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_local_data_source.dart';
import 'package:vido/features/files_navigator/domain/entities/files_acommodation.dart';

class FilesNavigatorLocalDataSourceImpl implements FilesNavigatorLocalDataSource{
  static const currentParentFolderIdKey = 'current_parent_folder_id';
  static const filesTreeLvlKey = 'files_tree_lvl';
  static const parentIdKey = 'parent_id';
  static const filesAcommodationKey = 'files_acommodation';
  static const filesAcommodationCellsValue = 'cells';
  static const filesAcommodationVerticalListValue = 'vertical_list';

  final SharedPreferencesManager sharedPreferencesManager;
  const FilesNavigatorLocalDataSourceImpl({
    required this.sharedPreferencesManager
  });
  @override
  Future<int> getCurrentFileId()async{
    final stringId = await sharedPreferencesManager.getString(currentParentFolderIdKey);
    return int.parse(stringId);
  }

  @override
  Future<void> setCurrentFileId(int id)async{
    await sharedPreferencesManager.setString(currentParentFolderIdKey, '$id');
  }

  @override
  Future<int?> getFilesTreeLevel()async{
    try{
      final stringLvl = await sharedPreferencesManager.getString(filesTreeLvlKey);
      return int.parse(stringLvl);
    }on StorageException catch(exception){
      if(exception.type == StorageExceptionType.EMPTYDATA){
        return null;
      }else{
        rethrow;
      }
    }on Exception{
      rethrow;
    }
  }
  
  @override
  Future<void> setFilesTreeLvl(int lvl)async{
    await sharedPreferencesManager.setString(filesTreeLvlKey, '$lvl');
  }
  
  @override
  Future<int> getParentId()async{
    final stringParentId = await sharedPreferencesManager.getString(parentIdKey);
    return int.parse(stringParentId);
  }
  
  @override
  Future<void> setParentId(int id)async{
    await sharedPreferencesManager.setString(parentIdKey, '$id');
  }

  @override
  Future<void> setFilesAcommodation(FilesAcommodation acommodation)async{
    final preferencesValue = (acommodation == FilesAcommodation.cells)? 'cells'
        : 'vertical_list';
    await sharedPreferencesManager.setString(filesAcommodationKey, preferencesValue);
  }
  
  @override
  Future<FilesAcommodation> getFilesAcommodation()async{
    try{
      final preferencesValue = await sharedPreferencesManager.getString(filesAcommodationKey);
      return (preferencesValue == filesAcommodationCellsValue)? FilesAcommodation.cells
              : FilesAcommodation.verticalList;
    }on StorageException catch(exception){
      if(exception.type == StorageExceptionType.EMPTYDATA){
        return FilesAcommodation.cells;
      }else{
        rethrow;
      }
    }
  }

  @override
  Future<void> setCurrentFile(AppFile file)async{
    // TODO: implement setCurrentFile
    throw UnimplementedError();
  }
}