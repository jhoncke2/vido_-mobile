import 'entities/translations_file.dart';

abstract class TranslationsFilesReceiver{
  Future<void> setTranslationsFiles(List<TranslationsFile> files);
}