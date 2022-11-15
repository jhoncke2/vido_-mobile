part of 'photos_translator_bloc.dart';

@immutable
abstract class PhotosTranslatorEvent {}

class InitFileTypeSelectionEvent extends PhotosTranslatorEvent{

}

class InitTranslationsFileCreationEvent extends PhotosTranslatorEvent{
  
}

class InitFolderCreationEvent extends PhotosTranslatorEvent{
  
}

class InitPdfFileCreationEvent extends PhotosTranslatorEvent{

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

class PickPdfEvent extends PhotosTranslatorEvent{
  
}

class EndPdfFileCreationEvent extends PhotosTranslatorEvent{

}