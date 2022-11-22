import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/domain/translations_transmitter.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';
import 'package:vido/features/files_navigator/presentation/bloc/files_navigator_bloc.dart';
import 'package:vido/features/files_navigator/presentation/files_transmitter/files_transmitter.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/generate_icr.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_appearance_pdf.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_folder_brothers.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_folder_children.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/search.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import 'package:vido/features/photos_translator/domain/entities/folder.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_file_pdf.dart';
import 'files_navigator_bloc_test.mocks.dart';

late FilesNavigatorBloc filesNavigatorBloc;
late MockLoadFolderChildren loadFolderChildren;
late MockLoadFolderBrothers loadFolderBrothers;
late MockLoadFilePdf loadFilePdf;
late MockLoadAppearancePdf loadAppearancePdf;
late MockSearch search;
late MockGenerateIcr generateIcr;
late MockAppFilesTransmitter appFilesTransmitter;
late MockTranslationsFilesTransmitter translationsFilesTransmitter;
late MockTextEditingController searchController;

@GenerateMocks([
  LoadFolderChildren,
  LoadFolderBrothers,
  LoadFilePdf,
  LoadAppearancePdf,
  Search,
  GenerateIcr,
  AppFilesTransmitter,
  TranslationsFilesTransmitter,
  TextEditingController,
  File
])
void main() {
  setUp(() {
    searchController = MockTextEditingController();
    translationsFilesTransmitter = MockTranslationsFilesTransmitter();
    appFilesTransmitter = MockAppFilesTransmitter();
    generateIcr = MockGenerateIcr();
    search = MockSearch();
    loadAppearancePdf = MockLoadAppearancePdf();
    loadFilePdf = MockLoadFilePdf();
    loadFolderBrothers = MockLoadFolderBrothers();
    loadFolderChildren = MockLoadFolderChildren();
    when(appFilesTransmitter.appFiles).thenAnswer(
      (_) => StreamController<List<AppFile>>().stream
    );
    filesNavigatorBloc = FilesNavigatorBloc(
      loadFolderChildren: loadFolderChildren,
      loadFolderBrothers: loadFolderBrothers,
      loadFilePdf: loadFilePdf,
      loadAppearancePdf: loadAppearancePdf,
      search: search,
      generateIcr: generateIcr,
      appFilesTransmitter: appFilesTransmitter,
      translationsFilesTransmitter: translationsFilesTransmitter,
      searchController: searchController 
    );
  });

  group('load initial app files', _testLoadInitialAppFilesGroup);
  group('select app file', _testSelectAppFileGroup);
  group('select files parent', _testSelectFilesParentGroup);
  group('search', _testSearchGroup);
  group('remove search', _testRemoveSearchGroup);
  group('select search appearance', _testSelectSearchAppearanceGroup);
  group('back to search appearances', _testBackToSearchAppearancesGroup);
  group('init icr files selection', _testInitIcrFilesSelectionGroup);
  group('generate icr', _testGenerateIcrGroup);
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
      OnAppFilesSuccess()
    ];
    expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
    filesNavigatorBloc.add(LoadInitialAppFilesEvent());
  });
}

