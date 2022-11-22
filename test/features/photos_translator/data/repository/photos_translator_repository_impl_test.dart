import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/external/translations_file_parent_folder_getter.dart';
import 'package:vido/core/external/user_extra_info_getter.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_local_data_source.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_remote_data_source.dart';
import 'package:vido/features/photos_translator/data/repository/photos_translator_repository_impl.dart';
import 'package:vido/core/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';
import 'package:vido/features/photos_translator/domain/translations_files_receiver.dart';
import 'photos_translator_repository_impl_test.mocks.dart';

late PhotosTranslatorRepositoryImpl photosTranslatorRepository;
late MockPhotosTranslatorRemoteDataSource remoteDataSource;
late MockPhotosTranslatorLocalDataSource localDataSource;
late MockTranslationsFilesReceiver translationsFilesReceiver;
late MockTranslationsFileParentFolderGetter translFileParentFolderGetter;
late MockUserExtraInfoGetter userExtraInfoGetter;
@GenerateMocks([
  PhotosTranslatorRemoteDataSource, 
  PhotosTranslatorLocalDataSource,
  TranslationsFilesReceiver,
  TranslationsFileParentFolderGetter,
  UserExtraInfoGetter,
  File
])
void main() {
  setUp(() {
    userExtraInfoGetter = MockUserExtraInfoGetter();
    translFileParentFolderGetter = MockTranslationsFileParentFolderGetter();
    translationsFilesReceiver = MockTranslationsFilesReceiver();
    localDataSource = MockPhotosTranslatorLocalDataSource();
    remoteDataSource = MockPhotosTranslatorRemoteDataSource();
    photosTranslatorRepository = PhotosTranslatorRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      translationsFilesReceiver: translationsFilesReceiver,
      translFileParentFolderGetter: translFileParentFolderGetter,
      userExtraInfoGetter: userExtraInfoGetter
    );
  });

  group('create translators file', _testCreatetranslatorsFileGroup);
  group('end photos translation file', _testEndPhotosTranslationFileGroup);
  group('translate photo', _testTranslatePhotoGroup);
  group('create folder', _testCreateFolderGroup);
  group('init pending translations', _testInitPendingTranslations);
  group('pick pdf', _testPickPdfGroup);
  group('create pdf file', _testCreatePdfFileGroup);
}

