import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/external/shared_preferences_manager.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_local_data_source.dart';

class FilesNavigatorLocalDataSourceImpl implements FilesNavigatorLocalDataSource{
  static const currentParentFolderIdKey = 'current_parent_folder_id';
  static const filesTreeLvlKey = 'files_tree_lvl';
  static const parentIdKey = 'parent_id';

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
}