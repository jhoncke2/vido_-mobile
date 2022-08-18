import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:vido/core/utils/http_responses_manager.dart';
import 'package:vido/core/utils/path_provider.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/external/photos_translator_remote_adapter.dart';
import 'package:vido/features/photos_translator/external/photos_translator_remote_data_source_impl.dart';
import 'photos_translator_remote_data_source_test.mocks.dart';

late PhotosTranslatorRemoteDataSourceImpl remoteDataSource;
late MockClient client;
late MockPhotosTranslatorRemoteAdapter adapter;
late MockPathProvider pathProvider;
late MockHttpResponsesManager httpResponsesManager;


@GenerateMocks([http.Client, PhotosTranslatorRemoteAdapter, PathProvider, HttpResponsesManager])
void main(){
  adapter = MockPhotosTranslatorRemoteAdapter();
  client = MockClient();
  remoteDataSource = PhotosTranslatorRemoteDataSourceImpl(
    client: client,
    adapter: adapter,
    pathProvider: pathProvider,
    httpResponsesManager: httpResponsesManager
  );

  group('get completed pdf files', _testGetCompletedPdfFilesGruop);
}

void _testGetCompletedPdfFilesGruop(){
  late String tStringFiles;
  late List<Map<String, dynamic>> tJsonFiles;
  late List<PdfFile> tFiles;
  setUp((){
    tStringFiles = '''
      [
        {
          'id': 0,
          'name': 'f_1',
          'route': 'route_1',
        },
        {
          'id': 1,
          'name': 'f_2',
          'route': 'route_2',
        }
      ]
    ''';
    tJsonFiles = [
      {
        'id': 0,
        'name': 'f_1',
        'route': 'route_1',
      },
      {
        'id': 1,
        'name': 'f_2',
        'route': 'route_2',
      }
    ];
    tFiles = const [
      PdfFile(id: 0, name: 'f_1', url: 'route_1'),
      PdfFile(id: 1, name: 'f_2', url: 'route_2')
    ];
    when(client.get(any)).thenAnswer((_)async => http.Response(tStringFiles, 200));
    when(adapter.getPdfFilesFromJson(any)).thenReturn(tFiles);
  });

  test('should return the expected result', ()async{
    final result = await remoteDataSource.getCompletedPdfFiles();
    expect(result, tFiles);
  });
}