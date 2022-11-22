import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import '../../features/photos_translator/domain/entities/folder.dart';
import '../../features/photos_translator/domain/entities/pdf_file.dart';

abstract class AppFilesRemoteAdapter{
  Folder getFolderFromJson(Map<String, dynamic> json);
  
}

class AppFilesRemoteAdapterImpl implements AppFilesRemoteAdapter{

  @override
  Folder getFolderFromJson(Map<String, dynamic> json) => tryFunction<Folder>(() => Folder(
    id: json['id'],
    name: json['name']??'',
    parentId: json['padre'],
    children: [
      ..._getAppFilesFromType((json['carpetas']??[]).cast<Map<String, dynamic>>(), 'folder'),
      ..._getAppFilesFromType((json['archivos']??[]).cast<Map<String, dynamic>>(), 'file')
    ],
    canBeRead: json['permisos']['ver'],
    canBeEdited: json['permisos']['editar'],
    canBeDeleted: json['permisos']['eliminar'],
    canCreateOnIt: json['permisos']['crear']
  ));

  List<AppFile> _getAppFilesFromType(List<Map<String, dynamic>> jsonList, String type) =>
      jsonList.map<AppFile>(
        (json) => (type == 'folder') ? Folder(
          id: json['id'], 
          name: json['name']??'', 
          parentId: json['padre'], 
          children: _getAppFilesFromJson((json['children']??[]).cast<Map<String, dynamic>>()),
          canBeRead: json['permisos']['ver'],
          canBeEdited: json['permisos']['editar'],
          canBeDeleted: json['permisos']['eliminar'],
          canCreateOnIt: json['permisos']['crear']
        ) : PdfFile(
          id: json['id'], 
          name: json['name'], 
          parentId: json['parent_id'], 
          url: json['route'],
          canBeRead: json['permisos']['ver'],
          canBeEdited: json['permisos']['editar'],
          canBeDeleted: json['permisos']['eliminar']
        )
      ).toList();
  
  List<AppFile> _getAppFilesFromJson(List<Map<String, dynamic>> jsonList) => tryFunction<List<AppFile>>( () =>
      jsonList.map<AppFile>(
        (json) => (json['type'] == 'directory')? 
            Folder(
              id: json['id'], 
              name: json['name'], 
              parentId: json['parent_id'], 
              children: _getAppFilesFromJson(json['children'].cast<Map<String, dynamic>>()),
              canBeRead: json['permisos']['ver'],
              canBeEdited: json['permisos']['editar'],
              canBeDeleted: json['permisos']['eliminar'],
              canCreateOnIt: json['permisos']['crear']
            ) :
            getPdfFileFromJson(json)
      ).toList()
  );

  PdfFile getPdfFileFromJson(Map<String, dynamic> json) => PdfFile(
    id: json['id'], 
    name: json['name'], 
    parentId: json['parent_id'],
    url: json['route'],
    canBeRead: json['permisos']['ver'],
    canBeEdited: json['permisos']['editar'],
    canBeDeleted: json['permisos']['eliminar']
  );

  T tryFunction<T>(T Function() function){
    try{
      return function();
    }on Object{
      throw const ServerException(
        message: 'Hay un problema con el formato de la información',
        type: ServerExceptionType.NORMAL
      );
    }
  }
}