void _testCreatetranslatorsFileGroup() {
  late TranslationsFile tNewFile;
  late String tName;
  late String tAccessToken;
  late int tParentFolderId;
  setUp(() {
    tName = 'new_name';
    tAccessToken = 'access_token';
    tNewFile = TranslationsFile(id: 0, name: tName, completed: false, translations: const []);
    tParentFolderId = 10;
    when(userExtraInfoGetter.getAccessToken()).thenAnswer((_) async => tAccessToken);
    when(remoteDataSource.createTranslationsFile(any, any, any))
        .thenAnswer((_) async => tNewFile);
    when(translFileParentFolderGetter.getCurrentFileId())
        .thenAnswer((_) async => tParentFolderId);
  });

  test('should call the specified methods', () async {
    await photosTranslatorRepository.createTranslationsFile(tName);
    verify(userExtraInfoGetter.getAccessToken());
    verify(remoteDataSource.createTranslationsFile(tName, tParentFolderId, tAccessToken));
    verify(localDataSource.createTranslationsFile(tNewFile));
  });

  test('should return the expected result', () async {
    final result = await photosTranslatorRepository.createTranslationsFile(tName);
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

void _testTranslatePhotoGroup() {
  late String tPhotoUrl;
  late List<TranslationsFile> tUncompletedtranslationsFilesInit;
  setUp(() {
    tPhotoUrl = 'url_x';
  });

  group('when localDataSource is translating', (){
    setUp(() {
      tUncompletedtranslationsFilesInit = const [
        TranslationsFile(id: 0, name: 'f0', completed: false, translations: []),
        TranslationsFile(id: 1, name: 'f1', completed: false, translations: [])
      ];
      when(localDataSource.translating).thenReturn(true);
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => const TranslationsFile(id: 0, name: 'file_0', completed: false, translations: []));
      when(localDataSource.getTranslationsFiles()).thenAnswer((_) async => tUncompletedtranslationsFilesInit);
    });

    test('should call the specified methods', () async {
      await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      verify(localDataSource.saveUncompletedTranslation(tPhotoUrl));
      verify(localDataSource.translating);
      verify(translationsFilesReceiver.setTranslationsFiles(tUncompletedtranslationsFilesInit));
      verifyNever(userExtraInfoGetter.getAccessToken());
      verifyNever(localDataSource.getCurrentCreatedFile());
      verifyNever(localDataSource.translate(any, any));
      verifyNever(remoteDataSource.addTranslation(any, any, any));
      verifyNever(localDataSource.updateTranslation(any, any));
    });

    test('should return the expected result', () async {
      final result = await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      expect(result, const Right(null));
    });
  });

  group('when localDataSource is not translating, and there is an uncompleted file with one uncompleted translation', () {
    late String tAccessToken;
    late Translation tFirstUncompletedTranslation;
    late Translation tTranslatedTranslation;
    late TranslationsFile tUntranslatedFile;
    late TranslationsFile tTranslatedFile;
    late PdfFile tPdfFile;
    late Translation tTranslationWithRemoteId;
    late List<TranslationsFile> tUncompletedTranslationsFilesFin;
    setUp(() {
      tAccessToken = 'access_token';
      const translationText = 'translation_text';
      tFirstUncompletedTranslation = const Translation(id: 2052, text: null, imgUrl: 'url_1');
      tTranslatedTranslation = const Translation(
          id: 2052, 
          text: translationText, 
          imgUrl: 'url_1'
      );
      tTranslationWithRemoteId = const Translation(
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
        translations: [tTranslationWithRemoteId]
      );
      tPdfFile = const PdfFile(
        id: fileId, 
        name: fileName, 
        url: 'pdf_url', 
        parentId: 100,
        canBeRead: true,
        canBeEdited: true,
        canBeDeleted: false
      );
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => tUntranslatedFile);
      tUncompletedtranslationsFilesInit = [
        tUntranslatedFile
      ];
      tUncompletedTranslationsFilesFin = [];
      when(localDataSource.translating).thenReturn(false);
      final uncompletedTranslsFilesResponses = [
        tUncompletedtranslationsFilesInit,
        tUncompletedTranslationsFilesFin
      ];
      when(localDataSource.getTranslationsFiles())
        .thenAnswer( (_) async => uncompletedTranslsFilesResponses.removeAt(0));
      when(localDataSource.translate(any, any))
          .thenAnswer((_) async => tTranslatedTranslation);
      when(remoteDataSource.addTranslation(any, any, any))
          .thenAnswer((_) async => tTranslationWithRemoteId.id!);
      when(remoteDataSource.endTranslationFile(any, any))
          .thenAnswer((_) async =>  tPdfFile);
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => tTranslatedFile);
      when(localDataSource.getTranslationsFile(fileId)).thenAnswer((_) async => tTranslatedFile);
      when(userExtraInfoGetter.getAccessToken()).thenAnswer((_) async => tAccessToken);
    });

    test('should call the specified methods', () async {
      await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      verify(localDataSource.saveUncompletedTranslation(tPhotoUrl));
      verify(localDataSource.translating);
      verify(localDataSource.getTranslationsFiles()).called(2);
      verify(localDataSource.translate(
        tUntranslatedFile.translations.first,
        tUntranslatedFile.id
      ));
      verify(localDataSource.updateTranslation(
        tUntranslatedFile.id, 
        tTranslatedTranslation
      ));
      verify(userExtraInfoGetter.getAccessToken());
      verify(remoteDataSource.addTranslation(
        tUntranslatedFile.id, 
        tTranslatedTranslation,
        tAccessToken
      ));
      verify(translationsFilesReceiver.setTranslationsFiles(tUncompletedtranslationsFilesInit));
      verify(translationsFilesReceiver.setTranslationsFiles(tUncompletedTranslationsFilesFin));
      verifyNever(remoteDataSource.endTranslationFile(any, any));
    });

    test('should return the expected result', () async {
      final result = await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      expect(result, const Right(null));
    });
  });

  group('when local data source is not translating and there are more than one uncompleted translation and one uncompleted file is not on creation', () {
    late String tAccessToken;
    late Translation tFirstUncompletedTranslation;
    late Translation tSecondUncompletedTranslation;
    late Translation tFirstTranslatedTranslation;
    late Translation tSecondTranslatedTranslation;
    late TranslationsFile tFile1Untranslated;
    late TranslationsFile tFile1Translated;
    late TranslationsFile tFile2Untranslated;
    late TranslationsFile tFile2Translated;
    late Translation tFirstTranslationWithRemoteId;
    late Translation tSecondTranslationWithRemoteId;
    late List<TranslationsFile> tUncompletedtranslationsFiles2;
    late List<TranslationsFile> tUncompletedtranslationsFilesFin;
    late PdfFile tCompletedFile;
    setUp(() {
      tAccessToken = 'access_token';
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
      tFile1Untranslated = TranslationsFile(
        id: 1052,
        name: 'tf_1052',
        completed: true,
        translations: [
          const Translation(id: 2050, text: 'text_x', imgUrl: 'url_0'),
          tFirstUncompletedTranslation,
        ]
      );
      tFile1Translated = TranslationsFile(
        id: 1052,
        name: 'tf_1052',
        completed: true,
        translations: [
          const Translation(id: 2050, text: 'text_x', imgUrl: 'url_0'),
          tFirstTranslatedTranslation,
        ]
      );
      tFile2Untranslated = TranslationsFile(
        id: 1053,
        name: 'tf_1053',
        completed: false,
        translations: [tSecondUncompletedTranslation]
      );
      tFile2Translated = const TranslationsFile(
        id: 1053,
        name: 'tf_1053',
        completed: true,
        translations: [
          Translation(id: 2053, text: 'text_xxx', imgUrl: 'url_2')
        ]
      );
      tUncompletedtranslationsFilesInit = [
        tFile1Untranslated,
        tFile2Untranslated
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
        tFile2Untranslated
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
      tCompletedFile = PdfFile(
        id: tFile2Translated.id, 
        name: tFile2Translated.name, 
        url: 'pdf_url', 
        parentId: 100,
        canBeRead: true,
        canBeEdited: true,
        canBeDeleted: false
      );
      tFirstTranslationWithRemoteId = const Translation(
          id: 3052, text: tTranslationText1, imgUrl: 'url_1');
      tSecondTranslationWithRemoteId = const Translation(
          id: 3053, text: tTranslationText2, imgUrl: 'url_2');
      when(localDataSource.translating).thenReturn(false);
      final uncompletedTranslFilesResponses = [
        tUncompletedtranslationsFilesInit,
        tUncompletedtranslationsFiles2,
        tUncompletedtranslationsFilesFin
      ];
      when(localDataSource.getTranslationsFiles())
          .thenAnswer((_) async => uncompletedTranslFilesResponses.removeAt(0));
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => tFile1Translated);
      final translateResponses = [
        tFirstTranslatedTranslation,
        tSecondTranslatedTranslation
      ];
      when(localDataSource.translate(any, any))
          .thenAnswer((_) async => translateResponses.removeAt(0));
      final addTranslationResponses = [
        tFirstTranslationWithRemoteId.id!,
        tSecondTranslationWithRemoteId.id!
      ];
      when(remoteDataSource.addTranslation(any, any, any))
          .thenAnswer((_) async => addTranslationResponses.removeAt(0));
      when(localDataSource.getTranslationsFile(tFile1Untranslated.id)).thenAnswer((_) async => tFile1Translated);
      when(localDataSource.getTranslationsFile(tFile2Untranslated.id)).thenAnswer((_) async => tFile2Translated);
      when(remoteDataSource.endTranslationFile(any, any)).thenAnswer((_) async => tCompletedFile);
      when(userExtraInfoGetter.getAccessToken()).thenAnswer((_) async => tAccessToken);
    });

    test('should call the specified methods', () async {
      await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      verify(localDataSource.saveUncompletedTranslation(tPhotoUrl));
      verify(localDataSource.translating).called(3);
      verify(localDataSource.getTranslationsFiles()).called(3);
      verify(translationsFilesReceiver.setTranslationsFiles(tUncompletedtranslationsFilesInit));

      verify(localDataSource.translate(tFirstUncompletedTranslation, tFile1Untranslated.id));
      verify(localDataSource.updateTranslation(tFile1Untranslated.id, tFirstTranslatedTranslation));
      verify(localDataSource.getCurrentCreatedFile()).called(4);
      verify(localDataSource.getTranslationsFile(tFile1Untranslated.id));
      verifyNever(remoteDataSource.endTranslationFile(tFile1Untranslated.id, tAccessToken));
      verify(translationsFilesReceiver.setTranslationsFiles(tUncompletedtranslationsFiles2));

      verify(localDataSource.translate(tSecondUncompletedTranslation, tFile2Untranslated.id));
      verify(localDataSource.updateTranslation(tFile2Untranslated.id, tSecondTranslatedTranslation));
      verify(localDataSource.getTranslationsFile(tFile2Untranslated.id));
      verify(remoteDataSource.endTranslationFile(tFile2Untranslated.id, tAccessToken));
      verify(localDataSource.removeTranslationsFile(tFile2Translated));
      verify(translationsFilesReceiver.setTranslationsFiles(tUncompletedtranslationsFilesFin));

      verify(remoteDataSource.addTranslation(tFile1Untranslated.id, tFirstTranslatedTranslation, tAccessToken));
      verify(remoteDataSource.addTranslation(tFile2Untranslated.id, tSecondTranslatedTranslation, tAccessToken));
      verify(userExtraInfoGetter.getAccessToken());
    });

    test('should return the expected result', () async {
      final result = await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      expect(result, const Right(null));
    });
  });

  group('when local data source is not translating and there are one uncompleted translations file and one completed translations file', (){
    late String tAccessToken;
    late Translation tSecondUncompletedTranslation;
    late Translation tFirstTranslatedTranslation;
    late Translation tSecondTranslatedTranslation;
    late TranslationsFile tFile1Untranslated;
    late TranslationsFile tFile1Translated;
    late TranslationsFile tFile2;
    late Translation tFirstTranslationWithRemoteId;
    late Translation tSecondTranslationWithRemoteId;
    late List<TranslationsFile> tTranslationsFilesInit;
    late List<TranslationsFile> tTranslationsFiles2;
    late List<TranslationsFile> tTranslationsFilesEnd;
    late PdfFile tPdfFile1;
    late PdfFile tPdfFile2;
    setUp(() {
      tAccessToken = 'access_token';
      const tTranslationText1 = 'translation_text_1';
      const tTranslationText2 = 'translation_text_2';
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
      tFile1Untranslated = TranslationsFile(
        id: 1052,
        name: 'tf_1052',
        completed: true,
        translations: [
          tFirstTranslatedTranslation,
          tSecondUncompletedTranslation
        ]
      );
      tFile1Translated = TranslationsFile(
        id: 1052,
        name: 'tf_1052',
        completed: true,
        translations: [
          tFirstTranslatedTranslation,
          tSecondTranslatedTranslation,
        ]
      );
      tFile2 = const TranslationsFile(
        id: 1053,
        name: 'tf_1053',
        completed: false,
        translations: [
          Translation(id: 1103, imgUrl: 'img_file_2_url', text: 'the translation text')
        ]
      );
      tTranslationsFilesInit = [
        tFile1Untranslated,
        tFile2
      ];
      tTranslationsFiles2 = [
        tFile2
      ];
      tTranslationsFilesEnd = [

      ];
      tPdfFile1 = PdfFile(
        id: tFile1Translated.id, 
        name: tFile1Translated.name, 
        parentId: 103, 
        url: 'pdf_url_1',
        canBeRead: true,
        canBeEdited: true,
        canBeDeleted: false
      );
      tPdfFile2 = PdfFile(
        id: tFile2.id, 
        name: tFile2.name,
        url: 'pdf_url_2', 
        parentId: 100,
        canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false
      );
      tFirstTranslationWithRemoteId = const Translation(
          id: 3052, text: tTranslationText1, imgUrl: 'url_1'
      );
      tSecondTranslationWithRemoteId = const Translation(
          id: 3053, text: tTranslationText2, imgUrl: 'url_2'
      );
      when(localDataSource.translating).thenReturn(false);
      final uncompletedTranslFilesResponses = [
        tTranslationsFilesInit,
        tTranslationsFiles2,
        tTranslationsFilesEnd
      ];
      when(localDataSource.getTranslationsFiles())
          .thenAnswer((_) async => uncompletedTranslFilesResponses.removeAt(0));
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => null);
      when(localDataSource.translate(any, any))
          .thenAnswer((_) async => tSecondTranslatedTranslation);
      when(remoteDataSource.addTranslation(any, any, any))
          .thenAnswer((_) async => tSecondTranslationWithRemoteId.id!);
      when(localDataSource.getTranslationsFile(tFile1Untranslated.id)).thenAnswer((_) async => tFile1Translated);
      when(localDataSource.getTranslationsFile(tFile2.id)).thenAnswer((_) async => tFile2);
      when(remoteDataSource.endTranslationFile(tFile1Translated.id, any)).thenAnswer((_) async => tPdfFile1);
      when(remoteDataSource.endTranslationFile(tFile2.id, any)).thenAnswer((_) async => tPdfFile2);
      when(userExtraInfoGetter.getAccessToken()).thenAnswer((_) async => tAccessToken);
    });

    
    test('should call the specified methods', () async {
      await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      verify(localDataSource.saveUncompletedTranslation(tPhotoUrl));
      verify(localDataSource.getTranslationsFiles()).called(2);
      verify(translationsFilesReceiver.setTranslationsFiles(tTranslationsFilesInit));
      verify(localDataSource.translating).called(2);

      verify(localDataSource.translate(tSecondUncompletedTranslation, tFile1Untranslated.id));
      verify(localDataSource.updateTranslation(tFile1Untranslated.id, tSecondTranslatedTranslation));
      verify(localDataSource.getCurrentCreatedFile()).called(2);
      verify(localDataSource.getTranslationsFile(tFile1Untranslated.id));
      verify(remoteDataSource.endTranslationFile(tFile1Translated.id, tAccessToken));
      verify(translationsFilesReceiver.setTranslationsFiles(tTranslationsFiles2));

      verify(localDataSource.getTranslationsFile(tFile2.id));
      verify(remoteDataSource.endTranslationFile(tFile2.id, tAccessToken));
      verify(localDataSource.removeTranslationsFile(tFile2));

      verify(remoteDataSource.addTranslation(tFile1Untranslated.id, tSecondTranslatedTranslation, tAccessToken));
      verify(userExtraInfoGetter.getAccessToken());
    });

    test('should return the expected result', () async {
      final result = await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      expect(result, const Right(null));
    });
  });
}

