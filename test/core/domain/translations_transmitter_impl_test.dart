import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:vido/core/domain/translations_transmitter.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';

late TranslationsFilesTransmitterImpl translFilesTransmitter;
late StreamController<List<TranslationsFile>> translationsFilesController;

void main(){
  setUp((){
    translationsFilesController = StreamController();
    translFilesTransmitter = TranslationsFilesTransmitterImpl(translationsFilesController: translationsFilesController);
  });

  group('set translations files', (){
    late List<TranslationsFile> tTranslationsFiles;
    setUp((){
      tTranslationsFiles = const [
        TranslationsFile(id: 0, name: 'f_1', completed: false, translations: []),
        TranslationsFile(id: 1, name: 'f_2', completed: true, translations: [])
      ];
    });

    test('should emit the expected ordered items on the stream controller', ()async{
      final expectedOrderedItems = [
        tTranslationsFiles
      ];
      expectLater(translationsFilesController.stream, emitsInOrder(expectedOrderedItems));
      await translFilesTransmitter.setTranslationsFiles(tTranslationsFiles);
    });
  });
}