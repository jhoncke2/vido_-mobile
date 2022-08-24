import 'package:vido/features/photos_translator/domain/entities/app_file.dart';

import '../../features/photos_translator/domain/entities/folder.dart';
import '../../features/photos_translator/domain/entities/pdf_file.dart';

abstract class AppFilesRemoteAdapter{
  List<AppFile> getAppFilesFromJson(List<Map<String, dynamic>> jsonList);
}

class AppFilesRemoteAdapterImpl implements AppFilesRemoteAdapter{
  @override
  List<AppFile> getAppFilesFromJson(List<Map<String, dynamic>> jsonList) =>
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
      ).toList();

}