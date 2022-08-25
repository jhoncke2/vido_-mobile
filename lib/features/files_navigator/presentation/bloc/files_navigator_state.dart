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

abstract class OnPdf{

}

abstract class OnPdfSuccess extends OnPdf{
  File get pdf;
}

abstract class OnPdfError extends OnPdf{
  String get message;
}

class OnPdfFile extends FilesNavigatorState{
  final PdfFile file;
  const OnPdfFile({
    required this.file
  });
  @override
  List<Object> get props => [file];
}

class OnPdfFileLoaded extends OnPdfFile implements OnPdfSuccess{
  @override
  final File pdf;
  const OnPdfFileLoaded({
    required PdfFile file,
    required this.pdf
  }): super(file: file);
  @override
  List<Object> get props => [...super.props, pdf.path];
}

class OnPdfFileError extends OnPdfFile implements OnPdfError{
  @override
  final String message;
  const OnPdfFileError({
    required PdfFile file,
    required this.message
  }): super(file: file);
  @override
  List<Object> get props => [...super.props, message];
}

abstract class OnSearchAppearances extends FilesNavigatorState{

}

abstract class OnSearchAppearancesSuccess extends OnSearchAppearances{
  final List<SearchAppearance> appearances;
  OnSearchAppearancesSuccess({
    required this.appearances
  });
  @override
  List<Object> get props => [...super.props, appearances];
}

class OnSearchAppearancesSuccessShowing extends OnSearchAppearancesSuccess{
  OnSearchAppearancesSuccessShowing({
    required List<SearchAppearance> appearances
  }): super(
    appearances: appearances
  );
}

class OnSearchAppearancesError extends OnSearchAppearances{
  final String message;
  OnSearchAppearancesError({
    required this.message
  });
  @override
  List<Object> get props => [...super.props, message];
}

abstract class OnSearchAppearancesPdf extends OnSearchAppearancesSuccess{
  OnSearchAppearancesPdf({
    required List<SearchAppearance> appearances
  }) : super(
    appearances: appearances
  );
}

class OnSearchAppearancesPdfLoaded extends OnSearchAppearancesPdf implements OnPdfSuccess{
  @override
  final File pdf;
  final SearchAppearance appearance;
  OnSearchAppearancesPdfLoaded({
    required this.pdf,
    required this.appearance,
    required List<SearchAppearance> appearances
  }) : super(
    appearances: appearances
  );
  @override
  List<Object> get props => [...super.props, pdf];
}

class OnSearchAppearancesPdfError extends OnSearchAppearancesPdf implements OnPdfError{
  @override
  final String message;
  OnSearchAppearancesPdfError({
    required this.message,
    required List<SearchAppearance> appearances
  }) : super(
    appearances: appearances
  );
  @override
  List<Object> get props => [...super.props, message];
}