import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/external/persistence.dart';
import 'package:vido/core/external/photos_translator.dart';
import 'package:vido/core/utils/image_rotation_fixer.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/external/photos_translator_local_adapter.dart';
import 'package:vido/features/photos_translator/external/photos_translator_local_data_source_impl.dart';
import 'photos_translator_local_data_source_test.mocks.dart';

late PhotosTranslatorLocalDataSourceImpl localDataSource;
late MockPhotosTranslatorLocalAdapter adapter;
late MockDatabaseManager persistenceManager;
late MockPhotosTranslator translator;
late MockImageRotationFixer rotationFixer;

@GenerateMocks([
  PhotosTranslatorLocalAdapter,
  DatabaseManager,
  PhotosTranslator,
  ImageRotationFixer,
  File
])
void main(){
  setUp((){
    rotationFixer = MockImageRotationFixer();
    translator = MockPhotosTranslator();
    persistenceManager = MockDatabaseManager();
    adapter = MockPhotosTranslatorLocalAdapter();
    localDataSource = PhotosTranslatorLocalDataSourceImpl(
      adapter: adapter,
      persistenceManager: persistenceManager,
      translator: translator,
      rotationFixer: rotationFixer
    );
  });

  group('add pdf file', _testAddPdfFileGroup);
  group('create translations file', _testCreateTranslationsFileGroup);
  group('end translations file creation', _testEndTranslationsFileCreationGroup);
  group('get current created file', _testGetCurrentCreatedFileGroup);
  group('get pdf files', _testGetPdfFilesGroup);
  group('get translations files', _testGetTranslationsFilesGroup);
  group('get translations file', _testGetTranslationsFileGroup);
  group('remove translations file', _testRemoveTranslationsFileGroup);
  group('save uncompleted translation', _testSaveUncompletedTranslationGroup);
  group('update pdf files', _testUpdatePdfFilesGroup);
  group('translate', _testTranslateGroup);
  group('update translation', _testUpdateTranslationGroup);
}

void _testAddPdfFileGroup(){
  late PdfFile tPdfFile;
  late Map<String, dynamic> tFileJson;
  setUp((){
    tPdfFile = const PdfFile(id: 0, name: 'f1', url: 'url_1');
    tFileJson = {
      'id': 0,
      'name': 'f1',
      'url': 'url_1'
    };
    when(adapter.getJsonFromPdfFile(any)).thenReturn(tFileJson);
    when(persistenceManager.insert(any, any)).thenAnswer((_) async => 1);
  });

  test('should call the specified methods', ()async{
    await localDataSource.addPdfFile(tPdfFile);
    verify(adapter.getJsonFromPdfFile(tPdfFile));
    verify(persistenceManager.insert(pdfFilesTableName, tFileJson));
  });
}

void _testCreateTranslationsFileGroup(){
  late TranslationsFile tFile;
  late Map<String, dynamic> tFileJson;
  setUp((){
    tFile = const TranslationsFile(id: 0, name: 't_f_1', status: TranslationsFileStatus.sending, translations: [], completed: false);
    tFileJson = {
      'id': 0,
      'name': 't_f_1',
      'translations': [],
      'completed': false
    };
    when(adapter.getJsonFromTranslationsFile(any)).thenReturn(tFileJson);
    when(persistenceManager.insert(any, any)).thenAnswer((_) async => 0);
  });

  test('should call the specified methods', ()async{
    await localDataSource.createTranslationsFile(tFile);
    verify(adapter.getJsonFromTranslationsFile(tFile));
    verify(persistenceManager.insert(translFilesTableName, tFileJson));
  });
}

