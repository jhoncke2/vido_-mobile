import 'package:vido/core/external/translations_file_parent_folder_getter.dart';

abstract class FilesNavigatorLocalDataSource implements TranslationsFileParentFolderGetter{
  Future<void> setCurrentFileId(int id);
  Future<void> setFilesTreeLvl(int lvl);
  Future<void> setParentId(int id);
}