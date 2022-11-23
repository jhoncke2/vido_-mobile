part of 'files_navigator_bloc.dart';

@immutable
abstract class FilesNavigatorState extends Equatable{
  const FilesNavigatorState();
  @override
  List<Object> get props => [runtimeType];
}

class OnFilesNavigatorInitial extends FilesNavigatorState {}

class OnLoadingAppFiles extends FilesNavigatorState {}

abstract class OnError extends FilesNavigatorState{
  String get message;
}

class OnLoadingAppFilesError extends FilesNavigatorState implements OnError{
  @override
  final String message;
  const OnLoadingAppFilesError({
    required this.message
  });
  @override
  List<Object> get props => [...super.props, message];
}

abstract class OnAppFiles extends FilesNavigatorState{
  final bool parentFileCanBeCreatedOn;
  const OnAppFiles({
    required this.parentFileCanBeCreatedOn
  });
  @override
  List<Object> get props => [
    ...super.props,
    parentFileCanBeCreatedOn
  ];
}

abstract class OnShowingAppFiles extends OnAppFiles{
  const OnShowingAppFiles({
    required bool parentFileCanBeCreatedOn
  }) : super( parentFileCanBeCreatedOn: parentFileCanBeCreatedOn );
}

class OnAppFilesSuccess extends OnShowingAppFiles{
  const OnAppFilesSuccess({
    required bool parentFileCanBeCreatedOn
  }) : super(parentFileCanBeCreatedOn: parentFileCanBeCreatedOn);
}

class OnAppFilesError extends OnShowingAppFiles implements OnError{
  @override
  final String message;
  const OnAppFilesError({
    required this.message,
    required bool parentFileCanBeCreatedOn
  }) : super(parentFileCanBeCreatedOn: parentFileCanBeCreatedOn);
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

class OnPdfFile extends OnAppFiles{
  final PdfFile file;
  const OnPdfFile({
    required this.file,
    required bool parentFileCanBeCreatedOn
  }) : super(parentFileCanBeCreatedOn: parentFileCanBeCreatedOn);
  @override
  List<Object> get props => [file];
}

class OnPdfFileLoaded extends OnPdfFile implements OnPdfSuccess{
  @override
  final File pdf;
  const OnPdfFileLoaded({
    required PdfFile file,
    required this.pdf,
    required bool parentFileCanBeCreatedOn
  }): super(
    file: file,
    parentFileCanBeCreatedOn: parentFileCanBeCreatedOn
  );
  @override
  List<Object> get props => [...super.props, pdf.path];
}

class OnPdfFileError extends OnPdfFile implements OnPdfError{
  @override
  final String message;
  const OnPdfFileError({
    required PdfFile file,
    required this.message,
    required bool parentFileCanBeCreatedOn
  }): super(
    file: file,
    parentFileCanBeCreatedOn: parentFileCanBeCreatedOn
  );
  @override
  List<Object> get props => [...super.props, message];
}

abstract class OnSearchAppearances extends OnAppFiles{
  const OnSearchAppearances({
    required bool parentFileCanBeCreatedOn
  }) : super(parentFileCanBeCreatedOn: parentFileCanBeCreatedOn);

}

abstract class OnSearchAppearancesSuccess extends OnSearchAppearances{
  final List<SearchAppearance> appearances;
  const OnSearchAppearancesSuccess({
    required this.appearances,
    required bool parentFileCanBeCreatedOn
  }) : super(parentFileCanBeCreatedOn: parentFileCanBeCreatedOn);
  @override
  List<Object> get props => [
    ...super.props, 
    appearances
  ];
}

class OnSearchAppearancesSuccessShowing extends OnSearchAppearancesSuccess{
  const OnSearchAppearancesSuccessShowing({
    required List<SearchAppearance> appearances,
    required bool parentFileCanBeCreatedOn
  }): super(
    appearances: appearances,
    parentFileCanBeCreatedOn: parentFileCanBeCreatedOn
  );
}

class OnSearchAppearancesError extends OnSearchAppearances{
  final String message;
  const OnSearchAppearancesError({
    required this.message,
    required bool parentFileCanBeCreatedOn
  }) : super(parentFileCanBeCreatedOn: parentFileCanBeCreatedOn);
  @override
  List<Object> get props => [...super.props, message];
}

abstract class OnSearchAppearancesPdf extends OnSearchAppearancesSuccess{
  const OnSearchAppearancesPdf({
    required List<SearchAppearance> appearances,
    required bool parentFileCanBeCreatedOn
  }) : super(
    appearances: appearances,
    parentFileCanBeCreatedOn: parentFileCanBeCreatedOn
  );
}

class OnSearchAppearancesPdfLoaded extends OnSearchAppearancesPdf implements OnPdfSuccess{
  @override
  final File pdf;
  final SearchAppearance appearance;
  const OnSearchAppearancesPdfLoaded({
    required this.pdf,
    required this.appearance,
    required List<SearchAppearance> appearances,
    required bool parentFileCanBeCreatedOn
  }) : super(
    appearances: appearances,
    parentFileCanBeCreatedOn: parentFileCanBeCreatedOn
  );
  @override
  List<Object> get props => [...super.props, pdf];
}

class OnSearchAppearancesPdfError extends OnSearchAppearancesPdf implements OnPdfError{
  @override
  final String message;
  const OnSearchAppearancesPdfError({
    required this.message,
    required List<SearchAppearance> appearances,
    required bool parentFileCanBeCreatedOn
  }) : super(
    appearances: appearances,
    parentFileCanBeCreatedOn: parentFileCanBeCreatedOn
  );
  @override
  List<Object> get props => [...super.props, message];
}

class OnIcrFilesSelection extends OnShowingAppFiles{
  final List<int> filesIds;
  const OnIcrFilesSelection({
    required this.filesIds,
    required bool parentFileCanBeCreatedOn
  }) : super(parentFileCanBeCreatedOn: parentFileCanBeCreatedOn);
  @override
  List<Object> get props => [...super.props, filesIds];
}

class OnIcrFilesSelectionError extends OnIcrFilesSelection implements OnError{
  @override
  final String message;
  const OnIcrFilesSelectionError({
    required this.message,
    required List<int> filesIds,
    required bool parentFileCanBeCreatedOn
  }) : super(
    filesIds: filesIds,
    parentFileCanBeCreatedOn: parentFileCanBeCreatedOn
  );
  @override
  List<Object> get props => [...super.props, message];
}

class OnIcrTable extends OnAppFiles{
  final List<String> colsHeads;
  final List<List<String>> rows;
  const OnIcrTable({
    required this.colsHeads, 
    required this.rows,
    required bool parentFileCanBeCreatedOn
  }) : super( parentFileCanBeCreatedOn: parentFileCanBeCreatedOn ) ;
  @override
  List<Object> get props => [
    ...super.props, 
    colsHeads, 
    rows
  ];
}