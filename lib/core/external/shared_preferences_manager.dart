import 'package:shared_preferences/shared_preferences.dart';
import 'package:vido/core/domain/exceptions.dart';

abstract class SharedPreferencesManager{
  Future<String> getString(String key);
  Future<void> setString(String key, String value);
  Future<void> remove(String key);
  Future<void> clear();
}

class SharedPreferencesManagerImpl implements SharedPreferencesManager{
  final SharedPreferences preferences;
  const SharedPreferencesManagerImpl({
    required this.preferences
  });

  @override
  Future<String> getString(String key)async{
    try{
      final result = preferences.getString(key);
      if(result == null || result.isEmpty){
        throw const StorageException(message: '', type: StorageExceptionType.EMPTYDATA);
      }
      return result;
    }on Exception{
      throw const StorageException(message: '', type: StorageExceptionType.NORMAL);
    }
  }

  @override
  Future<void> setString(String key, String value)async{
    await preferences.setString(key, value);
  }
  
  @override
  Future<void> remove(String key)async{
    await preferences.remove(key);
  }

  @override
  Future<void> clear()async{
    await preferences.clear();
  }
}