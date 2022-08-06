
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/external/persistence.dart';
import 'package:vido/features/database_manager/external/database_manager_adapter.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
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
    tFile = const TranslationsFile(id: 0, name: 't_f_1', translations: [], completed: false);
    tFileJson = {
      'id': 0,
      'name': 't_f_1',
      'translations': [],
      'completed': false
    };
  });

  test('should call the specified methods', ()async{
    await localDataSource.createTranslationFile(tFile);
    verify(adapter.getJsonFromPdfFile(file))
  });
}