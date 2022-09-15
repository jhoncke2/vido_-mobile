part of 'photos_translator_bloc.dart';

@immutable
abstract class PhotosTranslatorState extends Equatable{
  const PhotosTranslatorState();
  @override
  List<Object> get props => [runtimeType];
}

class OnPhotosTranslatorInitial extends PhotosTranslatorState {}

class OnSelectingFileType extends PhotosTranslatorState{
  
}

class OnLoadingTranslations extends PhotosTranslatorState {}

class OnLoadingTranslationsError extends PhotosTranslatorState {
  final String error;
  const OnLoadingTranslationsError({
    required this.error
  });
  @override
  List<Object> get props => [...super.props, error];
}

class OnSelectingCamera extends PhotosTranslatorState{

}

abstract class OnCreatingAppFile extends PhotosTranslatorState{
  final String name;
  final bool canEnd;
  const OnCreatingAppFile({
    required this.name,
    required this.canEnd
  });
  @override
  List<Object> get props => [...super.props, name, canEnd];
}

class OnCreatingTranslationsFile extends OnCreatingAppFile{
  final TranslationProccessType proccessType;
  const OnCreatingTranslationsFile({
    required String name,
    required this.proccessType,
    required bool canEnd
  }) : super(
    name: name,
    canEnd: canEnd
  );
  @override
  List<Object> get props => [...super.props, name, proccessType, canEnd];
}

class OnNamingTranslationsFile extends OnCreatingTranslationsFile{
  const OnNamingTranslationsFile({
    required String name,
    required TranslationProccessType proccessType,
    required bool canEnd,
  }): super(
    name: name,
    canEnd: canEnd,
    proccessType: proccessType
  );
}

class OnAddingTranslations extends OnCreatingTranslationsFile{
  final int id;
  final bool canTranslate;
  final CameraController? cameraController;
  const OnAddingTranslations({
    required this.id,
    required String name,
    required TranslationProccessType proccessType,
    required bool canEnd,
    required this.canTranslate,
    required this.cameraController
  }): super(
    name: name,
    proccessType: proccessType,
    canEnd: canEnd
  );
  @override
  List<Object> get props => [
    ...super.props, 
    id,
    canTranslate,
    cameraController?.cameraId??'', 
    cameraController?.resolutionPreset.index??'',
    cameraController?.enableAudio??'',
    cameraController?.imageFormatGroup?.index??''
  ];
}

class OnAppFileCreationEnded extends PhotosTranslatorState{
  
}

class OnCreatingFolder extends OnCreatingAppFile{
  const OnCreatingFolder({
    required String name, 
    required bool canEnd
  }) : super(name: name, canEnd: canEnd);
}