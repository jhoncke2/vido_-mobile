import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';

import '../../features/photos_translator/domain/entities/folder.dart';
import '../../features/photos_translator/domain/entities/pdf_file.dart';

abstract class AppFilesRemoteAdapter{
  List<AppFile> getAppFilesFromJson(List<Map<String, dynamic>> jsonList);
  Folder getFolderFromJson(Map<String, dynamic> json);
  List<SearchAppearance> getApearancesFromJson(List<Map<String, dynamic>> jsonList);
}

class AppFilesRemoteAdapterImpl implements AppFilesRemoteAdapter{
  @override
  List<AppFile> getAppFilesFromJson(List<Map<String, dynamic>> jsonList) => _tryFunction<List<AppFile>>( () =>
      jsonList.map<AppFile>(
        (json) => (json['type'] == 'directory')? 
            Folder(
              id: json['id'], 
              name: json['name'], 
              parentId: json['parent_id'], 
              children: getAppFilesFromJson(json['children'].cast<Map<String, dynamic>>())
            ) :
            PdfFile(
              id: json['id'], 
              name: json['name'], 
              parentId: json['parent_id'], 
              url: json['route']
            )
      ).toList()
  );
    
  List<AppFile> _getAppFilesFromType(List<Map<String, dynamic>> jsonList, String type) =>
      jsonList.map<AppFile>(
        (json) => (type == 'folder') ? Folder(
          id: json['id'], 
          name: json['name']??'', 
          parentId: json['padre'], 
          children: getAppFilesFromJson((json['children']??[]).cast<Map<String, dynamic>>())
        ) : PdfFile(
          id: json['id'], 
          name: json['name'], 
          parentId: json['parent_id'], 
          url: json['route']
        )
      ).toList();
      

  @override
  Folder getFolderFromJson(Map<String, dynamic> json) => _tryFunction<Folder>(() => Folder(
    id: json['id'],
    name: json['name']??'',
    parentId: json['padre'],
    children: [
      ..._getAppFilesFromType((json['carpetas']??[]).cast<Map<String, dynamic>>(), 'folder'),
      ..._getAppFilesFromType((json['archivos']??[]).cast<Map<String, dynamic>>(), 'file')
    ]
  ));
  
  @override
  List<SearchAppearance> getApearancesFromJson(List<Map<String, dynamic>> jsonList) => _tryFunction<List<SearchAppearance>>((){
    return jsonList.map<SearchAppearance>(
      (json) => SearchAppearance(
        title: json['titulo'], 
        text: json['texto'], 
        pdfUrl: json['url'], 
        pdfPage: (json['n_pagina'] is String)? null : json['n_pagina']
      )
    ).toList();
  });

  T _tryFunction<T>(T Function() function){
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