import 'dart:math';
import 'package:vido/core/external/photos_translator.dart';
import 'package:vido/core/utils/image_rotation_fixer.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_local_data_source.dart';
import '../../domain/entities/pdf_file.dart';
import '../../domain/entities/translation.dart';
import '../../domain/entities/translations_file.dart';

class PhotosTranslatorLocalDataSourceFake implements PhotosTranslatorLocalDataSource {
  final List<TranslationsFile> uncompletedFiles = [];
  late List<PdfFile> completedFiles = [];
  late TranslationsFile? createdFile;
  final PhotosTranslator translator;
  final ImageRotationFixer rotationFixer;
  late bool _translating = false;
  PhotosTranslatorLocalDataSourceFake({
    required this.translator,
    required this.rotationFixer
  });
  @override
  Future<void> createTranslationsFile(TranslationsFile newFile) async {
    uncompletedFiles.add(newFile);
    createdFile = newFile;
  }

  @override
  Future<void> endTranslationsFileCreation() async {
    createdFile = null;
  }

  @override
  Future<TranslationsFile?> getCurrentCreatedFile() async {
    return createdFile;
  }

  @override
  Future<List<TranslationsFile>> getUncompletedTranslationsFiles() async {
    return uncompletedFiles;
  }

  @override
  Future<void> updateTranslation(int fileId, Translation translation, Translation lastTranslation) async {
    final translationsFile = uncompletedFiles.firstWhere((tF) => tF.id == fileId);
    final translationIndex = translationsFile.translations
        .indexWhere((t) => t.id == lastTranslation.id);
    translationsFile.translations[translationIndex] = translation;
  }

  @override
  Future<void> saveUncompletedTranslation(String photoUrl) async {
    final id = Random().nextInt(999999999);
    final translation = Translation(id: id, text: null, imgUrl: photoUrl);
    createdFile?.translations.add(translation);
  }

  @override
  Future<Translation> translate(Translation uncompletedTranslation, int translationsFileId) async {
    _translating = true;
    final imgUrl = uncompletedTranslation.imgUrl;
    final fixedImage = await rotationFixer.fix(imgUrl);
    final translationText = await translator.translate(imgUrl);
    final newTranslation = Translation(
        id: uncompletedTranslation.id, 
        text: translationText, 
        imgUrl: imgUrl
    );
    final translationsFile = uncompletedFiles.firstWhere(
      (tF) => tF.id == translationsFileId
    );
    final translationIndex = translationsFile.translations.indexWhere(
      (t) => t.id == newTranslation.id
    );
    translationsFile.translations[translationIndex] = newTranslation;
    _translating = false;
    return newTranslation;
  }

  @override
  Future<bool> get translating async {
    return _translating;
  }

  @override
  Future<List<PdfFile>> getCompletedTranslationsFiles() async {
    return completedFiles;
  }

  @override
  Future<void> addPdfFile(PdfFile file)async{
    completedFiles.add(file);
  }

  @override
  Future<void> updatePdfFiles(List<PdfFile> files)async{
    completedFiles = files;
  }
  
  @override
  Future<void> removeTranslationsFile(TranslationsFile file)async{
    uncompletedFiles.removeWhere((f) => f.id == file.id);
  }
  
  @override
  Future<TranslationsFile> getUncompletedTranslationsFile(int fileId)async{
    return uncompletedFiles.firstWhere((f) => f.id == fileId);
  }
}
