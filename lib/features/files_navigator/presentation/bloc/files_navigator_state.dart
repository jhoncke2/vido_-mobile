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
  final String message;
  const OnLoadingAppFilesError({
    required this.message
  });
  @override
  List<Object> get props => [...super.props, message];
}

abstract class OnAppFiles extends FilesNavigatorState{

}

abstract class OnError extends OnAppFiles{
  String get message;
}

class OnAppFilesSuccess extends OnAppFiles{
  late bool parentFileCanBeCreatedOn;
  OnAppFilesSuccess();
  @override
  List<Object> get props => [
    ...super.props, 
  ];
}

class OnAppFilesError extends OnAppFiles implements OnError{
  @override
  final String message;
  OnAppFilesError({
    required this.message
  });
  @override
  List<Object> get props => [...super.props, message];
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

class OnIcrFilesSelection extends OnAppFiles{
  final List<int> filesIds;
  OnIcrFilesSelection({
    required this.filesIds
  });
  @override
  List<Object> get props => [...super.props, filesIds];
}

class OnIcrFilesSelectionError extends OnIcrFilesSelection implements OnError{
  @override
  final String message;
  OnIcrFilesSelectionError({
    required this.message,
    required List<int> filesIds
  }) : super(filesIds: filesIds);
  @override
  List<Object> get props => [...super.props, message];
}

class OnIcrTable extends FilesNavigatorState{
  final List<String> colsHeads;
  final List<List<String>> rows;
  const OnIcrTable({
    required this.colsHeads, 
    required this.rows
  });

  @override
  List<Object> get props => [...super.props, colsHeads, rows];
}