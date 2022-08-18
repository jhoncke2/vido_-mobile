
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/external/persistence.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/external/photos_translator_local_adapter.dart';
import 'package:vido/features/photos_translator/external/photos_translator_local_data_source_impl.dart';
import 'photos_translator_local_data_source_test.mocks.dart';

late PhotosTranslatorLocalDataSourceImpl localDataSource;
late MockPhotosTranslatorLocalAdapter adapter;
late MockPersistenceManager persistenceManager;

@GenerateMocks([
  PhotosTranslatorLocalAdapter,
  PersistenceManager
])
void main(){
  setUp((){
    persistenceManager = MockPersistenceManager();
    adapter = MockPhotosTranslatorLocalAdapter();
    localDataSource = PhotosTranslatorLocalDataSourceImpl(
      adapter: adapter,
      persistenceManager: persistenceManager
    );
  });

  group('add pdf file', _testAddPdfFileGroup);
  group('create translations file', _testCreateTranslationsFileGroup);
  group('end translations file creation', _testEndTranslationsFileCreationGroup);
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
  late TranslationsFile tOnCreationFile;
  late Map<String, dynamic> tOnCreationFileJson;
  late TranslationsFile tCreatedFile;
  late Map<String, dynamic> tCreatedFileJson;
  setUp((){
    tOnCreationFile = const TranslationsFile(id: 0, name: 'f_1', status: TranslationsFileStatus.creating, translations: [], completed: false);
    tOnCreationFileJson = {
      idKey: 0,
      translFilesNameKey: 'f_1',
      translFilesStatusKey: translFileStatusOnCreationKey
    };
    tCreatedFile = const TranslationsFile(id: 0, name: 'f_1', status: TranslationsFileStatus.created, completed: true, translations: []);
    tCreatedFileJson =  {
      idKey: 0,
      translFilesNameKey: 'f_1',
      translFilesStatusKey: translFileStatusCreatedKey
    };
    when(persistenceManager.queryWhere(any, any, any)).thenAnswer((_) async => [tOnCreationFileJson]);
    //when(adapter.getTranslationsFilesFromJson(jsonList))
  });

  test('should call the specified methods', ()async{
    await localDataSource.endTranslationsFileCreation();
    verify(persistenceManager.queryWhere(
      translFilesTableName, 
      '$translFilesStatusKey = ?', 
      [translFileStatusOnCreationKey]
    ));
  });
}