void _testCreateFolderGroup(){
  late String tName;
  late String tAccessToken;
  late int tFolderId;
  setUp((){
    tName = 'folder_name';
    tAccessToken = 'access_token';
    tFolderId = 10;
    when(userExtraInfoGetter.getAccessToken())
        .thenAnswer((_) async => tAccessToken);
    when(translFileParentFolderGetter.getCurrentFileId())
        .thenAnswer((_) async => tFolderId);
  });

  test('should call the specified methods', ()async{
    await photosTranslatorRepository.createFolder(tName);
    verify(translFileParentFolderGetter.getCurrentFileId());
    verify(remoteDataSource.createFolder(tName, tFolderId, tAccessToken));
  });

  test('should return the expected result when all goes good', ()async{
    final result = await photosTranslatorRepository.createFolder(tName);
    expect(result, const Right(null));
  });
}

void _testInitPendingTranslations(){
  late List<TranslationsFile> tUncompletedtranslationsFilesInit;

  group('when localDataSource is translating', () {
    setUp(() {
      tUncompletedtranslationsFilesInit = const [
        TranslationsFile(id: 0, name: 'f0', completed: false, translations: []),
        TranslationsFile(id: 1, name: 'f1', completed: false, translations: [])
      ];
      when(localDataSource.translating).thenReturn(true);
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => const TranslationsFile(id: 0, name: 'file_0', completed: false, translations: []));
      when(localDataSource.getTranslationsFiles()).thenAnswer((_) async => tUncompletedtranslationsFilesInit);
    });

    test('should call the specified methods', () async {
      await photosTranslatorRepository.initPendingTranslations();
      verify(localDataSource.translating);
      verify(translationsFilesReceiver.setTranslationsFiles(tUncompletedtranslationsFilesInit));
      verifyNever(localDataSource.getCurrentCreatedFile());
      verifyNever(localDataSource.translate(any, any));
      verifyNever(remoteDataSource.addTranslation(any, any, any));
      verifyNever(localDataSource.updateTranslation(any, any));
    });

    test('should return the expected result', () async {
      final result = await photosTranslatorRepository.initPendingTranslations();
      expect(result, const Right(null));
    });
  });

  group('when localDataSource is not translating, and there is an uncompleted file with one uncompleted translation', () {
    late String tAccessToken;
    late Translation tFirstUncompletedTranslation;
    late Translation tTranslatedTranslation;
    late TranslationsFile tUntranslatedFile;
    late TranslationsFile tTranslatedFile;
    late PdfFile tPdfFile;
    late Translation tTranslationWithRemoteId;
    late List<TranslationsFile> tUncompletedTranslationsFilesFin;
    setUp(() {
      tAccessToken = 'access_token';
      const translationText = 'translation_text';
      tFirstUncompletedTranslation = const Translation(id: 2052, text: null, imgUrl: 'url_1');
      tTranslatedTranslation = const Translation(
          id: 2052, 
          text: translationText, 
          imgUrl: 'url_1'
      );
      tTranslationWithRemoteId = const Translation(
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
        translations: [tTranslationWithRemoteId]
      );
      tPdfFile = const PdfFile(
        id: fileId, 
        name: fileName, 
        url: 'pdf_url', 
        parentId: 100,
        canBeRead: true,
        canBeEdited: true,
        canBeDeleted: false
      );
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => tUntranslatedFile);
      tUncompletedtranslationsFilesInit = [
        tUntranslatedFile
      ];
      tUncompletedTranslationsFilesFin = [];
      when(localDataSource.translating).thenReturn(false);
      final uncompletedTranslsFilesResponses = [
        tUncompletedtranslationsFilesInit,
        tUncompletedTranslationsFilesFin
      ];
      when(localDataSource.getTranslationsFiles())
        .thenAnswer( (_) async => uncompletedTranslsFilesResponses.removeAt(0));
      when(localDataSource.translate(any, any))
          .thenAnswer((_) async => tTranslatedTranslation);
      when(remoteDataSource.addTranslation(any, any, any))
          .thenAnswer((_) async => tTranslationWithRemoteId.id!);
      when(remoteDataSource.endTranslationFile(any, any))
          .thenAnswer((_) async =>  tPdfFile);
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => tTranslatedFile);
      when(localDataSource.getTranslationsFile(fileId)).thenAnswer((_) async => tTranslatedFile);
      when(userExtraInfoGetter.getAccessToken()).thenAnswer((_) async => tAccessToken);
    });

    test('should call the specified methods', () async {
      await photosTranslatorRepository.initPendingTranslations();
      verify(localDataSource.translating);
      verify(localDataSource.getTranslationsFiles()).called(2);
      verify(localDataSource.translate(
        tUntranslatedFile.translations.first,
        tUntranslatedFile.id
      ));
      verify(localDataSource.updateTranslation(
        tUntranslatedFile.id, 
        tTranslatedTranslation
      ));
      verify(userExtraInfoGetter.getAccessToken());
      verify(remoteDataSource.addTranslation(
        tUntranslatedFile.id, 
        tTranslatedTranslation,
        tAccessToken
      ));
      verify(translationsFilesReceiver.setTranslationsFiles(tUncompletedtranslationsFilesInit));
      verify(translationsFilesReceiver.setTranslationsFiles(tUncompletedTranslationsFilesFin));
      verifyNever(remoteDataSource.endTranslationFile(any, any));
    });

    test('should return the expected result', () async {
      final result = await photosTranslatorRepository.initPendingTranslations();
      expect(result, const Right(null));
    });
  });
}

