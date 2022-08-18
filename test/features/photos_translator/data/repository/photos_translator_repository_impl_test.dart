import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_local_data_source.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_remote_data_source.dart';
import 'package:vido/features/photos_translator/data/repository/photos_translator_repository_impl.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'photos_translator_repository_impl_test.mocks.dart';

late PhotosTranslatorRepositoryImpl photosTranslatorRepository;
late MockPhotosTranslatorRemoteDataSource remoteDataSource;
late MockPhotosTranslatorLocalDataSource localDataSource;
late StreamController<List<TranslationsFile>>
    uncompletedFilesReceiver;
late StreamController<List<TranslationsFile>>
    inCompletingProcessFileReceiver;
late StreamController<List<PdfFile>>
    completedFilesReceiver;

@GenerateMocks([PhotosTranslatorRemoteDataSource, PhotosTranslatorLocalDataSource, File])
void main() {
  setUp(() {
    completedFilesReceiver = StreamController<List<PdfFile>>();
    inCompletingProcessFileReceiver = StreamController<List<TranslationsFile>>();
    uncompletedFilesReceiver = StreamController<List<TranslationsFile>>();
    localDataSource = MockPhotosTranslatorLocalDataSource();
    remoteDataSource = MockPhotosTranslatorRemoteDataSource();
    photosTranslatorRepository = PhotosTranslatorRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        uncompletedFilesReceiver: uncompletedFilesReceiver,
        inCompletingProcessFileReceiver: inCompletingProcessFileReceiver,
        completedFilesReceiver: completedFilesReceiver
    );
  });

  group('create translators file', _testCreatetranslatorsFileGroup);
  group('end photos translation file', _testEndPhotosTranslationFileGroup);
  group('get uncompleted translations files', _testGetUncompletedTranslationsFilesGruop);
  group('translate photo', _testTranslatePhotoGroup);
  group('get completed translations files', _testGetCompletedTranslationsFilesGroup);
  group('generate pdf', _testGeneratePdfGroup);
}

void _testCreatetranslatorsFileGroup() {
  late TranslationsFile tNewFile;
  late String tName;
  setUp(() {
    tName = 'new_name';
    tNewFile = TranslationsFile(id: 0, name: tName, completed: false, translations: const []);
    when(remoteDataSource.createTranslationsFile(any))
        .thenAnswer((_) async => tNewFile);
  });

  test('should call the specified methods', () async {
    await photosTranslatorRepository.createTranslatorsFile(tName);
    verify(remoteDataSource.createTranslationsFile(tName));
    verify(localDataSource.createTranslationsFile(tNewFile));
  });

  test('should return the expected result', () async {
    final result = await photosTranslatorRepository.createTranslatorsFile(tName);
    expect(result, Right(tNewFile.id));
  });
  
}

void _testEndPhotosTranslationFileGroup() {

  test('should call the specified methods', () async {
    await photosTranslatorRepository.endPhotosTranslationFile();
    verify(localDataSource.endTranslationsFileCreation());
  });

  test('should return the expected result', ()async{
    final result = await photosTranslatorRepository.endPhotosTranslationFile();
    expect(result, const Right(null));
  });
  
}

void _testGetUncompletedTranslationsFilesGruop() {
  late List<TranslationsFile> tTranslationsFiles;
  setUp(() {
    tTranslationsFiles = const [
      TranslationsFile(
          id: 0, name: 'tf_1', completed: false, translations: []),
      TranslationsFile(
          id: 1,
          name: 'tf_2',
          completed: false,
          translations: [
            Translation(id: 100, text: 't_1', imgUrl: 't_url_1')
          ]),
    ];
    when(localDataSource.getUncompletedTranslationsFiles())
        .thenAnswer((_) async => tTranslationsFiles);
  });

  test('should call the specified methods', () async {
    await photosTranslatorRepository.getUncompletedTranslationsFiles();
    verify(localDataSource.getUncompletedTranslationsFiles());
  });

  test('should return the expected result', () async {
    final result =
        await photosTranslatorRepository.getUncompletedTranslationsFiles();
    expect(result, Right(tTranslationsFiles));
  });
}

