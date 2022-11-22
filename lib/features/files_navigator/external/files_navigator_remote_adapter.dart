import 'package:vido/core/external/app_files_remote_adapter.dart';
import '../../../core/domain/entities/app_file.dart';
import '../../../core/domain/entities/folder.dart';
import '../../../core/domain/entities/pdf_file.dart';
import '../domain/entities/search_appearance.dart';

class FilesNavigatorRemoteAdapter extends AppFilesRemoteAdapter{
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
    canBeCreatedOnIt: json['permisos']['crear']
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
          canBeCreatedOnIt: json['permisos']['crear']
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
              canBeCreatedOnIt: json['permisos']['crear']
            ) :
            super.getPdfFileFromJson(json)
      ).toList()
  );

  List<SearchAppearance> getApearancesFromJson(List<Map<String, dynamic>> jsonList) => super.tryFunction<List<SearchAppearance>>((){
    return jsonList.map<SearchAppearance>(
      (json) => SearchAppearance(
        title: json['titulo'],
        text: json['texto'],
        pdfUrl: json['url'],
        pdfPage: (json['n_pagina'] is String)? null : json['n_pagina']
      )
    ).toList();
  });
}