import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/external/translations_file_parent_folder_getter.dart';
import 'package:vido/core/external/user_extra_info_getter.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_local_data_source.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_remote_data_source.dart';
import 'package:vido/features/photos_translator/data/repository/photos_translator_repository_impl.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
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

  group('create translations file', _testCreatetranslationsFileGroup);
  group('end photos translation file', _testEndPhotosTranslationFileGroup);
  group('translate photo', _testTranslatePhotoGroup);
  group('create folder', _testCreateFolderGroup);
  group('init pending translations', _testInitPendingTranslations);
}

void _testCreatetranslationsFileGroup() {
  late TranslationsFile tNewFile;
  late String tName;
  late String tAccessToken;
  late int tParentFolderId;

  group('when the proccess type is ocr', (){
    setUp(() {
      tName = 'new_name';
      tAccessToken = 'access_token';
      tNewFile = TranslationsFile(
        id: 0, 
        name: tName, 
        completed: false, 
        translations: const [],
        proccessType: TranslationProccessType.ocr
      );
      tParentFolderId = 10;
      when(userExtraInfoGetter.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.createTranslationsFile(any, any, any))
          .thenAnswer((_) async => tNewFile);
      when(translFileParentFolderGetter.getCurrentFileId())
          .thenAnswer((_) async => tParentFolderId);
    });

    test('should call the specified methods', () async {
      await photosTranslatorRepository.createTranslationsFile(tName, TranslationProccessType.ocr);
      verify(userExtraInfoGetter.getAccessToken());
      verify(remoteDataSource.createTranslationsFile(tName, tParentFolderId, tAccessToken));
      verify(localDataSource.createTranslationsFile(tNewFile));
    });

    test('should return the expected result', () async {
      final result = await photosTranslatorRepository.createTranslationsFile(tName, TranslationProccessType.ocr);
      expect(result, Right(tNewFile.id));
    });
  });

  group('when the proccess type is icr', (){
    setUp(() {
      tName = 'new_name';
      tAccessToken = 'access_token';
      tNewFile = TranslationsFile(
        id: 1,
        name: tName, 
        completed: false, 
        translations: const [],
        proccessType: TranslationProccessType.icr
      );
      tParentFolderId = 10;
      when(userExtraInfoGetter.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.createTranslationsFile(any, any, any))
          .thenAnswer((_) async => tNewFile);
      when(translFileParentFolderGetter.getCurrentFileId())
          .thenAnswer((_) async => tParentFolderId);
    });

    test('should call the specified methods', () async {
      await photosTranslatorRepository.createTranslationsFile(tName, TranslationProccessType.icr);
      verify(userExtraInfoGetter.getAccessToken());
      verify(remoteDataSource.createTranslationsFile(tName, tParentFolderId, tAccessToken));
      verify(localDataSource.createTranslationsFile(tNewFile));
    });

    test('should return the expected result', () async {
      final result = await photosTranslatorRepository.createTranslationsFile(tName, TranslationProccessType.icr);
      expect(result, Right(tNewFile.id));
    });
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

  group('when localDataSource is translating', () {
    setUp(() {
      tUncompletedtranslationsFilesInit = const [
        TranslationsFile(
          id: 0, 
          name: 'f0', 
          completed: false, 
          translations: [],
          proccessType: TranslationProccessType.ocr
        ),
        TranslationsFile(
          id: 1, 
          name: 'f1', 
          completed: false, 
          translations: [],
          proccessType: TranslationProccessType.icr
        )
      ];
      when(localDataSource.translating).thenReturn(true);
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => const TranslationsFile(
        id: 0, 
        name: 'file_0', 
        completed: false, 
        translations: [],
        proccessType: TranslationProccessType.ocr
      ));
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
        translations: [tFirstUncompletedTranslation],
        proccessType: TranslationProccessType.ocr
      );
      tTranslatedFile = TranslationsFile(
        id: fileId,
        name: fileName,
        completed: true,
        translations: [tTranslationWithRemoteId],
        proccessType: TranslationProccessType.ocr
      );
      tPdfFile = const PdfFile(id: fileId, name: fileName, url: 'pdf_url', parentId: 100);
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
    late TranslationsFile tUntranslatedFile1;
    late TranslationsFile tTranslatedFile1;
    late TranslationsFile tUntranslatedFile2;
    late TranslationsFile tTranslatedFile2;
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
      
      tUntranslatedFile1 = TranslationsFile(
        id: 1052,
        name: 'tf_1052',
        completed: true,
        translations: [
          const Translation(id: 2050, text: 'text_x', imgUrl: 'url_0'),
          tFirstUncompletedTranslation,
        ],
        proccessType: TranslationProccessType.icr
      );
      tTranslatedFile1 = TranslationsFile(
        id: 1052,
        name: 'tf_1052',
        completed: true,
        translations: [
          const Translation(id: 2050, text: 'text_x', imgUrl: 'url_0'),
          tFirstTranslatedTranslation,
        ],
        proccessType: TranslationProccessType.icr
      );
      
      tUntranslatedFile2 = TranslationsFile(
        id: 1053,
        name: 'tf_1053',
        completed: false,
        translations: [tSecondUncompletedTranslation],
        proccessType: TranslationProccessType.ocr
      );
      tTranslatedFile2 = const TranslationsFile(
        id: 1053,
        name: 'tf_1053',
        completed: true,
        translations: [
          Translation(id: 2053, text: 'text_xxx', imgUrl: 'url_2')
        ],
        proccessType: TranslationProccessType.ocr
      );
      tUncompletedtranslationsFilesInit = [
        tUntranslatedFile1,
        tUntranslatedFile2
      ];
      tUncompletedtranslationsFiles2 = [
        TranslationsFile(
          id: 1052,
          name: 'tf_1052',
          completed: true,
          translations: [
            const Translation(id: 2050, text: 'text_x', imgUrl: 'url_0'),
            tFirstTranslatedTranslation
          ],
          proccessType: TranslationProccessType.icr
        ),
        tUntranslatedFile2
      ];
      tUncompletedtranslationsFilesFin = [
        TranslationsFile(
          id: 1052,
          name: 'tf_1052',
          completed: true,
          translations: [
            const Translation(id: 2050, text: 'text_x', imgUrl: 'url_0'),
            tFirstTranslatedTranslation
          ],
          proccessType: TranslationProccessType.icr
        ),
      ];
      tCompletedFile = PdfFile(id: tTranslatedFile2.id, name: tTranslatedFile2.name, url: 'pdf_url', parentId: 100);
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
      final currentCreatedFileResponses = [
        tTranslatedFile1,
        tTranslatedFile1
      ];
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => currentCreatedFileResponses.removeAt(0));

      when(localDataSource.translate(any, tUntranslatedFile2.id))
          .thenAnswer((_) async => tSecondTranslatedTranslation);
      final addTranslationResponses = [
        tFirstTranslationWithRemoteId.id!,
        tSecondTranslationWithRemoteId.id!
      ];
      when(remoteDataSource.addTranslation(any, any, any))
          .thenAnswer((_) async => addTranslationResponses.removeAt(0));
      when(remoteDataSource.translateWithIcr(any, any, any))
          .thenAnswer((_) async => tFirstTranslatedTranslation);
      when(localDataSource.getTranslationsFile(tUntranslatedFile1.id)).thenAnswer((_) async => tTranslatedFile1);
      when(localDataSource.getTranslationsFile(tUntranslatedFile2.id)).thenAnswer((_) async => tTranslatedFile2);
      when(remoteDataSource.endTranslationFile(any, any)).thenAnswer((_) async => tCompletedFile);
      when(userExtraInfoGetter.getAccessToken()).thenAnswer((_) async => tAccessToken);
    });

    test('should call the specified methods', () async {
      await photosTranslatorRepository.translatePhoto(tPhotoUrl);
      verify(localDataSource.saveUncompletedTranslation(tPhotoUrl));
      verify(localDataSource.translating).called(3);
      verify(localDataSource.getTranslationsFiles()).called(3);
      verify(translationsFilesReceiver.setTranslationsFiles(tUncompletedtranslationsFilesInit));

      verifyNever(localDataSource.translate(tFirstUncompletedTranslation, tUntranslatedFile1.id));
      verify(remoteDataSource.translateWithIcr(tUntranslatedFile1.id, tFirstUncompletedTranslation.imgUrl, tAccessToken));
      verify(localDataSource.updateTranslation(tUntranslatedFile1.id, tFirstTranslatedTranslation));
      verify(localDataSource.getCurrentCreatedFile()).called(2);
      verify(localDataSource.getTranslationsFile(tUntranslatedFile1.id));
      verifyNever(remoteDataSource.endTranslationFile(tUntranslatedFile1.id, tAccessToken));
      verify(translationsFilesReceiver.setTranslationsFiles(tUncompletedtranslationsFiles2));

      verify(localDataSource.translate(tSecondUncompletedTranslation, tUntranslatedFile2.id));
      verify(localDataSource.updateTranslation(tUntranslatedFile2.id, tSecondTranslatedTranslation));
      verify(localDataSource.getTranslationsFile(tUntranslatedFile2.id));
      verify(remoteDataSource.endTranslationFile(tUntranslatedFile2.id, tAccessToken));
      verify(localDataSource.removeTranslationsFile(tTranslatedFile2));
      verify(translationsFilesReceiver.setTranslationsFiles(tUncompletedtranslationsFilesFin));

      verifyNever(remoteDataSource.addTranslation(tUntranslatedFile1.id, tFirstTranslatedTranslation, tAccessToken));
      verify(remoteDataSource.addTranslation(tUntranslatedFile2.id, tSecondTranslatedTranslation, tAccessToken));
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
        TranslationsFile(
          id: 0, 
          name: 'f0', 
          completed: false, 
          translations: [],
          proccessType: TranslationProccessType.ocr
        ),
        TranslationsFile(
          id: 1, 
          name: 'f1', 
          completed: false, 
          translations: [],
          proccessType: TranslationProccessType.ocr
        )
      ];
      when(localDataSource.translating).thenReturn(true);
      when(localDataSource.getCurrentCreatedFile()).thenAnswer((_) async => const TranslationsFile(
        id: 0, 
        name: 'file_0', 
        completed: false, 
        translations: [],
        proccessType: TranslationProccessType.ocr
      ));
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
        translations: [tFirstUncompletedTranslation],
        proccessType: TranslationProccessType.ocr
      );
      tTranslatedFile = TranslationsFile(
        id: fileId,
        name: fileName,
        completed: true,
        translations: [tTranslationWithRemoteId],
        proccessType: TranslationProccessType.ocr
      );
      tPdfFile = const PdfFile(id: fileId, name: fileName, url: 'pdf_url', parentId: 100);
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