void _testEndTranslationsFileCreationGroup(){
  late int tFileId;
  late TranslationsFile tOnCreationFile;
  late Map<String, dynamic> tOnCreationFileJson;
  late TranslationsFile tCreatedFile;
  late Map<String, dynamic> tCreatedFileJson;
  setUp((){
    tFileId = 0;
    tOnCreationFile = TranslationsFile(id: tFileId, name: 'f_1', status: TranslationsFileStatus.creating, translations: [], completed: true);
    tOnCreationFileJson = {
      idKey: tFileId,
      translFilesNameKey: 'f_1',
      translFilesStatusKey: translFileStatusOnCreationValue
    };
    tCreatedFile = TranslationsFile(id: tFileId, name: 'f_1', status: TranslationsFileStatus.created, completed: true, translations: []);
    tCreatedFileJson =  {
      idKey: tFileId,
      translFilesNameKey: 'f_1',
      translFilesStatusKey: translFileStatusCreatedValue
    };
    when(persistenceManager.queryWhere(any, any, any)).thenAnswer((_) async => [tOnCreationFileJson]);
    when(adapter.getTranslationsFileFromJson(any, any)).thenReturn(tOnCreationFile);
    when(adapter.getJsonFromTranslationsFile(any)).thenReturn(tCreatedFileJson);
  });

  test('should call the specified methods', ()async{
    await localDataSource.endTranslationsFileCreation();
    verify(persistenceManager.queryWhere(
      translFilesTableName, 
      '$translFilesStatusKey = ?', 
      [translFileStatusOnCreationValue]
    ));
    verify(adapter.getTranslationsFileFromJson(tOnCreationFileJson, []));
    verify(adapter.getJsonFromTranslationsFile(tCreatedFile));
    verify(persistenceManager.update(translFilesTableName, tCreatedFileJson, tFileId));
  });
}

void _testGetCurrentCreatedFileGroup(){
  late Map<String, dynamic>? tFileJson;
  late TranslationsFile? tFile;

  group('when already there is a current created file', (){
    late List<Map<String, dynamic>> tTranslationsJson;
    late List<Translation> tTranslations;
    setUp((){
      tTranslationsJson = const [
        {
          idKey: 100,
          translationsImgUrlKey: 'url_1',
          translationsTextKey: 't'
        },
        {
          idKey: 101,
          translationsImgUrlKey: 'url_2',
          translationsTextKey: null
        }
      ];
      tTranslations = const [
        Translation(id: 100, imgUrl: 'url_1', text: 't'),
        Translation(id: 101, imgUrl: 'url_2', text: null)
      ];
      tFileJson = {
        idKey: 0,
        translFilesNameKey: 'f_1',
        translFilesStatusKey: translFileStatusOnCreationValue
      };
      tFile = TranslationsFile(id: 0, name: 'f_1', completed: false, translations: tTranslations, status: TranslationsFileStatus.creating);
      when(persistenceManager.queryWhere(translFilesTableName, any, any)).thenAnswer((_) async => [tFileJson!]);
      when(persistenceManager.queryWhere(translationsTableName, any, any)).thenAnswer((_) async => tTranslationsJson);
      when(adapter.getTranslationsFileFromJson(any, any)).thenReturn(tFile!);
    });
    test('shold call the specified methods', ()async{
      await localDataSource.getCurrentCreatedFile();
      verify(persistenceManager.queryWhere(translFilesTableName, '$translFilesStatusKey = ?', [translFileStatusOnCreationValue]));
      verify(adapter.getTranslationsFileFromJson(tFileJson, tTranslationsJson));
    });
    
    test('should return the expected result', ()async{
      final result = await localDataSource.getCurrentCreatedFile();
      expect(result, tFile);
    });
  });
  
  group('when there is not any current created file', (){
    setUp((){
      tFileJson = null;
      tFile = null;
      when(persistenceManager.queryWhere(any, any, any)).thenAnswer((_) async => []);
    });

    test('should call the specified methods', ()async{
      await localDataSource.getCurrentCreatedFile();
      verify(persistenceManager.queryWhere(translFilesTableName, '$translFilesStatusKey = ?', [translFileStatusOnCreationValue]));
      verifyNever(adapter.getTranslationsFileFromJson(any, any));
    });

    test('should return the expected result', ()async{
      final result = await localDataSource.getCurrentCreatedFile();
      expect(result, tFile);
    });
  });
}

void _testGetPdfFilesGroup(){
  late List<Map<String, dynamic>> tFilesJson;
  late List<PdfFile> tFiles;
  setUp((){
    tFilesJson = [
      {
        idKey: 0,
        pdfFilesNameKey: 'f_1',
        pdfFilesUrlKey: 'url_1'
      },
      {
        idKey: 1,
        pdfFilesNameKey: 'f_2',
        pdfFilesUrlKey: 'url_2'
      }
    ];
    tFiles = const [
      PdfFile(id: 0, name: 'f_1', url: 'url_1'),
      PdfFile(id: 1, name: 'f_2', url: 'url_2')
    ];
    when(persistenceManager.queryAll(any)).thenAnswer((_) async => tFilesJson);
    when(adapter.getPdfFilesFromJson(any)).thenReturn(tFiles);
  });

  test('should call the specified methods', ()async{
    await localDataSource.getPdfFiles();
    verify(persistenceManager.queryAll(pdfFilesTableName));
    verify(adapter.getPdfFilesFromJson(tFilesJson));
  });

  test('should return the expected result', ()async{
    final result = await localDataSource.getPdfFiles();
    expect(result, tFiles);
  });
}