void _testSelectAppFileGroup(){
  late AppFile tAppFile;

  group('when the current state is OnAppFiles', (){
    setUp((){
      filesNavigatorBloc.emit(OnAppFilesSuccess());
    });
    group('when the AppFile is PdfFile', (){
      late MockFile tPdf;
      setUp((){
        tPdf = MockFile();
        when(tPdf.path).thenReturn('pdf_url_1');
        tAppFile = const PdfFile(
          id: 0, 
          name: 'file_1', 
          url: 'pdf_url_1', 
          parentId: 100,
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false
        );
      });

      test('should call the specified methods', ()async{
        when(loadFilePdf(any)).thenAnswer((_) async => Right(tPdf));
        filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
        await untilCalled(loadFilePdf(any));
        verify(loadFilePdf(tAppFile as PdfFile));
      });

      test('should emit the expected ordered states when all goes good', ()async{
        when(loadFilePdf(any)).thenAnswer((_) async => Right(tPdf));
        final expectedOrderedStates = [
          OnLoadingAppFiles(),
          OnPdfFileLoaded(file: tAppFile as PdfFile, pdf: tPdf)
        ];
        expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
        filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
      });

      test('should emit the expected ordered states when there is a Failure response', ()async{
        when(loadFilePdf(any))
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
        tAppFile = const Folder(
          id: 0, 
          name: 'file_1', 
          parentId: 100, 
          children: [],
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false,
          canCreateOnIt: true
        );
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
          OnAppFilesSuccess()
        ];
        expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
        filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
      });
    });
  });
  group('when the current state is OnIcrFilesSelection', (){
    late List<int> tFilesIdsInit;

    group('when the files ids list has more than 1 item', (){
      setUp((){
        tFilesIdsInit = [0, 1, 2];
        filesNavigatorBloc.emit(OnIcrFilesSelection(filesIds: tFilesIdsInit));
      });

      test('should yield the expected ordered states when the selected file is PdfFile with id Not on the tFilesIds', ()async{
        tAppFile = const PdfFile(
          id: 3, 
          name: 'file_3', 
          parentId: 1000, 
          url: 'url_3',
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false
        );
        final expectedOrderedStates = [
          OnIcrFilesSelection(filesIds: [...tFilesIdsInit, tAppFile.id])
        ];
        expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
        filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
      });

      test('should yield the expected ordered states when the selected file is PdfFile with id indeed the first tFilesIds id', ()async{
        tAppFile = PdfFile(
          id: tFilesIdsInit.first, 
          name: 'file_3', 
          parentId: 1000, 
          url: 'url_3',
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false
        );
        final expectedOrderedStates = [
          OnIcrFilesSelection(filesIds: tFilesIdsInit.sublist(1, tFilesIdsInit.length))
        ];
        expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
        filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
      });

      test('should yield the expected ordered states when the selected file is PdfFile with id indeed the second tFilesIds id', ()async{
        tAppFile = PdfFile(
          id: tFilesIdsInit[1], 
          name: 'file_3', 
          parentId: 1000, 
          url: 'url_3',
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false
        );
        final expectedOrderedStates = [
          OnIcrFilesSelection(filesIds: [tFilesIdsInit[0], ...tFilesIdsInit.sublist(2, tFilesIdsInit.length)])
        ];
        expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
        filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
      });

      test('should yield the expected ordered states when the selected file is Folder', ()async{
        tAppFile = const Folder(
          id: 100, 
          name: 'folder_1', 
          parentId: 230, 
          children: [],
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false,
          canCreateOnIt: true
        );
        expectLater(filesNavigatorBloc.stream, emitsInOrder(const []));
        filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
      });
    });
    group('when the files ids list has only 1 item', (){
      setUp((){
        tFilesIdsInit = [100];
        filesNavigatorBloc.emit(OnIcrFilesSelection(filesIds: tFilesIdsInit));
      });
      test('should yield the expected ordered states when the selected file is PdfFile and its id is the id on the list', ()async{
        tAppFile = PdfFile(
          id: tFilesIdsInit.first, 
          name: 'file_first', 
          parentId: 1000, 
          url: 'url_first',
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false,
        );
        final expectedOrderedStates = [
          OnAppFilesSuccess()
        ];
        expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
        filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
      });

      test('should yield the expected ordered states when the selected file is PdfFile and its id is Not the id on the list', ()async{
        tAppFile = const PdfFile(
          id: 23, 
          name: 'file_23', 
          parentId: 1000, 
          url: 'url_23',
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false
        );
        final expectedOrderedStates = [
          OnIcrFilesSelection(filesIds: [...tFilesIdsInit, tAppFile.id])
        ];
        expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
        filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
      });

      test('should yield the expected ordered states when the selected file is Folder', ()async{
        tAppFile = const Folder(
          id: 100, 
          name: 'folder_1', 
          parentId: 230, 
          children: [],
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false,
          canCreateOnIt: true
        );
        expectLater(filesNavigatorBloc.stream, emitsInOrder(const []));
        filesNavigatorBloc.add(SelectAppFileEvent(tAppFile));
      });
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
      OnAppFilesSuccess()
    ];
    expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
    filesNavigatorBloc.add(SelectFilesParentEvent());
  });
}