void _testPickPdfGroup(){
  late String tAccessToken;
  setUp((){
    tAccessToken = 'access_token';
    when(userExtraInfoGetter.getAccessToken())
        .thenAnswer((_) async => tAccessToken);
  });

  group('when all goes good', (){
    late MockFile tPdf;
    setUp((){
      tPdf = MockFile();
      when(tPdf.path)
          .thenReturn('pdf_path');
      when(localDataSource.pickPdf())
          .thenAnswer((_) async => tPdf);
    });
    test('should call the specified methods', ()async{
      await photosTranslatorRepository.pickFile();
      verify(localDataSource.pickPdf());
    });

    test('should return the expected result', ()async{
      final result = await photosTranslatorRepository.pickFile();
      expect(result, Right(tPdf));
    });
  });

  test('should return the expected result when there is an AppException', ()async{
    const errorMessage = 'error_message';
    const exception = StorageException(
      type: StorageExceptionType.EMPTYDATA,
      message: errorMessage
    );
    when(localDataSource.pickPdf())
        .thenThrow(exception);
    final result = await photosTranslatorRepository.pickFile();
    expect(result, const Left(PhotosTranslatorFailure(
      exception: exception,
      message: errorMessage
    )));
  });

  test('should return the expected result when there is another Exception', ()async{
    when(localDataSource.pickPdf())
        .thenThrow(Exception());
    final result = await photosTranslatorRepository.pickFile();
    expect(result, const Left(PhotosTranslatorFailure(
      exception: AppException(''),
      message: ''
    )));
  });
}

