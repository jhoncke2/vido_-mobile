import 'package:vido/core/domain/exceptions.dart';
import '../domain/entities/pdf_file.dart';

abstract class AppFilesRemoteAdapter{
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