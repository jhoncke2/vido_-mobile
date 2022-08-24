// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';
import 'dart:async';
import 'package:vido/core/domain/file_parent_type.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_remote_data_source.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/external/data_sources/fake/tree.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import 'package:vido/features/photos_translator/domain/entities/folder.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import '../../../../../core/domain/exceptions.dart';
import '../../../../../core/utils/http_responses_manager.dart';
import '../../../../../core/utils/path_provider.dart';

class FilesNavigatorRemoteDataSourceFake implements FilesNavigatorRemoteDataSource{
  final PathProvider pathProvider;
  final HttpResponsesManager httpResponsesManager;
  final Tree<int, AppFile> filesTree;
  FilesNavigatorRemoteDataSourceFake({
    required this.pathProvider,
    required this.httpResponsesManager,
    required this.filesTree
  });

  @override
  Future<List<AppFile>> getChildren(int folderId, FileParentType parentType, String accessToken)async{
    return filesTree.getChildren(folderId);
  }

  @override
  Future<File> getGeneratedPdf(PdfFile file, String accessToken)async{
    try{
      Completer<File> completer = Completer();
      final pathParts = file.url.split('/');
      var request = await HttpClient().getUrl(
        Uri.http(pathParts[2],'${pathParts[3]}/${pathParts[4]}/${pathParts[5]}')
      );
      final dirPath = await pathProvider.generatePath();
      final response = await request.close();
      final bytes = await httpResponsesManager.getBytesFromResponse(response);
      final pdf = File('$dirPath/pdf_${file.id}');
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
    // TODO: implement search
    throw UnimplementedError();
  }
}