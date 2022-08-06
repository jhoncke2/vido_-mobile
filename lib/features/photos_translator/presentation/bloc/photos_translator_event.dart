part of 'photos_translator_bloc.dart';

@immutable
abstract class PhotosTranslatorEvent {}

class LoadTranslationsFilesEvent extends PhotosTranslatorEvent{
  
}

class InitTranslationsFileEvent extends PhotosTranslatorEvent{
  
}

class ChooseCameraEvent extends PhotosTranslatorEvent{
  final CameraDescription camera;
  ChooseCameraEvent({
    required this.camera
  });
}

class ChangeFileNameEvent extends PhotosTranslatorEvent{
  final String name;
  ChangeFileNameEvent(this.name);
}

class SaveCurrentFileNameEvent extends PhotosTranslatorEvent{

}

class AddPhotoTranslationEvent extends PhotosTranslatorEvent{

}

class EndTranslationsFileEvent extends PhotosTranslatorEvent{

}

class UpdateCompletedTranslationsFilesEvent extends PhotosTranslatorEvent{
  
}

class SelectPdfFileEvent extends PhotosTranslatorEvent{
  final PdfFile file;
  SelectPdfFileEvent(this.file);
}

class _UpdateUncompletedTranslationsFilesEvent extends PhotosTranslatorEvent{
  final List<TranslationsFile> files;
  _UpdateUncompletedTranslationsFilesEvent(this.files);
}