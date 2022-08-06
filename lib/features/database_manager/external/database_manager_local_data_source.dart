import 'dart:math';

import 'package:vido/core/external/persistence.dart';
import 'package:vido/features/database_manager/external/database_manager_adapter.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';

abstract class DatabaseManagerLocalDataSource{
  Future<List<PdfFile>> getPdfFiles();
  Future<void> addPdfFile(PdfFile file);
}

class DatabaseManagerLocalDataSourceImpl implements DatabaseManagerLocalDataSource{
  final PhotosTranslatorLocalAdapter adapter;
  final PersistenceManager persistenceManager;
  DatabaseManagerLocalDataSourceImpl({
    required this.adapter,
    required this.persistenceManager
  });

  @override
  Future<void> addPdfFile(PdfFile file)async{
    file = PdfFile(
      id: null,
      name: file.name,
      url: file.url
    );
    final fileJson = adapter.getJsonFromPdfFile(file);
    await persistenceManager.insert(pdfFilesTableName, fileJson);
  }

  @override
  Future<List<PdfFile>> getPdfFiles()async{
    final filesJson = await persistenceManager.queryAll(pdfFilesTableName);
    return adapter.getPdfFilesFromJson(filesJson);
  }

}