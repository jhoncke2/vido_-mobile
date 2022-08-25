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
          ..replaceAll(RegExp('https://'), '')
          ..replaceAll('\\', '');
      final urlParts = url.split('/');
      var request = await HttpClient().getUrl(
        Uri.https(urlParts[0], urlParts.sublist(1, urlParts.length).join('/'))
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
  Future<List<SearchAppearance>> search(String text)async{
    return [
      SearchAppearance(title: 'Archivo 1', text: 'Lo siguiente $text está escrito', pdfUrl: _examplePdfUrl, pdfPage: 1),
      SearchAppearance(title: 'Archivo $text', text: 'Archivo $text', pdfUrl: _examplePdfUrl, pdfPage: null),
      SearchAppearance(title: 'Archivo 3', text: 'El $text está escrito', pdfUrl: _examplePdfUrl, pdfPage: 0),
      SearchAppearance(title: 'Archivo 4', text: 'Lo siguiente $text escrito', pdfUrl: _examplePdfUrl, pdfPage: 1),
      SearchAppearance(title: 'Archivo 5', text: 'No puede $text estar escrito', pdfUrl: _examplePdfUrl, pdfPage: 0)
    ];
  }
}