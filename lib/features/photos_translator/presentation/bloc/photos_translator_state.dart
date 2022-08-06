part of 'photos_translator_bloc.dart';

@immutable
abstract class PhotosTranslatorState extends Equatable{
  const PhotosTranslatorState();
  @override
  List<Object> get props => [runtimeType];
}

class PhotosTranslatorInitial extends PhotosTranslatorState {}

class OnLoadingTranslations extends PhotosTranslatorState {}

class OnLoadingTranslationsError extends PhotosTranslatorState {
  final String error;
  const OnLoadingTranslationsError({
    required this.error
  });
  @override
  List<Object> get props => [...super.props, error];
}

class OnTranslationsFilesLoaded extends PhotosTranslatorState{
  final List<TranslationsFile> uncompletedFiles;
  final List<PdfFile> completedFiles;
  const OnTranslationsFilesLoaded({
    required this.uncompletedFiles,
    required this.completedFiles
  });
  @override
  List<Object> get props => [...super.props, uncompletedFiles, completedFiles];
}

class OnSelectingCamera extends PhotosTranslatorState{

}

class OnCreatingTranslationsFile extends PhotosTranslatorState{
  final String name;
  final bool canEnd;
  const OnCreatingTranslationsFile({
    required this.name, 
    required this.canEnd
  });
  @override
  List<Object> get props => [...super.props, name, canEnd];
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

class OnPdfFileLoaded extends PhotosTranslatorState{
  final PdfFile file;
  final File pdf;
  const OnPdfFileLoaded({
    required this.file,
    required this.pdf
  });
  @override
  List<Object> get props => [file, pdf.path];
}