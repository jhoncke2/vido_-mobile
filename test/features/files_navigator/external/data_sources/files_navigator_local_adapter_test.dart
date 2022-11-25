import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:vido/core/domain/entities/app_file.dart';
import 'package:vido/core/domain/entities/folder.dart';
import 'package:vido/core/domain/entities/pdf_file.dart';
import 'package:vido/features/files_navigator/external/files_navigator_local_adapter.dart';

late FilesNavigatorLocalAdapterImpl localAdapter;

void main(){
  setUp((){
    localAdapter = FilesNavigatorLocalAdapterImpl();
  });

  group('get json string from file', _testGetJsonStringFromFileGroup);
  group('get file from json string',  _testGetFileFromJsonStringGroup);
}

void _testGetJsonStringFromFileGroup(){
  late AppFile tFile;
  late Map<String, dynamic> tJson;
  late String tJsonString;
  test('should return the expected result when the file is folder with config 1', ()async{
    tFile = const Folder(
      id: 100,
      name: 'f_100',
      parentId: 99,
      children: [],
      canBeRead: false,
      canBeEdited: true,
      canBeDeleted: true,
      canBeCreatedOnIt: false
    );
    tJson = {
      FilesNavigatorLocalAdapterImpl.idKey: 100,
      FilesNavigatorLocalAdapterImpl.nameKey: 'f_100',
      FilesNavigatorLocalAdapterImpl.parentIdKey: 99,
      FilesNavigatorLocalAdapterImpl.canBeReadKey: false,
      FilesNavigatorLocalAdapterImpl.canBeEdittedKey: true,
      FilesNavigatorLocalAdapterImpl.canBeDeletedKey: true,
      FilesNavigatorLocalAdapterImpl.fileTypeKey: FilesNavigatorLocalAdapterImpl.folderTypeOption,
      FilesNavigatorLocalAdapterImpl.canBeCreatedOnItKey: false
    };
    tJsonString = jsonEncode(tJson);
    final result = localAdapter.getJsonStringFromFile(tFile);
    expect(result, tJsonString);
  });

  test('should return the expected result when the file is folder with config 2', ()async{
    tFile = const Folder(
      id: 101,
      name: 'f_101',
      parentId: 99,
      children: [],
      canBeRead: true,
      canBeEdited: false,
      canBeDeleted: false,
      canBeCreatedOnIt: true
    );
    tJson = {
      FilesNavigatorLocalAdapterImpl.idKey: 101,
      FilesNavigatorLocalAdapterImpl.nameKey: 'f_101',
      FilesNavigatorLocalAdapterImpl.parentIdKey: 99,
      FilesNavigatorLocalAdapterImpl.canBeReadKey: true,
      FilesNavigatorLocalAdapterImpl.canBeEdittedKey: false,
      FilesNavigatorLocalAdapterImpl.canBeDeletedKey: false,
      FilesNavigatorLocalAdapterImpl.fileTypeKey: FilesNavigatorLocalAdapterImpl.folderTypeOption,
      FilesNavigatorLocalAdapterImpl.canBeCreatedOnItKey: true
    };
    tJsonString = jsonEncode(tJson);
    final result = localAdapter.getJsonStringFromFile(tFile);
    expect(result, tJsonString);
  });

  test('should return the expected result when the file is pdf', ()async{
    tFile =  const PdfFile(
      id: 100,
      name: 'f_100',
      url: 'file_url',
      parentId: 99,
      canBeRead: true,
      canBeEdited: false,
      canBeDeleted: false
    );
    tJson = {
      FilesNavigatorLocalAdapterImpl.idKey: 100,
      FilesNavigatorLocalAdapterImpl.nameKey: 'f_100',
      FilesNavigatorLocalAdapterImpl.parentIdKey: 99,
      FilesNavigatorLocalAdapterImpl.canBeReadKey: true,
      FilesNavigatorLocalAdapterImpl.canBeEdittedKey: false,
      FilesNavigatorLocalAdapterImpl.canBeDeletedKey: false,
      FilesNavigatorLocalAdapterImpl.fileTypeKey: FilesNavigatorLocalAdapterImpl.pdfTypeOption,
      FilesNavigatorLocalAdapterImpl.urlKey: 'file_url'
    };
    tJsonString = jsonEncode(tJson);
    final result = localAdapter.getJsonStringFromFile(tFile);
    expect(result, tJsonString);
  });
}