void _testTranslatePhotoGroup() {
  late String tPhotoUrl;
  late List<TranslationsFile> tUncompletedtranslationsFilesInit;
  setUp(() {
    tPhotoUrl = 'url_x';
  });

  group('when localDataSource is translating', () {
    setUp(() {
      tUncompletedtranslationsFilesInit = const [
        TranslationsFile(id: 0, name: 'f0', completed: false, translations: []),
        TranslationsFile(id: 1, name: 'f1', completed: false, translations: [])
      ];
      when(localDataSource.translating).thenAnswer((_) async => true);
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => const TranslationsFile(id: 0, name: 'file_0', completed: false, translations: []));
      when(localDataSource.getUncompletedTranslationsFiles()).thenAnswer((_) async => tUncompletedtranslationsFilesInit);
    });

    test('should call the specified methods', () async {
      await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      verify(localDataSource.saveUncompletedTranslation(tPhotoUrl));
      verify(localDataSource.translating);
      verifyNever(localDataSource.getCompletedTranslationsFiles());
      verifyNever(localDataSource.getCurrentCreatedFile());
      verifyNever(localDataSource.translate(any, any));
      verifyNever(remoteDataSource.addTranslation(any, any));
      verifyNever(localDataSource.updateTranslation(any, any, any));
    });

    test('should emit the expected item on the streams', () async {
      final expectedItems = [];
      expectLater(uncompletedFilesReceiver.stream, emitsInOrder([tUncompletedtranslationsFilesInit]));
      expectLater(inCompletingProcessFileReceiver.stream, emitsInOrder(expectedItems));
      expectLater(completedFilesReceiver.stream, emitsInOrder(expectedItems));
      await photosTranslatorRepository.translatePhoto(tPhotoUrl);

    });

    test('should return the expected result', () async {
      final result = await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      expect(result, const Right(null));
    });
  });

  group('when localDataSource is not translating, and there is an uncompleted file with one uncompleted translation', () {
    late Translation tFirstUncompletedTranslation;
    late Translation tTranslatedTranslation;
    late TranslationsFile tUntranslatedFile;
    late TranslationsFile tTranslatedFile;
    late PdfFile tPdfFile;
    late Translation tTranslationUpdated;
    late List<TranslationsFile> tUncompletedTranslationsFilesFin;
    setUp(() {
      const translationText = 'translation_text';
      tFirstUncompletedTranslation = const Translation(id: 2052, text: null, imgUrl: 'url_1');
      tTranslatedTranslation = const Translation(
          id: 2052, 
          text: translationText, 
          imgUrl: 'url_1'
      );
      tTranslationUpdated = const Translation(
          id: 3052, 
          text: translationText, 
          imgUrl: 'url_1'
      );
      const fileId = 1051;
      const fileName = 'tf_1052';
      tUntranslatedFile = TranslationsFile(
        id: fileId,
        name: fileName,
        completed: true,
        translations: [tFirstUncompletedTranslation]
      );
      tTranslatedFile = TranslationsFile(
        id: fileId,
        name: fileName,
        completed: true,
        translations: [tTranslationUpdated]
      );
      tPdfFile = const PdfFile(id: fileId, name: fileName, url: 'pdf_url');
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => tUntranslatedFile);
      tUncompletedtranslationsFilesInit = [
        tUntranslatedFile
      ];
      tUncompletedTranslationsFilesFin = [];
      when(localDataSource.translating).thenAnswer((_) async => false);
      final uncompletedTranslsFilesResponses = [
        tUncompletedtranslationsFilesInit,
        tUncompletedTranslationsFilesFin
      ];
      when(localDataSource.getUncompletedTranslationsFiles())
        .thenAnswer( (_) async => uncompletedTranslsFilesResponses.removeAt(0));
      when(localDataSource.translate(any, any))
          .thenAnswer((_) async => tTranslatedTranslation);
      when(remoteDataSource.addTranslation(any, any))
          .thenAnswer((_) async => tTranslationUpdated.id!);
      when(remoteDataSource.endTranslationFile(any))
          .thenAnswer((_) async =>  tPdfFile);
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => tTranslatedFile);
      when(localDataSource.getUncompletedTranslationsFile(fileId)).thenAnswer((_) async => tTranslatedFile);
    });

    test('should call the specified methods', () async {
      await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      verify(localDataSource.saveUncompletedTranslation(tPhotoUrl));
      verify(localDataSource.translating);
      verify(localDataSource.getUncompletedTranslationsFiles()).called(2);
      verifyNever(localDataSource.getCompletedTranslationsFiles());
      verify(localDataSource.translate(
        tUntranslatedFile.translations.first,
        tUntranslatedFile.id
      ));
      verify(remoteDataSource.addTranslation(
        tUntranslatedFile.id, 
        tTranslatedTranslation
      ));
      verify(localDataSource.updateTranslation(
        tUntranslatedFile.id,
        tTranslationUpdated, 
        tFirstUncompletedTranslation
      ));
      verifyNever(remoteDataSource.endTranslationFile(any));
      verifyNever(localDataSource.addPdfFile(any));
    });
    
    test('should emit the expected item on the uncompleted files stream', () async {
      final uncompletedExpectedItems = [
        tUncompletedtranslationsFilesInit,
        tUncompletedTranslationsFilesFin
      ];
      expectLater(uncompletedFilesReceiver.stream, emitsInOrder(uncompletedExpectedItems));
      expectLater(inCompletingProcessFileReceiver.stream, emitsInOrder([]));
      expectLater(completedFilesReceiver.stream, emitsInOrder([]));
      await photosTranslatorRepository.translatePhoto(tPhotoUrl);
    });

    test('should return the expected result', () async {
      final result = await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      expect(result, const Right(null));
    });
  });

  group('when local data source is not translating and there are more than one uncompleted translation and one uncompleted file is not on creation', () {
    late Translation tFirstUncompletedTranslation;
    late Translation tSecondUncompletedTranslation;
    late Translation tFirstTranslatedTranslation;
    late Translation tSecondTranslatedTranslation;
    late TranslationsFile tUntranslatedFile1;
    late TranslationsFile tTranslatedFile1;
    late TranslationsFile tUntranslatedFile2;
    late TranslationsFile tTranslatedFile2;
    late Translation tFirstTranslationUpdated;
    late Translation tSecondTranslationUpdated;
    late List<TranslationsFile> tUncompletedtranslationsFiles2;
    late List<TranslationsFile> tUncompletedtranslationsFilesFin;
    late PdfFile tCompletedFile;
    late List<PdfFile> tCompletedFiles;
    setUp(() {
      const tTranslationText1 = 'translation_text_1';
      const tTranslationText2 = 'translation_text_2';
      tFirstUncompletedTranslation = Translation(
        id: 2052,
        text: null,
        imgUrl: tPhotoUrl
      );
      tSecondUncompletedTranslation = const Translation(
        id: 2053,
        text: null,
        imgUrl: 'url_2'
      );
      tFirstTranslatedTranslation = const Translation(
        id: 2052,
        text: tTranslationText1,
        imgUrl: 'url_1'
      );
      tSecondTranslatedTranslation = const Translation(
        id: 2053,
        text: tTranslationText2,
        imgUrl: 'url_2'
      );
      tUntranslatedFile1 = TranslationsFile(
        id: 1052,
        name: 'tf_1052',
        completed: true,
        translations: [
          const Translation(id: 2050, text: 'text_x', imgUrl: 'url_0'),
          tFirstUncompletedTranslation,
        ]
      );
      tTranslatedFile1 = TranslationsFile(
        id: 1052,
        name: 'tf_1052',
        completed: true,
        translations: [
          const Translation(id: 2050, text: 'text_x', imgUrl: 'url_0'),
          tFirstTranslatedTranslation,
        ]
      );
      tUntranslatedFile2 = TranslationsFile(
        id: 1053,
        name: 'tf_1053',
        completed: false,
        translations: [tSecondUncompletedTranslation]
      );
      tTranslatedFile2 = const TranslationsFile(
        id: 1053,
        name: 'tf_1053',
        completed: true,
        translations: [
          Translation(id: 2053, text: 'text_xxx', imgUrl: 'url_2')
        ]
      );
      tUncompletedtranslationsFilesInit = [
        tUntranslatedFile1,
        tUntranslatedFile2
      ];
      tUncompletedtranslationsFiles2 = [
        const TranslationsFile(
          id: 1052,
          name: 'tf_1052',
          completed: true,
          translations: [
            Translation(id: 2050, text: 'text_x', imgUrl: 'url_0'),
            Translation(id: 2052, text: 'text_xx', imgUrl: 'url_1'),
          ]
        ),
        tUntranslatedFile2
      ];
      tUncompletedtranslationsFilesFin = [
        const TranslationsFile(
          id: 1052,
          name: 'tf_1052',
          completed: true,
          translations: [
            Translation(id: 2050, text: 'text_x', imgUrl: 'url_0'),
            Translation(id: 2052, text: 'text_xx', imgUrl: 'url_1'),
          ]
        ),
      ];
      tCompletedFile = PdfFile(id: tTranslatedFile2.id, name: tTranslatedFile2.name, url: 'pdf_url');
      tCompletedFiles = [
        tCompletedFile
      ];
      tFirstTranslationUpdated = const Translation(
          id: 3052, text: tTranslationText1, imgUrl: 'url_1');
      tSecondTranslationUpdated = const Translation(
          id: 3053, text: tTranslationText2, imgUrl: 'url_2');
      when(localDataSource.translating).thenAnswer((_) async => false);
      final uncompletedTranslFilesResponses = [
        tUncompletedtranslationsFilesInit,
        tUncompletedtranslationsFiles2,
        tUncompletedtranslationsFilesFin
      ];
      when(localDataSource.getUncompletedTranslationsFiles())
          .thenAnswer((_) async => uncompletedTranslFilesResponses.removeAt(0));
      final currentCreatedFileResponses = [
        tTranslatedFile1,
        tTranslatedFile1
      ];
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => currentCreatedFileResponses.removeAt(0));
      final translateResponses = [
        tFirstTranslatedTranslation,
        tSecondTranslatedTranslation
      ];
      when(localDataSource.translate(any, any))
          .thenAnswer((_) async => translateResponses.removeAt(0));
      final addTranslationResponses = [
        tFirstTranslationUpdated.id!,
        tSecondTranslationUpdated.id!
      ];
      when(remoteDataSource.addTranslation(any, any))
          .thenAnswer((_) async => addTranslationResponses.removeAt(0));
      when(localDataSource.getUncompletedTranslationsFile(tUntranslatedFile1.id)).thenAnswer((_) async => tTranslatedFile1);
      when(localDataSource.getUncompletedTranslationsFile(tUntranslatedFile2.id)).thenAnswer((_) async => tTranslatedFile2);
      when(localDataSource.getCompletedTranslationsFiles()).thenAnswer((_)async => tCompletedFiles);
      when(remoteDataSource.endTranslationFile(any)).thenAnswer((_) async => tCompletedFile);
      photosTranslatorRepository.inCompletingProcessFiles.add(const TranslationsFile(id: 34000, name: 'tf_34000', completed: true, translations: []));
    });

    test('should call the specified methods', () async {
      await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      verify(localDataSource.saveUncompletedTranslation(tPhotoUrl));
      verify(localDataSource.translating).called(3);
      verify(localDataSource.getUncompletedTranslationsFiles()).called(3);

      verify(localDataSource.translate(tFirstUncompletedTranslation, tUntranslatedFile1.id));
      verify(localDataSource.getCurrentCreatedFile()).called(2);
      verify(localDataSource.getUncompletedTranslationsFile(tUntranslatedFile1.id));
      verifyNever(remoteDataSource.endTranslationFile(tUntranslatedFile1.id));

      verify(localDataSource.translate(tSecondUncompletedTranslation, tUntranslatedFile2.id));
      verify(localDataSource.getUncompletedTranslationsFile(tUntranslatedFile2.id));
      verify(remoteDataSource.endTranslationFile(tUntranslatedFile2.id));
      verify(localDataSource.addPdfFile(tCompletedFile));
      verify(localDataSource.removeTranslationsFile(tTranslatedFile2));
      verify(localDataSource.getCompletedTranslationsFiles()).called(1);

      verify(remoteDataSource.addTranslation(tUntranslatedFile1.id, tFirstTranslatedTranslation));
      verify(remoteDataSource.addTranslation(tUntranslatedFile2.id, tSecondTranslatedTranslation));

      verify(localDataSource.updateTranslation(tUntranslatedFile1.id, tFirstTranslationUpdated, tFirstUncompletedTranslation));
      verify(localDataSource.updateTranslation(tUntranslatedFile2.id, tSecondTranslationUpdated, tSecondUncompletedTranslation));
    });

    test('should emit the expected items on the uncompleted files stream', () async {
      final expectedUncompletedItems = [
        tUncompletedtranslationsFilesInit,
        tUncompletedtranslationsFiles2,
        tUncompletedtranslationsFilesFin
      ];
      expectLater(uncompletedFilesReceiver.stream, emitsInOrder(expectedUncompletedItems));
      final expectedInCompletingItems = [
        [...photosTranslatorRepository.inCompletingProcessFiles, tTranslatedFile2],
        [...photosTranslatorRepository.inCompletingProcessFiles],
      ];
      expectLater(inCompletingProcessFileReceiver.stream, emitsInOrder(expectedInCompletingItems));
      expectLater(completedFilesReceiver.stream, emitsInOrder([tCompletedFiles]));
      await photosTranslatorRepository.translatePhoto(tPhotoUrl);
    });

    test('should return the expected result', () async {
      final result = await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      expect(result, const Right(null));
    });
  });

}

