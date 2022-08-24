import 'package:vido/features/files_navigator/data/app_files_receiver.dart';

import '../../../photos_translator/domain/entities/app_file.dart';

abstract class AppFilesTransmitter implements AppFilesReceiver{
  Stream<List<AppFile>> get appFiles;
}