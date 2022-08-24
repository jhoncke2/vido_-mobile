import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/domain/translations_transmitter.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';
import 'package:vido/features/files_navigator/presentation/bloc/files_navigator_bloc.dart';
import 'package:vido/features/files_navigator/presentation/files_transmitter/files_transmitter.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_folder_brothers.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_folder_children.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/search.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import 'package:vido/features/photos_translator/domain/entities/folder.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_pdf.dart';
import 'files_navigator_bloc_test.mocks.dart';

late FilesNavigatorBloc filesNavigatorBloc;
late MockLoadFolderChildren loadFolderChildren;
late MockLoadFolderBrothers loadFolderBrothers;
late MockLoadPdf loadPdf;
late MockSearch search;
late MockAppFilesTransmitter appFilesTransmitter;
late MockTranslationsFilesTransmitter translationsFilesTransmitter;
 

@GenerateMocks([
  LoadFolderChildren,
  LoadFolderBrothers,
  LoadPdf,
  Search,
  AppFilesTransmitter,
  TranslationsFilesTransmitter,
  File
])
void main() {
  setUp(() {
    translationsFilesTransmitter = MockTranslationsFilesTransmitter();
    appFilesTransmitter = MockAppFilesTransmitter();
    search = MockSearch();
    loadPdf = MockLoadPdf();
    loadFolderBrothers = MockLoadFolderBrothers();
    loadFolderChildren = MockLoadFolderChildren();
    when(appFilesTransmitter.appFiles).thenAnswer(
      (_) => StreamController<List<AppFile>>().stream
    );
    filesNavigatorBloc = FilesNavigatorBloc(
      loadFolderChildren: loadFolderChildren,
      loadFolderBrothers: loadFolderBrothers,
      loadPdf: loadPdf,
      search: search,
      appFilesTransmitter: appFilesTransmitter,
      translationsFilesTransmitter: translationsFilesTransmitter    
    );
  });

  group('load initial app files', _testLoadInitialAppFilesGroup);
  group('select app file', _testLoadFolderChildrenGroup);
  group('select files parent', _testSelectFilesParentGroup);
}

void _testLoadInitialAppFilesGroup(){
  test('should call the specified methods', ()async{
    when(loadFolderChildren(any)).thenAnswer((_) async => const Right(null));
    filesNavigatorBloc.add(LoadInitialAppFilesEvent());
    await untilCalled(loadFolderChildren(any));
    verify(loadFolderChildren(null));
  });

  test('should emit the expected ordered states when all goes good', ()async{
    when(loadFolderChildren(any)).thenAnswer((_) async => const Right(null));
    final expectedOrderedStates = [
      OnLoadingAppFiles(),
      OnAppFiles()
    ];
    expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
    filesNavigatorBloc.add(LoadInitialAppFilesEvent());
  });
}

void _testLoadFolderChildrenGroup(){
  late AppFile tAppFile;

  group('when the AppFile is PdfFile', (){
    late MockFile tPdf;
    setUp((){
      tPdf = MockFile();
      when(tPdf.path).thenReturn('pdf_url_1');
      tAppFile = const PdfFile(id: 0, name: 'file_1', url: 'pdf_url_1', parentId: 100);
    });

    test('should call the specified methods', ()async{
      when(loadPdf(any)).thenAnswer((_) async => Right(tPdf));
      filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
      await untilCalled(loadPdf(any));
      verify(loadPdf(tAppFile as PdfFile));
    });

    test('should emit the expected ordered states when all goes good', ()async{
      when(loadPdf(any)).thenAnswer((_) async => Right(tPdf));
      final expectedOrderedStates = [
        OnLoadingAppFiles(),
        OnPdfFileLoaded(file: tAppFile as PdfFile, pdf: tPdf)
      ];
      expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
      filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
    });

    test('should emit the expected ordered states when there is a Failure response', ()async{
      when(loadPdf(any))
          .thenAnswer((_) async => const Left(FilesNavigationFailure(
            exception: ServerException(type: ServerExceptionType.NORMAL, message: 'exception message'), 
            message: 'exception message')
          ));
      final expectedOrderedStates = [
        OnLoadingAppFiles(),
        OnPdfFileError(message: 'exception message', file: tAppFile as PdfFile)
      ];
      expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
      filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
    });
    
  });

  group('when the AppFile is Folder', (){
    setUp((){
      tAppFile = const Folder(id: 0, name: 'file_1', parentId: 100, children: []);
      when(loadFolderChildren(any)).thenAnswer((_) async => const Right(null));
    });

    test('should call the specified methods', ()async{
      filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
      await (untilCalled(loadFolderChildren(any)));
      verify(loadFolderChildren(tAppFile.id));
    });

    test('should emit the expected ordered states', ()async{
      final expectedOrderedStates = [
        OnLoadingAppFiles(),
        OnAppFiles()
      ];
      expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
      filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
    });
  });
}

void _testSelectFilesParentGroup(){
  test('should call the specified methods', ()async{
    when(loadFolderBrothers())
        .thenAnswer((_) async => const Right(null));
    filesNavigatorBloc.add(SelectFilesParentEvent());
    await untilCalled(loadFolderBrothers());
    verify(loadFolderBrothers());
  });

  test('should call the expected ordered states when all goes good', ()async{
    when(loadFolderBrothers())
        .thenAnswer((_) async => const Right(null));
    final expectedOrderedStates = [
      OnLoadingAppFiles(),
      OnAppFiles()
    ];
    expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
    filesNavigatorBloc.add(SelectFilesParentEvent());
  });
}