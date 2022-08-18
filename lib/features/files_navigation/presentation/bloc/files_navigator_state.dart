part of 'files_navigation_bloc.dart';

@immutable
abstract class FilesNavigatorState extends Equatable{
  const FilesNavigatorState();
  @override
  List<Object> get props => [runtimeType];
}

class FilesNavigatorInitial extends FilesNavigatorState {}

class OnLoadingFiles extends FilesNavigatorState {}

class OnLoadingFilesError extends FilesNavigatorState {
  final String error;
  const OnLoadingFilesError({
    required this.error
  });
  @override
  List<Object> get props => [...super.props, error];
}

class OnPdfFileLoaded extends FilesNavigatorState{
  final PdfFile file;
  final File pdf;
  const OnPdfFileLoaded({
    required this.file,
    required this.pdf
  });
  @override
  List<Object> get props => [file, pdf.path];
}