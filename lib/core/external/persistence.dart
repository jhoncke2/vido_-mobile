import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/exceptions.dart';

const idKey = 'id';

const translFilesTableName = 'TranslationFiles';
const translFilesNameKey = 'name';
const translFilesStatusKey = 'status';
const tranlFilesStatusConstraintNameKey = 'chk_status';
const translFileStatusOnCreationValue = 'on_creation';
const translFileStatusCreatedValue = 'created';
const translFileStatusSendingValue = 'sending';
const translFilesParentIdKey = 'parent_id';
const translFilesProccessTypeOCRValue = 'ocr';
const translFilesProccessTypeICRValue = 'icr';
const translFilesProccessTypeKey = 'proccess_type';

const translationsTableName = 'Translations';
const translationsImgUrlKey = 'img_url';
const translationsTextKey = 'text';
const translationsFileIdKey = 'file_id';

const pdfFilesTableName = 'PdfFiles';
const pdfFilesNameKey = 'name';
const pdfFilesUrlKey = 'url';


abstract class DatabaseManager{
  Future<List<Map<String, dynamic>>> queryAll(String tableName);
  Future<Map<String, dynamic>> querySingleOne(String tableName, int id);
  Future<List<Map<String, dynamic>>> queryWhere(String tableName, String whereStatement, List<dynamic> whereVariables);
  Future<int> insert(String tableName, Map<String, dynamic> data);
  Future<void> update(String tableName, Map<String, dynamic> updatedData, int id);
  Future<void> remove(String tableName, int id);
  Future<void> removeAll(String tableName);
}

class DataBaseManagerImpl implements DatabaseManager{
  final Database db;

  DataBaseManagerImpl({
    required this.db
  });

  @override
  Future<List<Map<String, dynamic>>> queryAll(String tableName)async{
    return await _executeOperation(()async =>
      await db.query(tableName)
    );
  }

  @override
  Future<Map<String, dynamic>> querySingleOne(String tableName, int id)async{
    return await _executeOperation(()async =>
      (await db.query(tableName, where: '$idKey = ?', whereArgs: [id]) )[0]
    );
  }

  @override
  Future<List<Map<String, dynamic>>> queryWhere(String tableName, String whereStatement, List whereArgs)async{
    return await _executeOperation(()async =>
      await db.query(tableName, where: whereStatement, whereArgs: whereArgs)
    );
  }

  @override
  Future<int> insert(String tableName, Map<String, dynamic> data)async{
    return await _executeOperation(()async =>
      await db.insert(tableName, data)
    );
  }

  @override
  Future<void> update(String tableName, Map<String, dynamic> updatedData, int id)async{
    await _executeOperation(()async =>
      await db.update(tableName, updatedData, where: '$idKey = ?', whereArgs: [id])
    );
  }

  @override
  Future<void> remove(String tableName, int id)async{
    await _executeOperation(()async =>
      await db.delete(tableName, where: '$idKey = ?', whereArgs: [id])
    );
  }

  @override
  Future<void> removeAll(String tableName)async{
    await _executeOperation(()async => 
      await db.delete(tableName)
    );
  }

  Future<dynamic> _executeOperation(Function function)async{
    try{
      return await function();
    }on PlatformException{
      throw DBException(type: DBExceptionType.PLATFORM);
    }
  }
}

class CustomDataBaseFactory{
  static const String DB_NAME = 'vido_mobile.db';
  static const int DB_VERSION = 1;

  static Future<Database> get dataBase async => await initDataBase();

  static Future<Database> initDataBase()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, DB_NAME);
    //await deleteDatabase(path);
    return await openDatabase(path, version: DB_VERSION, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version)async{
    db.execute(
      '''
        CREATE TABLE $translFilesTableName (
          $idKey INTEGER PRIMARY KEY,
          $translFilesNameKey TEXT NOT NULL,
          $translFilesStatusKey FLOAT NOT NULL,
          $translFilesParentIdKey INTEGER,
          CONSTRAINT $tranlFilesStatusConstraintNameKey check ($translFilesStatusKey in ('$translFileStatusOnCreationValue', '$translFileStatusCreatedValue', '$translFileStatusSendingValue'))
        )
      '''
    );
    db.execute('''
      CREATE TABLE $translationsTableName (
        $idKey INTEGER PRIMARY KEY,
        $translationsImgUrlKey TEXT NOT NULL,
        $translationsTextKey TEXT,
        $translationsFileIdKey INTEGER REFERENCES $translFilesTableName($translationsFileIdKey)
      )
    '''
    );
    db.execute('''
      CREATE TABLE $pdfFilesTableName (
        $idKey INTEGER PRIMARY KEY,
        $pdfFilesNameKey TEXT NOT NULL,
        $pdfFilesUrlKey TEXT NOT NULL      
      )
    '''
    );
  }
}