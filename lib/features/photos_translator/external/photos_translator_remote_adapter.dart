import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';

abstract class PhotosTranslatorRemoteAdapter{
  List<PdfFile> getPdfFilesFromJson(List<Map<String, dynamic>> jsonList);
  List<Map<String, dynamic>> getJsonListFromPdfFiles(List<PdfFile> files);
  PdfFile getPdfFileFromJson(Map<String, dynamic> json);
  List<TranslationsFile> getTranslationsFilesFromJson(List<Map<String, dynamic>> jsonList);
  List<Map<String, dynamic>> getJsonListFromTranslationsFiles(List<TranslationsFile> files);
  TranslationsFile getTranslationsFileFromJson(Map<String, dynamic> json);
  Translation getTranslationFromJson(Map<String, dynamic> json);
}

class PhotosTranslatorRemoteAdapterImpl implements PhotosTranslatorRemoteAdapter{
  @override
  List<PdfFile> getPdfFilesFromJson(List<Map<String, dynamic>> jsonList) =>
     jsonList.map(
      (j) => getPdfFileFromJson(j)
    ).toList();

  @override
  List<Map<String, dynamic>> getJsonListFromPdfFiles(List<PdfFile> files) => 
    files.map<Map<String, dynamic>>(
      (f) => {
        'id': f.id,
        'name': f.name,
        'route': f.url
      }
    ).toList();
  
  @override
  PdfFile getPdfFileFromJson(Map<String, dynamic> json) =>
    PdfFile(
      id: json['id'], 
      name: json['name'], 
      url: json['route']
    );
  
  @override
  List<Map<String, dynamic>> getJsonListFromTranslationsFiles(List<TranslationsFile> files) =>
    files.map(
      (f) => {
        'id': f.id,
        'name': f.name,
        'translations': _getJsonListFromTranslations(f.translations),
        'completed': f.completed
      }
    ).toList();
  
  @override
  List<TranslationsFile> getTranslationsFilesFromJson(List<Map<String, dynamic>> jsonList) =>
    jsonList.map(
      (j) => getTranslationsFileFromJson(j)
    ).toList();

  @override
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

  List<Map<String, dynamic>> _getJsonListFromTranslations(List<Translation> translations) =>
    translations.map(
      (t) => {
        'id': t.id,
        'route': t.imgUrl,
        'text': t.text
      }
    ).toList();
    
    @override
    Translation getTranslationFromJson(Map<String, dynamic> json) =>
      Translation(
        id: json['id'], 
        imgUrl: json['route'], 
        text: json['text']
      );
}