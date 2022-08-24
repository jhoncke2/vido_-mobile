import 'dart:async';
import 'package:vido/features/files_navigator/presentation/files_transmitter/files_transmitter.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';

class AppFilesTransmitterImpl implements AppFilesTransmitter{
  final StreamController<List<AppFile>> streamController;
  Stream<List<AppFile>>? _stream;
  AppFilesTransmitterImpl({
    required this.streamController
  });

  @override
  Future<void> setAppFiles(List<AppFile> files)async{
    streamController.sink.add(files);
  }
  
  @override
  Stream<List<AppFile>> get appFiles{
    _stream ??= streamController.stream.asBroadcastStream();
    return _stream!;
  }

}