void _testCreatePdfFileGroup(){
  late String tName;
  late MockFile tPdf;
  late int tParentId;
  late String tAccessToken;
  
  setUp((){
    tName = 'file_name';
    tPdf = MockFile();
    tParentId = 1000;
    tAccessToken = 'access_token';
    when(tPdf.path)
        .thenReturn('pdf_path');
    when(translFileParentFolderGetter.getCurrentFileId())
        .thenAnswer((_) async => tParentId);
    when(userExtraInfoGetter.getAccessToken())
        .thenAnswer((_) async => tAccessToken);
  });

  test('should call the specified methods', ()async{
    await photosTranslatorRepository.createPdfFile(tName, tPdf);
    verify(translFileParentFolderGetter.getCurrentFileId());
    verify(userExtraInfoGetter.getAccessToken());
    verify(remoteDataSource.createPdfFile(tName, tPdf, tParentId, tAccessToken));
  });

  test('should return the expected result when all goes good', ()async{
    final result = await photosTranslatorRepository.createPdfFile(tName, tPdf);
    expect(result, const Right(null));
  });

  test('should return the expected result when there is an AppException', ()async{
    const errorMessage = 'error_message';
    const exception = StorageException(
      type: StorageExceptionType.EMPTYDATA,
      message: errorMessage
    );
    when(remoteDataSource.createPdfFile(any, any, any, any))
        .thenThrow(exception);
    final result = await photosTranslatorRepository.createPdfFile(tName, tPdf);
    expect(result, const Left(PhotosTranslatorFailure(
      exception: exception,
      message: errorMessage
    )));
  });

  test('should return the expected result when there is another Exception', ()async{
    when(remoteDataSource.createPdfFile(any, any, any, any))
        .thenThrow(Exception());
    final result = await photosTranslatorRepository.createPdfFile(tName, tPdf);
    expect(result, const Left(PhotosTranslatorFailure(
      exception: AppException(''),
      message: ''
    )));
  });
}