void _testSearchGroup(){
  late String tSearchText;

  group('when search controller has any text', (){
    setUp((){
      tSearchText = 'the search';
      when(searchController.text).thenReturn(tSearchText);
    });

    group('when all goes good', (){
      late List<SearchAppearance> tAppearances;
      setUp((){
        tAppearances = const [
          SearchAppearance(title: 'ap_1', text: 'the search text', pdfUrl: 'pdf_url_1', pdfPage: 0),
          SearchAppearance(title: 'ap_2', text: 'text the search', pdfUrl: 'pdf_url_2', pdfPage: 3)
        ];
        when(search(any))
            .thenAnswer((_) async => Right(tAppearances));
      });

      test('should call the specified methods', ()async{
        filesNavigatorBloc.add(SearchEvent());
        await untilCalled(search(any));
        verify(search(tSearchText));
      });

      test('should emit the expected ordered states when search', ()async{
        final expectedOrderedStates = [
          OnLoadingAppFiles(),
          OnSearchAppearancesSuccessShowing(appearances: tAppearances)
        ];
        expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
        filesNavigatorBloc.add(SearchEvent());
      });
    });

    group('when search returns Left(Failure)', (){
      late String tFailureMessage;

      test('should call the specified methods', ()async{
        tFailureMessage = 'failure message';
        when(search(any))
            .thenAnswer((_) async => Left(FilesNavigationFailure(
              message: tFailureMessage,
              exception: const AppException('')
            )));
        filesNavigatorBloc.add(SearchEvent());
        await untilCalled(search(any));
        verify(search(tSearchText));
      });

      test('should emit the expected ordered states when failure has message', ()async{
        tFailureMessage = 'failure message';
        when(search(any))
            .thenAnswer((_) async => Left(FilesNavigationFailure(
              message: tFailureMessage,
              exception: const AppException('')
            )));
        final expectedOrderedStates = [
          OnLoadingAppFiles(),
          OnSearchAppearancesError(message: tFailureMessage)
        ];
        expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
        filesNavigatorBloc.add(SearchEvent());
      });
      
      test('should emit the expected ordered states when failure has Not message', ()async{
        tFailureMessage = '';
        when(search(any))
            .thenAnswer((_) async => Left(FilesNavigationFailure(
              message: tFailureMessage,
              exception: const AppException('')
            )));
        final expectedOrderedStates = [
          OnLoadingAppFiles(),
          OnSearchAppearancesError(message: FilesNavigatorBloc.generalErrorMessage)
        ];
        expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
        filesNavigatorBloc.add(SearchEvent());
      });
    });
  });

  group('when search has empty text', (){
    setUp((){
      tSearchText = '';
      when(searchController.text).thenReturn(tSearchText);
    });

    test('should call the specified methods when search controller have text', ()async{
      filesNavigatorBloc.add(SearchEvent());
      verifyNever(search(any));
    });

    test('should emit the expected ordered states when search', ()async{
      final expectedOrderedStates = [];
      expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
      filesNavigatorBloc.add(SearchEvent());
    });
  });
}

void _testRemoveSearchGroup(){
  group('when the current state is success', (){
    late List<SearchAppearance> tAppearances;
    setUp((){
      tAppearances = const [
        SearchAppearance(title: 'ap_1', text: 'the search text', pdfUrl: 'pdf_url_1', pdfPage: 0),
        SearchAppearance(title: 'ap_2', text: 'text the search', pdfUrl: 'pdf_url_2', pdfPage: 3)
      ];
      filesNavigatorBloc.emit(OnSearchAppearancesSuccessShowing(appearances: tAppearances));
    });

    test('should call the specified methods', ()async{
      filesNavigatorBloc.add(RemoveSearchEvent());
      await untilCalled(searchController.clear());
      verify(searchController.clear());
    });

    test('should emit the expected ordered states', ()async{
      final expectedOrderedStates = [
        OnAppFilesSuccess()
      ];
      expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
      filesNavigatorBloc.add(RemoveSearchEvent());
    });
  });
  group('when the current state is error', (){
    late String tMessage;
    setUp((){
      tMessage = 'error message';
      filesNavigatorBloc.emit(OnSearchAppearancesError(message: tMessage));
    });

    test('should call the specified methods', ()async{
      filesNavigatorBloc.add(RemoveSearchEvent());
      await untilCalled(searchController.clear());
      verify(searchController.clear());      
    });

    test('should emit the expected ordered states', ()async{
      final expectedOrderedStates = [
        OnAppFilesSuccess()
      ];
      expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
      filesNavigatorBloc.add(RemoveSearchEvent());
    });
  });
}