void _testGetTranslationsFilesGroup(){
  late List<Map<String, dynamic>> tFilesJson;
  late List<Map<String, dynamic>> tFirstFileTranslationsJson;
  late List<Translation> tFirstFileTranslations;
  late List<Map<String, dynamic>> tSecondFileTranslationsJson;
  late List<Translation> tSecondFileTranslations;
  late List<TranslationsFile> tFiles;
  setUp((){
    tFilesJson = [
      {
        idKey: 0,
        translFilesNameKey: 'name_1',
        translFilesStatusKey: translFileStatusCreatedValue
      },
      {
        idKey: 1,
        translFilesNameKey: 'name_2',
        translFilesStatusKey: translFileStatusSendingValue
      }
    ];
    tFirstFileTranslationsJson = [
      {
        idKey: 100,
        translationsImgUrlKey: 'url_1',
        translationsTextKey: null
      }
    ];
    tFirstFileTranslations = const [
       Translation(id: 100, imgUrl: 'url_1', text: null)
    ];
    tSecondFileTranslationsJson = [
      {
        idKey: 101,
        translationsImgUrlKey: 'url_2',
        translationsTextKey: null
      },
      {
        idKey: 102,
        translationsImgUrlKey: 'url_3',
        translationsTextKey: 'text_3'
      }
    ];
    tSecondFileTranslations = const [
      Translation(id: 101, imgUrl: 'url_2', text: null),
      Translation(id: 102, imgUrl: 'url_3', text: 'text_3')
    ];
    tFiles = [
      TranslationsFile(id: 0, name: 'name_1', completed: false, translations: tFirstFileTranslations, status: TranslationsFileStatus.created),
      TranslationsFile(id: 1, name: 'name_2', completed: false, translations: tSecondFileTranslations, status: TranslationsFileStatus.sending)
    ];
    when(persistenceManager.queryWhere(translationsTableName, any, [tFiles[0].id])).thenAnswer((_) async => tFirstFileTranslationsJson);
    when(persistenceManager.queryWhere(translationsTableName, any, [tFiles[1].id])).thenAnswer((_) async => tSecondFileTranslationsJson);
    when(persistenceManager.queryAll(any)).thenAnswer((_) async => tFilesJson);
    when(adapter.getTranslationsFilesFromJson(any, any)).thenReturn(tFiles);
  });

  test('should call the specified methods', ()async{
    await localDataSource.getTranslationsFiles();
    verify(persistenceManager.queryAll(translFilesTableName));
    verify(persistenceManager.queryWhere(translationsTableName, '$translationsFileIdKey = ?', [tFiles[0].id]));
    verify(persistenceManager.queryWhere(translationsTableName, '$translationsFileIdKey = ?', [tFiles[1].id]));
    verify(adapter.getTranslationsFilesFromJson(tFilesJson, [tFirstFileTranslationsJson, tSecondFileTranslationsJson]));
  });

  test('should return the expected result', ()async{
    final result = await localDataSource.getTranslationsFiles();
    expect(result, tFiles);
  });
}

void _testGetTranslationsFileGroup(){
  late int tFileId;
  late Map<String, dynamic> tFileJson;
  late List<Map<String, dynamic>> tTranslationsJson;
  late List<Translation> tTranslations;
  late TranslationsFile tFile;

  setUp((){
    tFileId = 0;
    tFileJson = {
      idKey: tFileId,
      translFilesNameKey: 'name_1',
      translFilesStatusKey: translFileStatusCreatedValue
    };
    tTranslationsJson = [
      {
        idKey: 100,
        translationsImgUrlKey: 'url_1',
        translationsTextKey: null
      }
    ];
    tTranslations = const [
      Translation(id: 100, imgUrl: 'url_1', text: null)
    ];
    tFile = TranslationsFile(id: tFileId, name: 'name_1', completed: false, translations: tTranslations, status: TranslationsFileStatus.created);
    when(persistenceManager.querySingleOne(any, any)).thenAnswer((_) async => tFileJson);
    when(persistenceManager.queryWhere(translationsTableName, any, any)).thenAnswer((_) async => tTranslationsJson);
    when(adapter.getTranslationsFileFromJson(any, any)).thenAnswer((realInvocation) => tFile);
  });

  test('should call the speified methods', ()async{
    await localDataSource.getTranslationsFile(tFileId);
    verify(persistenceManager.querySingleOne(translFilesTableName, tFile.id));
    verify(persistenceManager.queryWhere(translationsTableName, '$translationsFileIdKey = ?', [tFile.id]));
    verify(adapter.getTranslationsFileFromJson(tFileJson, tTranslationsJson));
  });

  test('should return the expected result', ()async{
    final result = await localDataSource.getTranslationsFile(tFileId);
    expect(result, tFile);
  });
}

