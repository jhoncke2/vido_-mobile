import 'package:vido/core/external/app_files_remote_adapter.dart';

import '../domain/entities/search_appearance.dart';

class FilesNavigatorRemoteAdapterImpl extends AppFilesRemoteAdapterImpl{
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