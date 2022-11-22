import 'package:vido/core/domain/entities/app_file.dart';
import 'package:vido/core/external/translations_file_parent_folder_getter.dart';
import 'package:vido/features/files_navigator/domain/entities/files_acommodation.dart';

abstract class FilesNavigatorLocalDataSource implements TranslationsFileParentFolderGetter{
  Future<void> setCurrentFileId(int id);
  Future<void> setFilesTreeLvl(int lvl);
  Future<void> setParentId(int id);
  Future<void> setFilesAcommodation(FilesAcommodation acommodation);
  Future<FilesAcommodation> getFilesAcommodation();
  Future<void> setCurrentFile(AppFile file);
}