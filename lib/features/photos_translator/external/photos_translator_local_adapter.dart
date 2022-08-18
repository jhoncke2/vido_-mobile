import 'package:vido/core/external/persistence.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import '../domain/entities/translation.dart';

abstract class PhotosTranslatorLocalAdapter{
  List<TranslationsFile> getTranslationsFilesFromJson(List<Map<String, dynamic>> jsonList, List<List<Map<String, dynamic>>> jsonTranslations);
  TranslationsFile getTranslationsFileFromJson(Map<String, dynamic> json, List<Map<String, dynamic>> translations);
  List<PdfFile> getPdfFilesFromJson(List<Map<String, dynamic>> jsonList);
  List<Map<String, dynamic>> getJsonFromPdfFiles(List<PdfFile> files);
  Map<String, dynamic> getJsonFromPdfFile(PdfFile file);
  Map<String, dynamic> getJsonFromTranslationsFile(TranslationsFile file);
  List<Translation> getTranslationsFromJson(List<Map<String, dynamic>> jsonList);
  Map<String, dynamic> getJsonFromTranslation(Translation translation, int fileId);
}

class PhotosTranslatorLocalAdapterImpl implements PhotosTranslatorLocalAdapter{

  @override
  List<Map<String, dynamic>> getJsonFromPdfFiles(List<PdfFile> files) => files.map<Map<String, dynamic>>(
    (file) => getJsonFromPdfFile(file)
  ).toList();

  @override
  Map<String, dynamic> getJsonFromPdfFile(PdfFile file) => {
    idKey: file.id,
    pdfFilesNameKey: file.name,
    pdfFilesUrlKey: file.url
  };

  @override
  List<PdfFile> getPdfFilesFromJson(List<Map<String, dynamic>> jsonList) => jsonList.map<PdfFile>(
    (json) => PdfFile(
      id: json[idKey],
      name: json[pdfFilesNameKey], 
      url: json[pdfFilesUrlKey]
    )
  ).toList();

  @override
  List<TranslationsFile> getTranslationsFilesFromJson(List<Map<String, dynamic>> jsonList, List<List<Map<String, dynamic>>> jsonTranslations){
    final List<TranslationsFile> files = [];
    for(int i = 0; i < jsonList.length; i++){
      final fileJson = jsonList[i];
      files.add(TranslationsFile(
        id: fileJson[idKey], 
        name: fileJson[translFilesNameKey], 
        completed: false,
        translations: getTranslationsFromJson( (jsonTranslations.isNotEmpty)? jsonTranslations[i] : [] )
      ));
    }
    return files;
  }
  
  @override
  Map<String, dynamic> getJsonFromTranslationsFile(TranslationsFile file) => {
    idKey: file.id,
    translFilesNameKey: file.name,
    translFilesStatusKey: (file.status == TranslationsFileStatus.creating)? translFileStatusOnCreationValue
                        : (file.status == TranslationsFileStatus.created)? translFileStatusCreatedValue
                        : translFileStatusSendingValue
  };
  
  @override
  TranslationsFile getTranslationsFileFromJson(Map<String, dynamic> json, List<Map<String, dynamic>> translations) => TranslationsFile(
    id: json[idKey], 
    name: json[translFilesNameKey], 
    completed: false, 
    translations: getTranslationsFromJson(translations)
  );

  @override
  List<Translation> getTranslationsFromJson(List<Map<String, dynamic>> jsonList) => jsonList.map<Translation>(
    (json) => Translation(
      id: json[idKey],
      text: json[translationsTextKey],
      imgUrl: json[translationsImgUrlKey]
    )
  ).toList();
  
  @override
  Map<String, dynamic> getJsonFromTranslation(Translation translation, int fileId) => {
    idKey: translation.id,
    translationsImgUrlKey: translation.imgUrl,
    translationsTextKey: translation.text,
    translationsFileIdKey: fileId
  };
}