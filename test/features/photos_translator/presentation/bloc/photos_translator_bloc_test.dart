import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/create_translations_file.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/end_photos_translations_file.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/generate_pdf.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/get_completed_files.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/get_uncompleted_translations_files.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/translate_photo.dart';
import 'photos_translator_bloc_test.mocks.dart';

late PhotosTranslatorBloc photosTranslatorBloc;
late MockCreateTranslationsFile createTranslationsFile;
late MockTranslatePhoto translatePhoto;
late MockEndPhotosTranslationsFile endPhotosTranslation;
late MockGetUncompletedTranslationsFiles getUncompletedTranslationsFiles;
late MockGetCompletedTranslationsFiles getCompletedTranslationsFiles;
late MockGeneratePdf generatePdf;
late StreamController<List<TranslationsFile>> tUncompletedTranslFilesController;
late StreamController<List<TranslationsFile>> tInCompletingProcessFileController;
late StreamController<List<PdfFile>> tCompletedTranslFilesController;

late List<CameraDescription> tCameras;
late MockCameraController tCameraController;

@GenerateMocks([
  CreateTranslationsFile,
  TranslatePhoto,
  EndPhotosTranslationsFile,
  GetUncompletedTranslationsFiles,
  CameraController,
  GetCompletedFiles,
  GeneratePdf,
  File
])
void main() {
  setUp(() {
    generatePdf = MockGeneratePdf();
    tCompletedTranslFilesController = StreamController<List<PdfFile>>();
    tInCompletingProcessFileController = StreamController<List<TranslationsFile>>();
    tUncompletedTranslFilesController = StreamController<List<TranslationsFile>>();
    tCameraController = MockCameraController();
    tCameras = const [
      CameraDescription(
          name: 'c_1',
          lensDirection: CameraLensDirection.external,
          sensorOrientation: 0),
      CameraDescription(
          name: 'c_2',
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 1)
    ];
    getCompletedTranslationsFiles = MockGetCompletedTranslationsFiles();
    getUncompletedTranslationsFiles = MockGetUncompletedTranslationsFiles();
    endPhotosTranslation = MockEndPhotosTranslationsFile();
    translatePhoto = MockTranslatePhoto();
    createTranslationsFile = MockCreateTranslationsFile();
    photosTranslatorBloc = PhotosTranslatorBloc(
        createTranslationsFile: createTranslationsFile,
        translatePhoto: translatePhoto,
        endPhotosTranslation: endPhotosTranslation,
        getUncompletedTranslationsFiles: getUncompletedTranslationsFiles,
        getCompletedTranslationsFiles: getCompletedTranslationsFiles,
        generatePdf: generatePdf,
        uncompletedFilesStream: tUncompletedTranslFilesController.stream.asBroadcastStream(),
        inCompletingProcessFilesStream: tInCompletingProcessFileController.stream.asBroadcastStream(),
        completedFilesStream: tCompletedTranslFilesController.stream.asBroadcastStream(),
        cameras: tCameras,
        getNewCameraController: (CameraDescription camera) =>
            tCameraController);
  });

  tearDown((){
    tUncompletedTranslFilesController.close();
  });

  test('should have the expected initialized elements', ()async{
    expect(photosTranslatorBloc.cameraController, null);
  });
  group('stream listening', _testStreamListeningGroup);
  group('load uncompleted translations files', _testLoadTranslationsFilesGroup);
  group('init translations file creation', _testInitTranslationsFileCreationGroup);
  group('choose camera', _testChooseCameraGroup);
  group('change file name', _testChangeFileNameGroup);
  group('save file name', _testSaveFileNameGroup);
  group('add photo translation', _testAddPhotoTranslationGroup);
  group('end translations file creation', _testEndTranslationsFileCreationGroup);
  group('update completed translations files', _testUpdateCompletedTranslationsGroup);
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
    photosTranslatorBloc.emit(const OnTranslationsFilesLoaded(uncompletedFiles: [], completedFiles: []));
    expectLater(photosTranslatorBloc.uncompletedFilesStream, emitsInOrder([tFirstYieldedFiles]));
    //expectLater(photosTranslatorBloc.stream, emitsInOrder([
    //  OnTranslationsFilesLoaded(uncompletedFiles: tFirstYieldedFiles, completedFiles: [])
    //]));
    tUncompletedTranslFilesController.sink.add(tFirstYieldedFiles);
  });

  test('should emit the expected ordered states when current state is OnCreating', ()async{
    photosTranslatorBloc.emit(OnInitializingTranslations(
      id: 1021,
      name: 't_f_21', 
      canTranslate: false, 
      canEnd: false, 
      cameraController: tCameraController
    ));
    expectLater(photosTranslatorBloc.uncompletedFilesStream, emitsInOrder([tFirstYieldedFiles]));
    expectLater(photosTranslatorBloc.stream, emitsInOrder([]));
    tUncompletedTranslFilesController.sink.add(tFirstYieldedFiles);
  });
}