void _testRemoveTranslationsFileGroup(){
  late TranslationsFile tFile;
  setUp((){
    tFile = const TranslationsFile(id: 0, name: 'file_1', completed: false, translations: [], status: TranslationsFileStatus.sending);
  });

  test('shold call the specified methods', () async {
    await localDataSource.removeTranslationsFile(tFile);
    verify(persistenceManager.remove(translFilesTableName, tFile.id));
  });
}

void _testSaveUncompletedTranslationGroup(){
  late int tCreatedFileId;
  late String tImgUrl;
  late Translation tTranslation;
  late Map<String, dynamic> tCreatedFileJson;
  late TranslationsFile tCreatedFile;
  late Map<String, dynamic> tTranslationJson;
  setUp((){
    tCreatedFileId = 0;
    tImgUrl = 'img_url';
    tTranslation = Translation(id: null, imgUrl: tImgUrl, text: null);
    tCreatedFileJson = {
      idKey: tCreatedFileId,
      translFilesNameKey: 'f_1',
      translFilesStatusKey: translFileStatusOnCreationValue
    };
    tCreatedFile = TranslationsFile(id: tCreatedFileId, name: 'f_1', completed: false, translations: [], status: TranslationsFileStatus.creating);
    tTranslationJson = {
      idKey: null,
      translationsImgUrlKey: tImgUrl,
      translationsTextKey: null,
      translationsFileIdKey: tCreatedFileId
    };
    when(persistenceManager.queryWhere(any, any, any)).thenAnswer((_) async => [tCreatedFileJson]);
    when(adapter.getTranslationsFileFromJson(any, any)).thenReturn(tCreatedFile);
    when(adapter.getJsonFromTranslation(any, any)).thenReturn(tTranslationJson);
    when(persistenceManager.insert(any, any)).thenAnswer((_) async => 1);
  });

  test('shold call the specified methods', ()async{
    await localDataSource.saveUncompletedTranslation(tImgUrl);
    verify(persistenceManager.queryWhere(translFilesTableName, '$translFilesStatusKey = ?', [translFileStatusOnCreationValue]));
    verify(adapter.getTranslationsFileFromJson(tCreatedFileJson, []));
    verify(adapter.getJsonFromTranslation(tTranslation, tCreatedFileId));
    verify(persistenceManager.insert(translationsTableName, tTranslationJson));
  });
}

