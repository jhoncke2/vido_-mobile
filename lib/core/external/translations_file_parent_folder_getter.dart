abstract class TranslationsFileParentFolderGetter{
  Future<int> getCurrentFileId();
  Future<int?> getFilesTreeLevel();
  Future<int> getParentId();
}