import '../../photos_translator/domain/entities/app_file.dart';

abstract class AppFilesReceiver{
  Future<void> setAppFiles(List<AppFile> files);
}