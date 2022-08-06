import 'package:vido/core/external/persistence.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';

abstract class PhotosTranslatorLocalAdapter{
  List<TranslationsFile> getTranslationsFilesFromJson(List<Map<String, dynamic>> jsonList);
  List<PdfFile> getPdfFilesFromJson(List<Map<String, dynamic>> jsonList);
  List<Map<String, dynamic>> getJsonFromPdfFiles(List<PdfFile> files);
  Map<String, dynamic> getJsonFromPdfFile(PdfFile file);
  Map<String, dynamic> getJsonFromTranslationsFile(TranslationsFile file);
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
  List<TranslationsFile> getTranslationsFilesFromJson(List<Map<String, dynamic>> jsonList) {
    // TODO: implement getTranslationsFilesFromJson
    throw UnimplementedError();
  }
  
  @override
  Map<String, dynamic> getJsonFromTranslationsFile(TranslationsFile file) => {
    idKey: file.id
  };
}