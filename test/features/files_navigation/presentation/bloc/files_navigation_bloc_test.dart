import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/features/files_navigation/presentation/bloc/files_navigation_bloc.dart';
import 'package:vido/features/files_navigation/presentation/use_cases/load_folder_children.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/generate_pdf.dart';

import '../../../photos_translator/presentation/bloc/photos_translator_bloc_test.mocks.dart';

late FilesNavigatorBloc filesNavigatorBloc;
late MockGeneratePdf generatePdf;
late StreamController<List<TranslationsFile>> tUncompletedTranslFilesController;
late StreamController<List<AppFile>> tFolderChildrenController;

@GenerateMocks([
  LoadFolderChildren,
  GeneratePdf,
  File
])
void main() {
  setUp(() {
    generatePdf = MockGeneratePdf();
    tUncompletedTranslFilesController = StreamController<List<TranslationsFile>>();
  });

  tearDown((){
    tUncompletedTranslFilesController.close();
  });

  group('stream listening', _testStreamListeningGroup);
  group('select pdf file', _testSelectPdfFileGroup);
}

void _testStreamListeningGroup() {
  late List<TranslationsFile> tFirstYieldedFiles;
  setUp(() {
    tFirstYieldedFiles = const [
      TranslationsFile(
        id: 0, name: 't_f_1', completed: false, translations: []
      ),
      TranslationsFile(
        id: 1,
        name: 't_f_2',
        completed: true,
        translations: [Translation(id: 100, imgUrl: 'url_1', text: null)]
      )
    ];
  });
  test('should emit the expected ordered states when current state is OnUncompleted', ()async{
    expectLater(filesNavigatorBloc.translationsFilesStream, emitsInOrder([tFirstYieldedFiles]));
    tUncompletedTranslFilesController.sink.add(tFirstYieldedFiles);
  });
}


void _testSelectPdfFileGroup(){
  late PdfFile tFile;
  late MockFile tPdf;
  setUp((){
    tFile = const PdfFile(id: 1001, name: 'pdf_file_1', url: 'pdf_file_url_1');
    tPdf = MockFile();
    when(generatePdf(any)).thenAnswer((_) async => Right(tPdf));
    when(tPdf.path).thenReturn('pdf_1');
  });

  test('should call the specified methods', ()async{
    filesNavigatorBloc.add(SelectPdfFileEvent(tFile));
    await untilCalled(generatePdf(any));
    verify(generatePdf(tFile));
  });

  test('should yield the expected ordered states', ()async{
    final expectedOrderedStates = [
      OnLoadingFiles(),
      OnPdfFileLoaded(file: tFile, pdf: tPdf)
    ];
    expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
    filesNavigatorBloc.add(SelectPdfFileEvent(tFile));
  });
}
