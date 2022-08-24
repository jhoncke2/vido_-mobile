import 'package:vido/core/external/shared_preferences_manager.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_local_data_source.dart';

class FilesNavigatorLocalDataSourceImpl implements FilesNavigatorLocalDataSource{
  static const currentParentFolderIdKey = 'current_parent_folder_id';
  static const filesTreeLvlKey = 'files_tree_lvl';

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
  Future<int> getFilesTreeLevel()async{
    final stringLvl = await sharedPreferencesManager.getString(filesTreeLvlKey);
    return int.parse(stringLvl);
  }
  
  @override
  Future<void> setFilesTreeLvl(int lvl)async{
    await sharedPreferencesManager.setString(filesTreeLvlKey, '$lvl');
  }

}