void _testLoadTranslationsFilesGroup() {
  late List<TranslationsFile> tUncompletedFiles;
  late List<PdfFile> tCompletedFiles;
  setUp(() {
    tUncompletedFiles = const [
      TranslationsFile(id: 0, name: 'file_1', completed: false, translations: [
        Translation(id: 100, imgUrl: 'url_1', text: null),
        Translation(id: 101, imgUrl: 'url_2', text: 'texto_2'),
      ]),
      TranslationsFile(id: 1, name: 'file_2', completed: false, translations: [
        Translation(id: 102, imgUrl: 'url_3', text: null),
        Translation(id: 103, imgUrl: 'url_4', text: 'texto_2'),
      ]),
    ];
    tCompletedFiles = const [
      PdfFile(id: 2, name: 'file_3', url: 'pdf_1'),
    ];
  });
  

  test('should call the specified methods when it is already listening the stream', () async {
    when(getUncompletedTranslationsFiles())
        .thenAnswer((_) async => Right(tUncompletedFiles));
    when(getCompletedTranslationsFiles())
        .thenAnswer((_) async => Right(tCompletedFiles));
    photosTranslatorBloc.add(LoadTranslationsFilesEvent());
    await untilCalled(getUncompletedTranslationsFiles());
    verify(getUncompletedTranslationsFiles());
    await untilCalled(getCompletedTranslationsFiles());
    verify(getCompletedTranslationsFiles());
  });

  test('should emit the expected ordered states when it is already listening the stream', () async {
    when(getUncompletedTranslationsFiles())
        .thenAnswer((_) async => Right(tUncompletedFiles));
    when(getCompletedTranslationsFiles())
        .thenAnswer((_) async => Right(tCompletedFiles));
    final expectedOrderedStates = [
      OnLoadingTranslations(),
      OnTranslationsFilesLoaded(uncompletedFiles: tUncompletedFiles, completedFiles: tCompletedFiles)
    ];
    expectLater(photosTranslatorBloc.stream, emitsInOrder(expectedOrderedStates));
    photosTranslatorBloc.add(LoadTranslationsFilesEvent());
  });
}

void _testInitTranslationsFileCreationGroup() {
  late int tFileId;
  setUp(() {
    tFileId = 1001;
    photosTranslatorBloc.emit(const OnTranslationsFilesLoaded(uncompletedFiles: [], completedFiles: []));
  });

  test('should emit the specified methods when camera controller is null', () async {
    photosTranslatorBloc.cameraController = null;
    final expectedOrderedStates = [
      OnLoadingTranslations(),
      OnSelectingCamera(),
    ];
    expectLater(
        photosTranslatorBloc.stream, emitsInOrder(expectedOrderedStates));
    photosTranslatorBloc.add(InitTranslationsFileEvent());
  });
  
  test('shold emit the specified methods qwhen camedra controller already exists', ()async{
    photosTranslatorBloc.cameraController = tCameraController;
    final expectedOrderedStates = [
      OnLoadingTranslations(),
      const OnNamingTranslationsFile(name: '', canEnd: false),
    ];
    expectLater(photosTranslatorBloc.stream, emitsInOrder(expectedOrderedStates));
    photosTranslatorBloc.add(InitTranslationsFileEvent());
  });
}