void _testGetFileFromJsonStringGroup(){
  late Map<String, dynamic> tJson;
  late String tJsonString;
  late AppFile tFile;

  test('should return the expected result when the file is folder with config 1', ()async{
    tJson = {
      FilesNavigatorLocalAdapterImpl.idKey: 100,
      FilesNavigatorLocalAdapterImpl.nameKey: 'f_100',
      FilesNavigatorLocalAdapterImpl.parentIdKey: 99,
      FilesNavigatorLocalAdapterImpl.canBeReadKey: false,
      FilesNavigatorLocalAdapterImpl.canBeEdittedKey: true,
      FilesNavigatorLocalAdapterImpl.canBeDeletedKey: true,
      FilesNavigatorLocalAdapterImpl.fileTypeKey: FilesNavigatorLocalAdapterImpl.folderTypeOption,
      FilesNavigatorLocalAdapterImpl.canBeCreatedOnItKey: false
    };
    tFile = const Folder(
      id: 100,
      name: 'f_100',
      parentId: 99,
      children: [],
      canBeRead: false,
      canBeEdited: true,
      canBeDeleted: true,
      canBeCreatedOnIt: false
    );
    tJsonString = jsonEncode(tJson);
    final result = localAdapter.getFileFromJsonString(tJsonString);
    expect(result, tFile);
  });

  test('should return the expected result when the file is folder with config 2', ()async{
    tJson = {
      FilesNavigatorLocalAdapterImpl.idKey: 101,
      FilesNavigatorLocalAdapterImpl.nameKey: 'f_101',
      FilesNavigatorLocalAdapterImpl.parentIdKey: 98,
      FilesNavigatorLocalAdapterImpl.canBeReadKey: true,
      FilesNavigatorLocalAdapterImpl.canBeEdittedKey: false,
      FilesNavigatorLocalAdapterImpl.canBeDeletedKey: false,
      FilesNavigatorLocalAdapterImpl.fileTypeKey: FilesNavigatorLocalAdapterImpl.folderTypeOption,
      FilesNavigatorLocalAdapterImpl.canBeCreatedOnItKey: true
    };
    tFile = const Folder(
      id: 101,
      name: 'f_101',
      parentId: 98,
      children: [],
      canBeRead: true,
      canBeEdited: false,
      canBeDeleted: false,
      canBeCreatedOnIt: true
    );
    tJsonString = jsonEncode(tJson);
    final result = localAdapter.getFileFromJsonString(tJsonString);
    expect(result, tFile);
  });

  test('should return the expected result when the file is pdf', ()async{
    tJson = {
      FilesNavigatorLocalAdapterImpl.idKey: 100,
      FilesNavigatorLocalAdapterImpl.nameKey: 'f_100',
      FilesNavigatorLocalAdapterImpl.parentIdKey: 99,
      FilesNavigatorLocalAdapterImpl.canBeReadKey: true,
      FilesNavigatorLocalAdapterImpl.canBeEdittedKey: false,
      FilesNavigatorLocalAdapterImpl.canBeDeletedKey: false,
      FilesNavigatorLocalAdapterImpl.fileTypeKey: FilesNavigatorLocalAdapterImpl.pdfTypeOption,
      FilesNavigatorLocalAdapterImpl.urlKey: 'file_url'
    };
    tFile =  const PdfFile(
      id: 100,
      name: 'f_100',
      url: 'file_url',
      parentId: 99,
      canBeRead: true,
      canBeEdited: false,
      canBeDeleted: false
    );
    tJsonString = jsonEncode(tJson);
    final result = localAdapter.getFileFromJsonString(tJsonString);
    expect(result, tFile);
  });
}