void _testGetCompletedTranslationsFilesGroup(){
  late List<PdfFile> tCompletedFiles;

  setUp((){
    tCompletedFiles = const [
      PdfFile(id: 0, name: 'f_1', url: 'url_1'),
      PdfFile(id: 1, name: 'f_2', url: 'url_2')
    ];
    when(remoteDataSource.getCompletedPdfFiles()).thenAnswer((_) async => tCompletedFiles);
  });

  test('should call the specified method', ()async{
    await photosTranslatorRepository.getCompletedFiles();
    verify(remoteDataSource.getCompletedPdfFiles());
    verify(localDataSource.updatePdfFiles(tCompletedFiles));
  });

  test('should emit the expected ordered values', ()async{
    final expectedOrderedValues = [
      tCompletedFiles
    ];
    expectLater(completedFilesReceiver.stream, emitsInOrder(expectedOrderedValues));
    await photosTranslatorRepository.getCompletedFiles();
  });

  test('should return the expected ordered states', ()async{
    final result = await photosTranslatorRepository.getCompletedFiles();
    expect(result, Right(tCompletedFiles));
  });
}

void _testGeneratePdfGroup(){
  late PdfFile tFile;
  late MockFile tPdf;
  setUp((){
    tFile = const PdfFile(id: 0, name: 'file_0', url: 'url_0');
    tPdf = MockFile();
    when(remoteDataSource.getGeneratedPdf(any)).thenAnswer((_) async => tPdf);
    when(tPdf.path).thenReturn('pdf_0');
  });

  test('should call the specified methods', ()async{
    await photosTranslatorRepository.generatePdf(tFile);
    verify(remoteDataSource.getGeneratedPdf(tFile));
  });

  test('should return the expected ordered states', ()async{
    final result = await photosTranslatorRepository.generatePdf(tFile);
    expect(result, Right(tPdf));
  });
}