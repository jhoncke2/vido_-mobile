// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';
import 'dart:async';
import 'package:vido/core/domain/file_parent_type.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_remote_data_source.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/external/data_sources/fake/tree.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import 'package:vido/features/photos_translator/domain/entities/folder.dart';
import '../../../../../core/domain/exceptions.dart';
import '../../../../../core/utils/http_responses_manager.dart';
import '../../../../../core/utils/path_provider.dart';

class FilesNavigatorRemoteDataSourceFake implements FilesNavigatorRemoteDataSource{
  static const _examplePdfUrl = 'www.africau.edu/images/default/sample.pdf';
  final PathProvider pathProvider;
  final HttpResponsesManager httpResponsesManager;
  final Tree<int, AppFile> filesTree;
  FilesNavigatorRemoteDataSourceFake({
    required this.pathProvider,
    required this.httpResponsesManager,
    required this.filesTree
  });

  @override
  Future<Folder> getFolder(int folderId, FileParentType parentType, String accessToken)async{
    final folder = filesTree.getAt(folderId) as Folder;
    if(folder.children.isEmpty){
      folder.children.addAll( filesTree.getChildren(folder.id) );
    }
    return folder;
  }

  @override
  Future<File> getGeneratedPdf(String fileUrl, String accessToken)async{
    try{
      Completer<File> completer = Completer();
      final url = fileUrl
          .replaceAll(RegExp('http://'), '')
          .replaceAll('\\', '');
      final urlParts = url.split('/');
      var request = await HttpClient().getUrl(
        Uri.http(urlParts[0], urlParts.sublist(1, urlParts.length).join('/'))
      );
      final dirPath = await pathProvider.generatePath();
      final response = await request.close();
      final bytes = await httpResponsesManager.getBytesFromResponse(response);
      final date = DateTime.now();
      final pdf = File('$dirPath/pdf_${date.year}${date.month}${date.day}${date.hour}${date.second}${date.millisecond}');
      await pdf.writeAsBytes(bytes, flush: true);
      completer.complete(pdf);
      return pdf;
    }catch(err, stackTrace){
      print('************************* pdf error *********************');
      print(err);
      print(stackTrace);
      throw const ServerException(type: ServerExceptionType.NORMAL);
    }
  }
  
  @override
  Future<AppFile> getParentWithBrothers(int folderId, String accessToken)async{
    final parent = filesTree.getParent(folderId) as Folder;
    if(parent.children.isEmpty){
      parent.children.addAll( filesTree.getChildren(parent.id) );
    }
    return parent;
  }

  @override
  Future<List<SearchAppearance>> search(String text, String accessToken)async{
    return [
      SearchAppearance(
        title: '<h2>Archivo 1</h2>', 
        text: '<h3>Bajo la presente se expone el día de hoy que <strong>$text</strong> podría estar escrito</h3>', 
        pdfUrl: _examplePdfUrl, 
        pdfPage: 1
      ),
      SearchAppearance(
        title: '<h2>Archivo <strong>$text</strong></h2>', 
        text: '', 
        pdfUrl: _examplePdfUrl, 
        pdfPage: null
      ),
      SearchAppearance(
        title: '<h2>Documento de petición</h2>', 
        text: '<h3>Se prolongan las reuniones hasta previo aviso y <strong>$text</strong> no puede ser definido aún</h3>', 
        pdfUrl: _examplePdfUrl, 
        pdfPage: 0
      ),
      SearchAppearance(
        title: '<h2>Contrataciones auditorías</h2>', 
        text: '<h3>Lo siguiente (<strong>$text</strong>) puede o no estar presente, dependiendo de las renovaciones de los contratos</h3>', 
        pdfUrl: _examplePdfUrl, 
        pdfPage: 1
      ),
      SearchAppearance(
        title: '<h2>Renovaciones contratos</h2>', 
        text: '<h3>No puede aún haber claridad acerca del pasado tema. <strong>$text</strong> será definido próximamente.</h3>', 
        pdfUrl: _examplePdfUrl, 
        pdfPage: 0
      )
    ];
  }
  
  @override
  Future<List<Map<String, dynamic>>> generateIcr(List<int> filesIds, String accessToken)async{
    return [
      {
        'id': 0,
        'nombre': 'Elemento 1',
        'Edad': 20,
        'Descripción': 'Descripción del elemento 1',
        'peso': '20kg'
      },
      {
        'id': 1,
        'nombre': 'Elemento 2',
        'Edad': 22,
        'Descripción': 'Descripción del elemento 2',
        'peso': '22kg'
      },
      {
        'id': 2,
        'nombre': 'Elemento 3',
        'Edad': 30,
        'Descripción': 'Descripción del elemento 3',
        'peso': '40kg'
      },
      {
        'id': 3,
        'nombre': 'Elemento 4',
        'Edad': 21,
        'Descripción': 'Descripción del elemento 4',
        'peso': '25kg'
      },
      {
        'id': 5,
        'nombre': 'Elemento 5',
        'Edad': 27,
        'Descripción': 'Descripción del elemento 5',
        'peso': '53kg'
      },
      {
        'id': 6,
        'nombre': 'Elemento 5',
        'Edad': 27,
        'Descripción': 'Descripción del elemento 5',
        'peso': '53kg'
      },
      {
        'id': 7,
        'nombre': 'Elemento 5',
        'Edad': 27,
        'Descripción': 'Descripción del elemento 5',
        'peso': '53kg'
      },
      {
        'id': 8,
        'nombre': 'Elemento 5',
        'Edad': 27,
        'Descripción': 'Descripción del elemento 5',
        'peso': '53kg'
      },
      {
        'id': 9,
        'nombre': 'Elemento 5',
        'Edad': 27,
        'Descripción': 'Descripción del elemento 5',
        'peso': '53kg'
      },
      {
        'id': 10,
        'nombre': 'Elemento 5',
        'Edad': 27,
        'Descripción': 'Descripción del elemento 5',
        'peso': '53kg'
      },
      {
        'id': 11,
        'nombre': 'Elemento 5',
        'Edad': 27,
        'Descripción': 'Descripción del elemento 5',
        'peso': '53kg'
      },
      {
        'id': 12,
        'nombre': 'Elemento 5',
        'Edad': 27,
        'Descripción': 'Descripción del elemento 5',
        'peso': '53kg'
      },
      {
        'id': 13,
        'nombre': 'Elemento 5',
        'Edad': 27,
        'Descripción': 'Descripción del elemento 5',
        'peso': '53kg'
      }
    ];
  }
}