void _testChooseCameraGroup() {
  late int tFileId;
  setUp(() {
    tFileId = 1001;
    when(tCameraController.cameraId).thenReturn(0);
    when(tCameraController.enableAudio).thenReturn(false);
    when(tCameraController.imageFormatGroup).thenReturn(ImageFormatGroup.jpeg);
    when(tCameraController.resolutionPreset).thenReturn(ResolutionPreset.high);
  });

  test('should emit the expected ordered states when the selected camera is the first', () async {
    when(tCameraController.description).thenReturn(tCameras.first);
    photosTranslatorBloc.emit(OnSelectingCamera());
    final expectedOrderedStates = [
      const OnNamingTranslationsFile(name: '', canEnd: false)
    ];
    when(tCameraController.description).thenReturn(tCameras.first);
    expectLater(
        photosTranslatorBloc.stream, emitsInOrder(expectedOrderedStates));
    photosTranslatorBloc.add(ChooseCameraEvent(camera: tCameras.first));
  });

  test('should call the specified methods and initialize the specified variables when the selected camera is the first', ()async{
    when(tCameraController.description).thenReturn(tCameras.first);
    photosTranslatorBloc.emit(OnSelectingCamera());
    photosTranslatorBloc.add(ChooseCameraEvent(camera: tCameras.last));
    await untilCalled(tCameraController.initialize());
    verify(tCameraController.initialize());
    expect(photosTranslatorBloc.cameraController!.description.name, tCameraController.description.name);
    expect(photosTranslatorBloc.cameraController!.enableAudio, tCameraController.enableAudio);
    expect(photosTranslatorBloc.cameraController!.imageFormatGroup, tCameraController.imageFormatGroup);
    expect(photosTranslatorBloc.cameraController!.resolutionPreset.name, tCameraController.resolutionPreset.name);
  });

  test('should emit the expected ordered states when the selected camera is the last', () async {
    when(tCameraController.description).thenReturn(tCameras.last);
    photosTranslatorBloc.emit(OnSelectingCamera());
    final expectedOrderedStates = [
      const OnNamingTranslationsFile(name: '', canEnd: false)
    ];
    when(tCameraController.description).thenReturn(tCameras.last);
    expectLater(
        photosTranslatorBloc.stream, emitsInOrder(expectedOrderedStates));
    photosTranslatorBloc.add(ChooseCameraEvent(camera: tCameras.last));
  });

  test('should call the specified methods and initialize the specified variables when the selected camera is the last', ()async{
    when(tCameraController.description).thenReturn(tCameras.last);
    photosTranslatorBloc.emit(OnSelectingCamera());
    photosTranslatorBloc.add(ChooseCameraEvent(camera: tCameras.last));
    await untilCalled(tCameraController.initialize());
    verify(tCameraController.initialize());
    expect(photosTranslatorBloc.cameraController!.description.name, tCameraController.description.name);
    expect(photosTranslatorBloc.cameraController!.enableAudio, tCameraController.enableAudio);
    expect(photosTranslatorBloc.cameraController!.imageFormatGroup, tCameraController.imageFormatGroup);
    expect(photosTranslatorBloc.cameraController!.resolutionPreset.name, tCameraController.resolutionPreset.name);
  });
}

void _testAddPhotoTranslationGroup() {
  late int tFileId;
  late MockCameraController tCameraController;
  late List<TranslationsFile> tUncompletedFiles;
  late XFile tPicture;
  setUp(() {
    tFileId = 1001;
    tCameraController = MockCameraController();
    when(tCameraController.cameraId).thenReturn(0);
    when(tCameraController.resolutionPreset).thenReturn(ResolutionPreset.max);
    when(tCameraController.enableAudio).thenReturn(false);
    when(tCameraController.imageFormatGroup).thenReturn(ImageFormatGroup.jpeg);
    tUncompletedFiles = const [
      TranslationsFile(id: 0, name: 'file_1', completed: false, translations: [
        Translation(id: 100, imgUrl: 'url_1', text: null),
        Translation(id: 101, imgUrl: 'url_2', text: 'texto_2'),
      ]),
      TranslationsFile(id: 1, name: 'file_2', completed: false, translations: [
        Translation(id: 100, imgUrl: 'url_1', text: null),
        Translation(id: 101, imgUrl: 'url_2', text: 'texto_2'),
      ]),
    ];
    tPicture = XFile('any_path');
    when(getUncompletedTranslationsFiles())
        .thenAnswer((_) async => Right(tUncompletedFiles));
    when(translatePhoto(any)).thenAnswer((_) async => const Right(null));
    when(tCameraController.takePicture()).thenAnswer((_) async => tPicture);
  });

  test('should call the specified methods when current state is OnCreating', () async {
    photosTranslatorBloc.emit(OnInitializingTranslations(
        id: tFileId,
        name: '',
        canTranslate: true,
        canEnd: false,
        cameraController: tCameraController
      )
    );
    photosTranslatorBloc.add(AddPhotoTranslationEvent());
    await untilCalled(translatePhoto(any));
    verify(translatePhoto(tPicture.path));
  });

  test(
      'should yield the expected ordered states when current state is OnCreating and it cant end',
      () async {
    photosTranslatorBloc.emit(OnInitializingTranslations(
        id: tFileId,
        name: '',
        canTranslate: true,
        canEnd: false,
        cameraController: tCameraController));
    final expectedOrderedStates = [
      OnInitializingTranslations(
        id: tFileId,
        name: '',
        canTranslate: false,
        canEnd: false,
        cameraController: tCameraController
      ),
      OnInitializingTranslations(
          id: tFileId,
          name: '',
          canTranslate: true,
          canEnd: true,
          cameraController: tCameraController)
    ];
    expectLater(photosTranslatorBloc.stream, emitsInOrder(expectedOrderedStates));
    photosTranslatorBloc.add(AddPhotoTranslationEvent());
  });
  
  test(
      'should yield the expected ordered states when current state is OnCreating and it already can end',
      () async {
    photosTranslatorBloc.emit(OnInitializingTranslations(
        id: tFileId,
        name: '',
        canTranslate: true,
        canEnd: false,
        cameraController: tCameraController));
    final expectedOrderedStates = [
      OnInitializingTranslations(
        id: tFileId,
        name: '',
        canTranslate: false,
        canEnd: false,
        cameraController: tCameraController
      ),
      OnInitializingTranslations(
          id: tFileId,
          name: '',
          canTranslate: true,
          canEnd: true,
          cameraController: tCameraController)
    ];
    expectLater(photosTranslatorBloc.stream, emitsInOrder(expectedOrderedStates));
    photosTranslatorBloc.add(AddPhotoTranslationEvent());
  });
}

