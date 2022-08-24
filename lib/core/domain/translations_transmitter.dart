import 'dart:async';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/translations_files_receiver.dart';

abstract class TranslationsFilesTransmitter implements TranslationsFilesReceiver{
   Stream<List<TranslationsFile>> get translationsFiles;
}

class TranslationsFilesTransmitterImpl implements TranslationsFilesTransmitter{
  final StreamController<List<TranslationsFile>> translationsFilesController;
  Stream<List<TranslationsFile>>? _stream;
  TranslationsFilesTransmitterImpl({
    required this.translationsFilesController
  });
  @override
  Stream<List<TranslationsFile>> get translationsFiles{
    _stream ??= translationsFilesController.stream.asBroadcastStream();
    return _stream!;
  }

  @override
  Future<void> setTranslationsFiles(List<TranslationsFile> files)async{
    translationsFilesController.sink.add(files);
  }

}