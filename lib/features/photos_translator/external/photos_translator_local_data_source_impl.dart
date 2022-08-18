import 'package:vido/core/external/persistence.dart';
import 'package:vido/core/external/photos_translator.dart';
import 'package:vido/core/utils/image_rotation_fixer.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_local_data_source.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translation.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/external/photos_translator_local_adapter.dart';

class PhotosTranslatorLocalDataSourceImpl implements PhotosTranslatorLocalDataSource{
  final PhotosTranslatorLocalAdapter adapter;
  final DatabaseManager persistenceManager;
  final PhotosTranslator translator;
  final ImageRotationFixer rotationFixer;
  bool _isTranslating = false;
  PhotosTranslatorLocalDataSourceImpl({
    required this.adapter,
    required this.persistenceManager,
    required this.translator,
    required this.rotationFixer
  });
  
  @override
  Future<void> addPdfFile(PdfFile file) async {
    final fileJson = adapter.getJsonFromPdfFile(file);
    await persistenceManager.insert(pdfFilesTableName, fileJson);
  }

  @override
  Future<void> createTranslationsFile(TranslationsFile newFile) async {
    final fileJson = adapter.getJsonFromTranslationsFile(newFile);
    await persistenceManager.insert(translFilesTableName, fileJson);
  }

  @override
  Future<void> endTranslationsFileCreation() async {
    final fileJson = (await persistenceManager.queryWhere(translFilesTableName, '$translFilesStatusKey = ?', [translFileStatusOnCreationValue])).first;
    final file = adapter.getTranslationsFileFromJson(fileJson, []);
    final updatedFile = TranslationsFile(
      id: file.id, 
      name: file.name, 
      completed: file.completed, 
      translations: file.translations, 
      status: TranslationsFileStatus.created
    );
    final updatedFileJson = adapter.getJsonFromTranslationsFile(updatedFile);
    await persistenceManager.update(translFilesTableName, updatedFileJson, updatedFile.id);
  }

  @override
  Future<TranslationsFile?> getCurrentCreatedFile() async {
    final response = (await persistenceManager.queryWhere(translFilesTableName, '$translFilesStatusKey = ?', [translFileStatusOnCreationValue]));
    if(response.isNotEmpty){
      final createdFileJson = response.first;
      final translationsJson = await persistenceManager.queryWhere(translationsTableName, '$translationsFileIdKey = ?', [createdFileJson[idKey]]);
      return adapter.getTranslationsFileFromJson(createdFileJson, translationsJson);
    }else{
      return null;
    }
    
  }

  @override
  Future<List<PdfFile>> getPdfFiles() async {
    final filesJson = await persistenceManager.queryAll(pdfFilesTableName);
    return adapter.getPdfFilesFromJson(filesJson);
  }

  @override
  Future<List<TranslationsFile>> getTranslationsFiles() async {
    final filesJson = await persistenceManager.queryAll(translFilesTableName);
    final List<List<Map<String, dynamic>>> filesTranslationsJson = [];
    for(final fileJson in filesJson){
      final fileTranslations = await persistenceManager.queryWhere(translationsTableName, '$translationsFileIdKey = ?', [fileJson[idKey]]); 
      filesTranslationsJson.add(fileTranslations);
    }
    return adapter.getTranslationsFilesFromJson(filesJson, filesTranslationsJson);
  }

  @override
  Future<TranslationsFile> getTranslationsFile(int fileId) async {
    final fileJson = await persistenceManager.querySingleOne(translFilesTableName, fileId);
    final translationsJson = await persistenceManager.queryWhere(translationsTableName, '$translationsFileIdKey = ?', [fileId]);
    return adapter.getTranslationsFileFromJson(fileJson, translationsJson);
  }

  @override
  Future<void> removeTranslationsFile(TranslationsFile file) async {
    await persistenceManager.remove(translFilesTableName, file.id);
  }

  @override
  Future<void> saveUncompletedTranslation(String photoUrl) async {
    final translation = Translation(id: null, imgUrl: photoUrl, text: null);
    final createdFileJson = (await persistenceManager.queryWhere(translFilesTableName, '$translFilesStatusKey = ?', [translFileStatusOnCreationValue])).first;
    final createdFile = adapter.getTranslationsFileFromJson(createdFileJson, []);
    final translationJson = adapter.getJsonFromTranslation(translation, createdFile.id);
    await persistenceManager.insert(translationsTableName, translationJson);
  }

  @override
  Future<void> updatePdfFiles(List<PdfFile> files) async {
    final filesJson = adapter.getJsonFromPdfFiles(files);
    await persistenceManager.removeAll(pdfFilesTableName);
    for(final fileJson in filesJson){
      await persistenceManager.insert(pdfFilesTableName, fileJson);
    }
  }

  @override
  Future<Translation> translate(Translation uncompletedTranslation, int translationsFileId) async {
    _isTranslating = true;
    final fixedImage = await rotationFixer.fix(uncompletedTranslation.imgUrl);
    final translationText = await translator.translate(uncompletedTranslation.imgUrl);
    _isTranslating = false;
    return Translation(id: uncompletedTranslation.id, imgUrl: fixedImage.path, text: translationText);
  }

  @override
  bool get translating => _isTranslating;

  @override
  Future<void> updateTranslation(int fileId, Translation translation) async {
    final newTranslationJson = adapter.getJsonFromTranslation(translation, fileId);
    await persistenceManager.update(translationsTableName, newTranslationJson, translation.id!);
  }
}