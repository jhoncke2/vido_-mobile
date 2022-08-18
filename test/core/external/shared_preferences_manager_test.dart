import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/external/shared_preferences_manager.dart';

import 'shared_preferences_manager_test.mocks.dart';

late SharedPreferencesManagerImpl preferencesManager;
late MockSharedPreferences preferences;

@GenerateMocks([SharedPreferences])
void main(){
  setUp((){
    preferences = MockSharedPreferences();
    preferencesManager = SharedPreferencesManagerImpl(preferences: preferences);
  });

  group('get string', _testGetStringGroup);
  group('set string', _testSetStringGroup);
  group('remove string', _testRemoveGroup);
}

void _testGetStringGroup(){
  late String tKey;
  
  setUp((){
    tKey = 'string_key';
  });
  
  test('should call the specified methods', ()async{
    when(preferences.getString(any)).thenReturn('value');
    await preferencesManager.getString(tKey);
    verify(preferences.getString(tKey));
  });

  test('shold return the expected result', ()async{
    String tValue = 'value';
    when(preferences.getString(any)).thenReturn(tValue);
    final result = await preferencesManager.getString(tKey);
    expect(result, tValue);
  });

  test('should throw the expected exception when result is null', ()async{
    when(preferences.getString(any)).thenReturn(null);
    try{
      await preferencesManager.getString(tKey);
      fail('the method shoulds throw an exception');
    }on StorageException catch(exception){
      if(exception.type == StorageExceptionType.NORMAL){
        fail('the exception type is wrong');
      }
    }catch(exception){
      fail('the exceptions has to be StorageException');
    }
  });

  test('should throw the expected exception when result is empty', ()async{
    when(preferences.getString(any)).thenReturn('');
    try{
      await preferencesManager.getString(tKey);
      fail('the method shoulds throw an exception');
    }on StorageException catch(exception){
      if(exception.type == StorageExceptionType.NORMAL){
        fail('the exception type is wrong');
      }
    }catch(exception){
      fail('the exceptions has to be StorageException');
    }
  });

  test('should throw the expected exception when preferences throws an exception', ()async{
    when(preferences.getString(any)).thenThrow(Exception());
    try{
      await preferencesManager.getString(tKey);
      fail('the method shoulds throw an exception');
    }on StorageException catch(exception){
      if(exception.type == StorageExceptionType.EMPTYDATA){
        fail('the exception type is wrong');
      }
    }catch(exception){
      fail('the exceptions has to be StorageException');
    }
  });
}

void _testSetStringGroup(){
  late String tKey;
  late String tValue;
  
  setUp((){
    tKey = 'key';
    tValue = 'value';
    when(preferences.setString(any, any)).thenAnswer((_) async => true);
  });

  test('shold call the specified methods', ()async{
    await preferencesManager.setString(tKey, tValue);
    verify(preferences.setString(tKey, tValue));
  });
  
}

void _testRemoveGroup(){
  late String tKey;
  setUp((){
    tKey = 'key';
    when(preferences.remove(any)).thenAnswer((_) async => true);
  });

  test('should call the specified methods', ()async{
    await preferencesManager.remove(tKey);
    verify(preferences.remove(tKey));
  });

}