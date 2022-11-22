import 'package:vido/core/external/app_files_remote_adapter.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';

class PhotosTranslatorRemoteAdapterImpl extends AppFilesRemoteAdapterImpl{

  TranslationsFile getTranslationsFileFromJson(Map<String, dynamic> json) => 
    TranslationsFile(
      id: json['id'],
      name: json['name'],
      completed: json['completed']??false,
      translations: _getTranslationsFromJson(((json['translations']??[]) as List).cast<Map<String, dynamic>>())
    );

  List<Translation> _getTranslationsFromJson(List<Map<String, dynamic>> jsonList) =>
    jsonList.map(
      (j) => Translation(
        id: j['id'], 
        imgUrl: j['img_url'], 
        text: j['text']
      )
    ).toList();
    
    Translation getTranslationFromJson(Map<String, dynamic> json){
      return Translation(
        id: json['id'], 
        imgUrl: json['route'], 
        text: json['text']
      );
    }
}