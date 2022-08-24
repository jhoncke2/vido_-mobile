part of 'files_navigator_bloc.dart';

@immutable
abstract class FilesNavigatorState extends Equatable{
  const FilesNavigatorState();
  @override
  List<Object> get props => [runtimeType];
}

class OnFilesNavigatorInitial extends FilesNavigatorState {}

class OnLoadingAppFiles extends FilesNavigatorState {}

class OnLoadingAppFilesError extends FilesNavigatorState {
  final String error;
  const OnLoadingAppFilesError({
    required this.error
  });
  @override
  List<Object> get props => [...super.props, error];
}

class OnAppFiles extends FilesNavigatorState{
  
}

class OnPdfFile extends FilesNavigatorState{
  final PdfFile file;
  const OnPdfFile({
    required this.file
  });
  @override
  List<Object> get props => [file];
}

class OnPdfFileLoaded extends OnPdfFile{
  final File pdf;
  const OnPdfFileLoaded({
    required PdfFile file,
    required this.pdf
  }): super(file: file);
  @override
  List<Object> get props => [...super.props, pdf.path];
}

class OnPdfFileError extends OnPdfFile{
  final String message;
  const OnPdfFileError({
    required PdfFile file,
    required this.message
  }): super(file: file);
  @override
  List<Object> get props => [...super.props, message];
}