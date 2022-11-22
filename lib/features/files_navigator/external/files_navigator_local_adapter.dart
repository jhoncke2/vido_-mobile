import 'dart:convert';

import 'package:vido/core/domain/entities/app_file.dart';
import 'package:vido/core/domain/entities/pdf_file.dart';

import '../../../core/domain/entities/folder.dart';

abstract class FilesNavigatorLocalAdapter{
  String getJsonStringFromFile(AppFile file);
  AppFile getFileFromJsonString(String jsonString);
}

class FilesNavigatorLocalAdapterImpl implements FilesNavigatorLocalAdapter{

  static const idKey = 'id';
  static const nameKey = 'name';
  static const parentIdKey = 'parent_id';
  static const urlKey = 'url';
  static const canBeReadKey = 'can_be_read';
  static const canBeEdittedKey = 'can_be_editted';
  static const canBeDeletedKey = 'can_be_deleted';
  static const canBeCreatedOnItKey = 'can_be_created_on_it';
  static const fileTypeKey = 'file_type';
  static const folderTypeOption = 'folder';
  static const pdfTypeOption = 'pdf';

  @override
  String getJsonStringFromFile(AppFile file){
    final fileType = (file is Folder)? folderTypeOption : pdfTypeOption;
    final json = {
      idKey: file.id,
      nameKey: file.name,
      parentIdKey: file.parentId,
      canBeReadKey: file.canBeRead,
      canBeEdittedKey: file.canBeEdited,
      canBeDeletedKey: file.canBeDeleted,
      fileTypeKey: fileType
    };
    if(fileType == folderTypeOption){
      json[canBeCreatedOnItKey] = (file as Folder).canBeCreatedOnIt;
    }else{
      json[urlKey] = (file as PdfFile).url;
    }
    return jsonEncode(json);
  }

  @override
  AppFile getFileFromJsonString(String jsonString){
    final json = jsonDecode(jsonString);
    return Folder(
      id: json[idKey],
      name: json[nameKey],
      parentId: json[parentIdKey],
      children: const [],
      canBeRead: json[canBeReadKey],
      canBeEdited: json[canBeEdittedKey],
      canBeDeleted: json[canBeDeletedKey],
      canBeCreatedOnIt: json[canBeCreatedOnItKey]
    );
  }
}