void _testSelectSearchAppearanceGroup(){
  late SearchAppearance tSelected;
  late List<SearchAppearance> tAppearances;
  
  setUp((){
    tSelected = const SearchAppearance(
      title: 'ap_2',
      text: 'appearance_text',
      pdfUrl: 'url_2',
      pdfPage: 10
    );
    tAppearances = [
      const SearchAppearance(
        title: 'ap_1',
        text: 'appearance_text_1',
        pdfUrl: 'url_1',
        pdfPage: 0
      ),
      tSelected,
      const SearchAppearance(
        title: 'ap_3',
        text: 'appearance_text_3',
        pdfUrl: 'url_3',
        pdfPage: 2
      )
    ];
    filesNavigatorBloc.emit(OnSearchAppearancesSuccessShowing(appearances: tAppearances));
  });

  group('when all goes good', (){
    late MockFile tFile;
    setUp((){
      tFile = MockFile();
      when(loadAppearancePdf(any))
          .thenAnswer((_) async => Right(tFile));
    });

    test('should call the specified methods', ()async{
      filesNavigatorBloc.add(SelectSearchAppearanceEvent(tSelected));
      await untilCalled(loadAppearancePdf(any));
      verify(loadAppearancePdf(tSelected));
    });

    test('should emit the expected ordered states', ()async{
      final expectedOrderedStates = [
        OnLoadingAppFiles(),
        OnSearchAppearancesPdfLoaded(pdf: tFile, appearance: tSelected, appearances: tAppearances)
      ];
      expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
      filesNavigatorBloc.add(SelectSearchAppearanceEvent(tSelected));
    });
  });

  group('when loadAppearancePdf returns Left(Failure)', (){
    late String tFailureMessage;

    test('should emit the expected ordered states when failure has message', ()async{
      tFailureMessage = 'failure message';
      when(loadAppearancePdf(any))
          .thenAnswer((_) async => Left(FilesNavigationFailure(
            message: tFailureMessage,
            exception: const AppException('')
          )));
      final expectedOrderedStates = [
        OnLoadingAppFiles(),
        OnSearchAppearancesPdfError(
          message: tFailureMessage,
          appearances: tAppearances
        )
      ];
      expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
      filesNavigatorBloc.add(SelectSearchAppearanceEvent(tSelected));
    });
    
    test('should emit the expected ordered states when failure has Not message', ()async{
      tFailureMessage = '';
      when(loadAppearancePdf(any))
          .thenAnswer((_) async => Left(FilesNavigationFailure(
            message: tFailureMessage,
            exception: const AppException('')
          )));
      final expectedOrderedStates = [
        OnLoadingAppFiles(),
        OnSearchAppearancesPdfError(
          message: FilesNavigatorBloc.generalErrorMessage,
          appearances: tAppearances
        )
      ];
      expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
      filesNavigatorBloc.add(SelectSearchAppearanceEvent(tSelected));
    });
  });
}

void _testBackToSearchAppearancesGroup(){
  late List<SearchAppearance> tAppearances;
  setUp((){
    tAppearances = [
      const SearchAppearance(
        title: 'ap_1',
        text: 'appearance_text_1',
        pdfUrl: 'url_1',
        pdfPage: 0
      ),
      const SearchAppearance(
        title: 'ap_3',
        text: 'appearance_text_3',
        pdfUrl: 'url_3',
        pdfPage: 2
      )
    ];
  });
  test('should emit the expected ordered states when current state is success', ()async{
    final pdf = MockFile();
    when(pdf.path).thenReturn('path');
    filesNavigatorBloc.emit(OnSearchAppearancesPdfLoaded(
      pdf: pdf,
      appearance: tAppearances.first, 
      appearances: tAppearances
    ));
    final expectedOrderedStates = [
      OnSearchAppearancesSuccessShowing(
        appearances: tAppearances
      )
    ];
    expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
    filesNavigatorBloc.add(BackToSearchAppearancesEvent());
  });

  test('should emit the expected ordered states when current state is error', ()async{
    filesNavigatorBloc.emit(OnSearchAppearancesPdfError(
      message: 'error message', 
      appearances: tAppearances
    ));
    final expectedOrderedStates = [
      OnSearchAppearancesSuccessShowing(
        appearances: tAppearances
      )
    ];
    expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
    filesNavigatorBloc.add(BackToSearchAppearancesEvent());
  });
}

