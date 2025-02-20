
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/domain/exceptions.dart';
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
  group('get parent id', _testGetParentIdGroup);
  group('set parent id', _testSetParentIdGroup);
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
  late int? tLvl;

  group('when all goes good', (){
    setUp((){
      tLvl = 10;
      when(sharedPreferencesManager.getString(any)).thenAnswer((_) async => '$tLvl');
    });

    test('should call the specified methods', ()async{
      await localDataSource.getFilesTreeLevel();
      verify(sharedPreferencesManager.getString(FilesNavigatorLocalDataSourceImpl.filesTreeLvlKey));
    });
    
    test('should return the expected result when all goes good', ()async{
      when(sharedPreferencesManager.getString(any)).thenAnswer((_) async => '$tLvl');
      final result = await localDataSource.getFilesTreeLevel();
      expect(result, tLvl);
    });
  });

  test('should return the expected result when there is an empty data storage exception', ()async{
    when(sharedPreferencesManager.getString(any))
        .thenThrow(const StorageException(message: 'empty data', type: StorageExceptionType.EMPTYDATA));
    final result = await localDataSource.getFilesTreeLevel();
    expect(result, null);
  });

  test('should throw the exception when there is another exception', ()async{
    when(sharedPreferencesManager.getString(any))
        .thenThrow(const StorageException(message: 'empty data', type: StorageExceptionType.NORMAL));
    try{
      await localDataSource.getFilesTreeLevel();
      fail('debería lanzar un exception');
    }catch(exception){
      expect(exception, const StorageException(message: 'empty data', type: StorageExceptionType.NORMAL));
    }
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

void _testGetParentIdGroup(){
  late int tId;
  setUp((){
    tId = 0;
    when(sharedPreferencesManager.getString(any)).thenAnswer((_) async => '$tId');
  });
  test('should call the specified methods', ()async{
    await localDataSource.getParentId();
    verify(sharedPreferencesManager.getString(FilesNavigatorLocalDataSourceImpl.parentIdKey));
  });
  test('should return the expected result', ()async{
    final result = await localDataSource.getParentId();
    expect(result, tId);
  });
}

void _testSetParentIdGroup(){
  late int tId;
  setUp((){
    tId = 0;
  });
  test('should call the specified methods', ()async{
    await localDataSource.setParentId(tId);
    verify(sharedPreferencesManager.setString(FilesNavigatorLocalDataSourceImpl.parentIdKey, '$tId'));
  });
}