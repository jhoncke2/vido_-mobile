import '../../../core/domain/entities/app_file.dart';

abstract class AppFilesReceiver{
  Future<void> setAppFiles(List<AppFile> files);
}