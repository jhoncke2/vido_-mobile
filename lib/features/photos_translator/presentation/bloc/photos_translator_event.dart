part of 'photos_translator_bloc.dart';

@immutable
abstract class PhotosTranslatorEvent {}

class InitFileTypeSelectionEvent extends PhotosTranslatorEvent{

}

class InitTranslationsFileCreationEvent extends PhotosTranslatorEvent{
  
}

class InitFolderCreationEvent extends PhotosTranslatorEvent{
  
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

class ChangeFileProccessTypeEvent extends PhotosTranslatorEvent{
  final TranslationProccessType proccessType;
  ChangeFileProccessTypeEvent(this.proccessType);
}

class EndFileInitializingEvent extends PhotosTranslatorEvent{

}

class AddPhotoTranslationEvent extends PhotosTranslatorEvent{

}

class EndTranslationsFileEvent extends PhotosTranslatorEvent{

}

class UpdateCompletedTranslationsFilesEvent extends PhotosTranslatorEvent{
  
}