void _testChangeFileNameGroup() {
  late MockCameraController tCameraController;
  late String tNewName;
  setUp(() {
    tCameraController = MockCameraController();
    when(tCameraController.cameraId).thenReturn(0);
    when(tCameraController.resolutionPreset).thenReturn(ResolutionPreset.max);
    when(tCameraController.enableAudio).thenReturn(false);
    when(tCameraController.imageFormatGroup).thenReturn(ImageFormatGroup.jpeg);
  });

  test(
      'should yield the expected ordered states when file could end and now it cant',
      () {
    photosTranslatorBloc.emit(const OnNamingTranslationsFile(name: 'n', canEnd: true));
    tNewName = '';
    final expectedOrderedStates = [
      OnNamingTranslationsFile(name: tNewName, canEnd: false)
    ];
    expectLater(
        photosTranslatorBloc.stream, emitsInOrder(expectedOrderedStates));
    photosTranslatorBloc.add(ChangeFileNameEvent(tNewName));
  });

  test(
      'should yield the expected ordered states when file could Not end and now it can',
      () {
    photosTranslatorBloc.emit(const OnNamingTranslationsFile(name: '', canEnd: false));
    tNewName = 'new_name_x';
    final expectedOrderedStates = [
      OnNamingTranslationsFile(name: tNewName, canEnd: true)
    ];
    expectLater(photosTranslatorBloc.stream, emitsInOrder(expectedOrderedStates));
    photosTranslatorBloc.add(ChangeFileNameEvent(tNewName));
  });
}

void _testSaveFileNameGroup(){
  late String tName;
  late int tId;
  setUp((){
    tName = 't_name';
    tId = 1001;
    photosTranslatorBloc.cameraController = tCameraController;
    when(tCameraController.cameraId).thenReturn(0);
    when(tCameraController.resolutionPreset).thenReturn(ResolutionPreset.max);
    when(tCameraController.enableAudio).thenReturn(false);
    when(tCameraController.imageFormatGroup).thenReturn(ImageFormatGroup.jpeg);
    when(tCameraController.description).thenReturn(tCameras.first);
    photosTranslatorBloc.emit(OnNamingTranslationsFile(name: tName, canEnd: true));
    when(createTranslationsFile(any)).thenAnswer((_) async => Right(tId));
  });

  test('shold call the specified methods', ()async{
    photosTranslatorBloc.add(SaveCurrentFileNameEvent());
    await untilCalled(createTranslationsFile(any));
    verify(createTranslationsFile(tName));
  });
  
  test('should yield the expected ordered states', ()async{
    final expectedOrderedStates = [
      OnLoadingTranslations(),
      OnInitializingTranslations(
        id: tId,
        name: tName,
        canTranslate: true,
        canEnd: false,
        cameraController: tCameraController
      )
    ];
    expectLater(photosTranslatorBloc.stream, emitsInOrder(expectedOrderedStates));
    photosTranslatorBloc.add(SaveCurrentFileNameEvent());
  });
}

