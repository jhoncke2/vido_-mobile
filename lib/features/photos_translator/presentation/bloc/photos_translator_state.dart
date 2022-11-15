part of 'photos_translator_bloc.dart';

@immutable
abstract class PhotosTranslatorState extends Equatable{
  const PhotosTranslatorState();
  @override
  List<Object?> get props => [runtimeType];
}

class OnPhotosTranslatorInitial extends PhotosTranslatorState {}

abstract class OnError{
  String get message;
}

class OnSelectingFileType extends PhotosTranslatorState{
  
}

class OnLoadingTranslations extends PhotosTranslatorState {}

class OnLoadingTranslationsError extends PhotosTranslatorState {
  final String error;
  const OnLoadingTranslationsError({
    required this.error
  });
  @override
  List<Object?> get props => [...super.props, error];
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
  List<Object?> get props => [...super.props, name, canEnd];
}

class OnCreatingTranslationsFile extends OnCreatingAppFile{
  const OnCreatingTranslationsFile({
    required String name, 
    required bool canEnd
  }) : super(
    name: name,
    canEnd: canEnd
  );
  @override
  List<Object?> get props => [...super.props, name, canEnd];
}

class OnNamingTranslationsFile extends OnCreatingTranslationsFile{
  const OnNamingTranslationsFile({
    required String name,
    required bool canEnd,
  }): super(
    name: name,
    canEnd: canEnd
  );
}

class OnInitializingTranslations extends OnCreatingTranslationsFile{
  final int id;
  final bool canTranslate;
  final CameraController? cameraController;
  const OnInitializingTranslations({
    required this.id,
    required String name,
    required bool canEnd,
    required this.canTranslate,
    required this.cameraController
  }): super(
    name: name,
    canEnd: canEnd
  );
  @override
  List<Object?> get props => [
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
  }) : super(
    name: name, 
    canEnd: canEnd
  );
}

abstract class OnCreatingPdfFile extends OnCreatingAppFile{
  final File? pdf;
  const OnCreatingPdfFile({
    required String name,
    required bool canEnd,
    required this.pdf
  }): super(
    name: name,
    canEnd: canEnd
  );
  @override
  List<Object?> get props => [...super.props, pdf?.path];
}

class OnCreatingPdfFileSuccess extends OnCreatingPdfFile{
  const OnCreatingPdfFileSuccess({
    required String name,
    required bool canEnd,
    required File? pdf
  }): super(
    name: name,
    canEnd: canEnd,
    pdf: pdf
  );
}

class OnCreatingPdfFileError extends OnCreatingPdfFile implements OnError{
  @override
  final String message;
  const OnCreatingPdfFileError({
    required String name,
    required bool canEnd,
    required File? pdf,
    required this.message
  }): super(
    name: name,
    canEnd: canEnd,
    pdf: pdf
  );
  @override
  List<Object?> get props => [...super.props, message];
}