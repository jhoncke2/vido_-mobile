
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/external/shared_preferences_manager.dart';
import 'package:vido/features/files_navigator/external/data_sources/files_navigator_local_data_source_impl.dart';
import 'files_navigator_local_data_source_impl_test.mocks.dart';

late FilesNavigatorLocalDataSourceImpl localDataSource;
late MockSharedPreferencesManager sharedPreferencesManager;

@GenerateMocks([
  SharedPreferencesManager
])
void main(){
  setUp((){
    sharedPreferencesManager = MockSharedPreferencesManager();
    localDataSource = FilesNavigatorLocalDataSourceImpl(sharedPreferencesManager: sharedPreferencesManager);
  });

  group('get current parent folder id', _testGetCurrentParentFolderIdGroup);
  group('set current parent folder id', _testSetCurrentParentFolderIdGroup);
  group('get files tree lvl', _testGetFilesTreeLvlGroup);
  group('set files tree lvl', _testSetFilesTreeLvlGroup);
}

void _testGetCurrentParentFolderIdGroup(){
  late int tId;
  setUp((){
    tId = 110;
    when(sharedPreferencesManager.getString(any)).thenAnswer((_) async => '$tId');
  });

  test('should call the specified methods', ()async{
    await localDataSource.getCurrentFileId();
    verify(sharedPreferencesManager.getString(FilesNavigatorLocalDataSourceImpl.currentParentFolderIdKey));
  });

  test('should return the expected result', ()async{
    final result = await localDataSource.getCurrentFileId();
    expect(result, tId);
  });
}

void _testSetCurrentParentFolderIdGroup(){
  late int tId;
  setUp((){
    tId = 110;
  });

  test('should call the specified methods', ()async{
    await localDataSource.setCurrentFileId(tId);
    verify(sharedPreferencesManager.setString(FilesNavigatorLocalDataSourceImpl.currentParentFolderIdKey, '$tId'));
  });
}

void _testGetFilesTreeLvlGroup(){
  late int tLvl;
  setUp((){
    tLvl = 10;
    when(sharedPreferencesManager.getString(any)).thenAnswer((_) async => '$tLvl');
  });

  test('should call the specified methods', ()async{
    await localDataSource.getFilesTreeLevel();
    verify(sharedPreferencesManager.getString(FilesNavigatorLocalDataSourceImpl.filesTreeLvlKey));
  });
  
  test('should return the expected result', ()async{
    final result = await localDataSource.getFilesTreeLevel();
    expect(result, tLvl);
  });
}

void _testSetFilesTreeLvlGroup(){
  late int tLvl;
  setUp((){
    tLvl = 10;
    when(sharedPreferencesManager.getString(any)).thenAnswer((_) async => '$tLvl');
  });

  test('should call the specified methods', ()async{
    await localDataSource.setFilesTreeLvl(tLvl);
    verify(sharedPreferencesManager.setString(FilesNavigatorLocalDataSourceImpl.filesTreeLvlKey, '$tLvl'));
  });
}