void _testEndTranslationsFileCreationGroup() {
  late List<TranslationsFile> tUncompletedFiles;
  late MockCameraController tCameraController;
  late int tFileId;
  late String tFileName;
  setUp(() {
    tUncompletedFiles = const [
      TranslationsFile(id: 0, name: 'file_1', completed: false, translations: [
        Translation(id: 100, imgUrl: 'url_1', text: null),
        Translation(id: 101, imgUrl: 'url_2', text: 'texto_2'),
      ]),
      TranslationsFile(id: 1, name: 'file_2', completed: false, translations: [
        Translation(id: 102, imgUrl: 'url_1', text: null),
        Translation(id: 103, imgUrl: 'url_2', text: 'texto_2'),
      ]),
    ];
    tCameraController = MockCameraController();
    when(tCameraController.cameraId).thenReturn(0);
    when(tCameraController.resolutionPreset).thenReturn(ResolutionPreset.max);
    when(tCameraController.enableAudio).thenReturn(false);
    when(tCameraController.imageFormatGroup).thenReturn(ImageFormatGroup.jpeg);
    tFileId = 1000;
    tFileName = 'name_x';
    photosTranslatorBloc.emit(OnInitializingTranslations(
        id: tFileId,
        name: tFileName,
        canTranslate: true,
        canEnd: true,
        cameraController: tCameraController));
    when(endPhotosTranslation())
        .thenAnswer((_) async => const Right(null));
    when(getUncompletedTranslationsFiles())
        .thenAnswer((_) async => Right(tUncompletedFiles));
  });

  test('should call the specified methods', () async {
    photosTranslatorBloc.add(EndTranslationsFileEvent());
    await untilCalled(endPhotosTranslation());
    verify(endPhotosTranslation());
    await untilCalled(getUncompletedTranslationsFiles());
    verify(getUncompletedTranslationsFiles());
  });
  
  test('should yield the expected ordered states', () async {
    final expectedOrderedStates = [
      OnLoadingTranslations(),
      OnTranslationsFilesLoaded(uncompletedFiles: tUncompletedFiles, completedFiles: const [])
    ];
    expectLater(photosTranslatorBloc.stream, emitsInOrder(expectedOrderedStates));
    photosTranslatorBloc.add(EndTranslationsFileEvent());
  });
}

void _testUpdateCompletedTranslationsGroup(){
  late List<TranslationsFile> tUncompletedFiles;
  late List<PdfFile> tCompletedFilesInit;
  late List<PdfFile> tCompletedFilesFin;
  setUp(() {
    tUncompletedFiles = const [
      TranslationsFile(id: 0, name: 'file_1', completed: false, translations: [
        Translation(id: 100, imgUrl: 'url_1', text: null),
        Translation(id: 101, imgUrl: 'url_2', text: 'texto_1'),
      ]),
      TranslationsFile(id: 1, name: 'file_2', completed: false, translations: [
        Translation(id: 102, imgUrl: 'url_3', text: null),
        Translation(id: 103, imgUrl: 'url_4', text: 'texto_2'),
      ]),
    ];
    tCompletedFilesInit = const [
      PdfFile(id: 3, name: 'file_3', url: 'pdf_1'),
    ];
    tCompletedFilesFin = const [
      PdfFile(id: 3, name: 'file_3', url: 'pdf_1'),
      PdfFile(id: 1, name: 'file_2', url: 'pdf_2'),
    ];
    photosTranslatorBloc.emit(OnTranslationsFilesLoaded(
      uncompletedFiles: tUncompletedFiles, 
      completedFiles: tCompletedFilesInit
    ));
    when(getCompletedTranslationsFiles()).thenAnswer((_) async => Right(tCompletedFilesFin));
  });

  test('should call the specified methods', ()async{
    photosTranslatorBloc.add(UpdateCompletedTranslationsFilesEvent());
    await untilCalled(getCompletedTranslationsFiles());
    verify(getCompletedTranslationsFiles());
  });

  test('should yield the expected ordered states', ()async{
    photosTranslatorBloc.emit(OnTranslationsFilesLoaded(
      uncompletedFiles: tUncompletedFiles, 
      completedFiles: tCompletedFilesInit
    ));
    final expectedOrderedStates = [
      OnLoadingTranslations(),
      OnTranslationsFilesLoaded(
        uncompletedFiles: tUncompletedFiles,
        completedFiles: tCompletedFilesFin
      )
    ];
    expectLater(photosTranslatorBloc.stream, emitsInOrder(expectedOrderedStates));
    photosTranslatorBloc.add(UpdateCompletedTranslationsFilesEvent());
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
    photosTranslatorBloc.add(SelectPdfFileEvent(tFile));
    await untilCalled(generatePdf(any));
    verify(generatePdf(tFile));
  });

  test('should yield the expected ordered states', ()async{
    final expectedOrderedStates = [
      OnLoadingTranslations(),
      OnPdfFileLoaded(file: tFile, pdf: tPdf)
    ];
    expectLater(photosTranslatorBloc.stream, emitsInOrder(expectedOrderedStates));
    photosTranslatorBloc.add(SelectPdfFileEvent(tFile));
  });
}