void _testUpdatePdfFilesGroup(){
  late List<PdfFile> tNewFiles;
  late List<Map<String, dynamic>> tNewFilesJson;

  group('when there are 2 new files', (){
    setUp((){
      tNewFiles = const [
        PdfFile(id: 0, name: 'f_1', url: 'url_1'),
        PdfFile(id: 1, name: 'f_2', url: 'url_2')
      ];
      tNewFilesJson = [
        {
          idKey: 0,
          pdfFilesNameKey: 'f_1',
          pdfFilesUrlKey: 'url_1'
        },
        {
          idKey: 1,
          pdfFilesNameKey: 'f_2',
          pdfFilesUrlKey: 'url_2'
        }
      ];
      when(adapter.getJsonFromPdfFiles(any)).thenReturn(tNewFilesJson);
      final insertValues = [0, 1];
      when(persistenceManager.insert(any, any)).thenAnswer((_) async => insertValues.removeAt(0));
    });
    
    test('shold call the specified methods', ()async{
      await localDataSource.updatePdfFiles(tNewFiles);
      verify(adapter.getJsonFromPdfFiles(tNewFiles));
      verify(persistenceManager.removeAll(pdfFilesTableName));
      verify(persistenceManager.insert(pdfFilesTableName, tNewFilesJson[0]));
      verify(persistenceManager.insert(pdfFilesTableName, tNewFilesJson[1]));
    });
  });

  group('when there are 3 new files', (){
    setUp((){
      tNewFiles = const [
        PdfFile(id: 0, name: 'f_1', url: 'url_1'),
        PdfFile(id: 1, name: 'f_2', url: 'url_2'),
        PdfFile(id: 1, name: 'f_3', url: 'url_3')
      ];
      tNewFilesJson = [
        {
          idKey: 0,
          pdfFilesNameKey: 'f_1',
          pdfFilesUrlKey: 'url_1'
        },
        {
          idKey: 1,
          pdfFilesNameKey: 'f_2',
          pdfFilesUrlKey: 'url_2'
        },
        {
          idKey: 2,
          pdfFilesNameKey: 'f_3',
          pdfFilesUrlKey: 'url_3'
        }
      ];
      when(adapter.getJsonFromPdfFiles(any)).thenReturn(tNewFilesJson);
      final insertValues = [0, 1, 2];
      when(persistenceManager.insert(any, any)).thenAnswer((_) async => insertValues.removeAt(0));
    });

    test('shold call the specified methods', ()async{
      await localDataSource.updatePdfFiles(tNewFiles);
      verify(adapter.getJsonFromPdfFiles(tNewFiles));
      verify(persistenceManager.removeAll(pdfFilesTableName));
      verify(persistenceManager.insert(pdfFilesTableName, tNewFilesJson[0]));
      verify(persistenceManager.insert(pdfFilesTableName, tNewFilesJson[1]));
      verify(persistenceManager.insert(pdfFilesTableName, tNewFilesJson[2]));
    });
  });
}

void _testTranslateGroup(){
  late int tFileId;
  late int tTranslationId;
  late String tImgUrlInit;
  late Translation tTranslationInit;
  late String tImgUrlUpdated;
  late MockFile tFixedImage;
  late String tTranslationText;
  late Translation tTranslationUpdated;
  late Map<String, dynamic> tTranslationUpdatedJson;
  setUp((){
    tFileId = 0;
    tTranslationId = 100;
    tImgUrlInit = 'img_url_1';
    tTranslationInit = Translation(id: tTranslationId, imgUrl: tImgUrlInit, text: null);
    tTranslationText = 'translation';
    tImgUrlUpdated = 'img_url_2';
    tFixedImage = MockFile();
    tTranslationUpdated = Translation(id: tTranslationId, imgUrl: tImgUrlUpdated, text: tTranslationText);
    tTranslationUpdatedJson = {
      idKey: tTranslationId,
      translationsImgUrlKey: tImgUrlUpdated,
      translationsTextKey: tTranslationText,
      translationsFileIdKey: tFileId
    };
    when(tFixedImage.path).thenReturn(tImgUrlUpdated);
    when(rotationFixer.fix(any)).thenAnswer((_) async => File(tImgUrlUpdated));
    when(translator.translate(any)).thenAnswer((_) async => tTranslationText);
    when(adapter.getJsonFromTranslation(any, any)).thenReturn(tTranslationUpdatedJson);
  });

  test('shold call the specified methods', ()async{
    await localDataSource.translate(tTranslationInit, tFileId);
    verify(rotationFixer.fix(tTranslationInit.imgUrl));
    verify(translator.translate(tTranslationInit.imgUrl));
  });

  test('shold return the expected result', ()async{
    final result = await localDataSource.translate(tTranslationInit, tFileId);
    expect(result, tTranslationUpdated);
  });
}

void _testUpdateTranslationGroup(){
  late int tFileId;
  late Translation tTranslationUpdated;
  late Map<String, dynamic> tTranslationUpdatedJson;
  setUp((){
    tFileId = 0;
    tTranslationUpdated = const Translation(id: 100, imgUrl: 'img_url', text: 'translation_text');
    tTranslationUpdatedJson = {
      idKey: 100,
      translationsImgUrlKey: 'img_url',
      translationsTextKey: 'translation_text',
      translationsFileIdKey: tFileId
    };
    when(adapter.getJsonFromTranslation(any, any)).thenReturn(tTranslationUpdatedJson);
  });

  test('should call the specified methods', ()async{
    await localDataSource.updateTranslation(tFileId, tTranslationUpdated);
    verify(adapter.getJsonFromTranslation(tTranslationUpdated, tFileId));
    verify(persistenceManager.update(translationsTableName, tTranslationUpdatedJson, tTranslationUpdated.id));
  });
}