void _testInitIcrFilesSelectionGroup(){
  late AppFile tFile;
  group('when current state is OnAppFiles', (){
    setUp((){
      filesNavigatorBloc.emit(OnAppFilesSuccess());
    });

    test('should yield the expected ordered states when the file id is 0', ()async{
      tFile = const PdfFile(
        id: 0, 
        name: 'file', 
        parentId: 100, 
        url: 'f_url',
        canBeRead: true,
        canBeEdited: true,
        canBeDeleted: false
      );
      final expectedOrderedStates = [
        OnIcrFilesSelection(
          filesIds: [tFile.id]
        )
      ];
      expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
      filesNavigatorBloc.add(LongPressFileEvent(tFile));
    });

    test('should yield the expected ordered states when the file id is 1', ()async{
      tFile = const PdfFile(
        id: 1, 
        name: 'file', 
        parentId: 100, 
        url: 'f_url',
        canBeRead: true,
        canBeEdited: true,
        canBeDeleted: false
      );
      final expectedOrderedStates = [
        OnIcrFilesSelection(
          filesIds: [tFile.id]
        )
      ];
      expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
      filesNavigatorBloc.add( LongPressFileEvent(tFile));
    });
  });

  test('should yield the expected ordered states when tue current state is OnIcrFilesSelection', ()async{
    filesNavigatorBloc.emit(OnIcrFilesSelection(filesIds: [1,3]));
    expectLater(filesNavigatorBloc.stream, emitsInOrder(const []));
  });
}

void _testGenerateIcrGroup(){
  late List<int> tFilesIds;
  setUp((){
    tFilesIds = [0, 1, 5, 10];
    filesNavigatorBloc.emit(OnIcrFilesSelection(filesIds: tFilesIds));
  });

  group('when all goes good', (){
    late List<String> tColumnsHeads;
    late List<List<String>> tRows;
    late List<Map<String, dynamic>> tTable;
    setUp((){
      tColumnsHeads = ['id', 'name', 'age'];
      tRows = [
        ['0', 'name_1', '20'],
        ['1', 'name_2', '30'],
        ['10', 'name_11', '25']
      ];
      tTable = const [
        {
          'id': 0,
          'name': 'name_1',
          'age': 20
        },
        {
          'id': 1,
          'name': 'name_2',
          'age': 30
        },
        {
          'id': 10,
          'name': 'name_11',
          'age': 25
        }
      ];
      when(generateIcr(any)).thenAnswer((_) async => Right(tTable));
    });

    test('should call the specified methods', ()async{
      filesNavigatorBloc.add(GenerateIcrEvent());
      await untilCalled(generateIcr);
      verify(generateIcr(tFilesIds));
    });

    test('should yield the expected ordered states', ()async{
      final expectedOrderedStates = [
        OnLoadingAppFiles(),
        OnIcrTable(colsHeads: tColumnsHeads, rows: tRows)
      ];
      expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
      filesNavigatorBloc.add(GenerateIcrEvent());
    });
  });

  test('should yield the expected ordered states when usecase returns failure with message', ()async{
    when(generateIcr(any)).thenAnswer((_) async => const Left(FilesNavigationFailure(
        exception: ServerException(type: ServerExceptionType.NORMAL),
        message: 'Server error message'
    )));
    final expectedOrderedStates = [
      OnLoadingAppFiles(),
      OnIcrFilesSelectionError(filesIds: tFilesIds, message: 'Server error message')
    ];
    expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
    filesNavigatorBloc.add(GenerateIcrEvent());
  });

  test('should yield the expected ordered states when usecase returns failure with message', ()async{
    when(generateIcr(any)).thenAnswer((_) async => const Left(FilesNavigationFailure(
        exception: ServerException(type: ServerExceptionType.NORMAL),
        message: ''
    )));
    final expectedOrderedStates = [
      OnLoadingAppFiles(),
      OnIcrFilesSelectionError(filesIds: tFilesIds, message: FilesNavigatorBloc.generalErrorMessage)
    ];
    expectLater(filesNavigatorBloc.stream, emitsInOrder(expectedOrderedStates));
    filesNavigatorBloc.add(GenerateIcrEvent());
  });
}