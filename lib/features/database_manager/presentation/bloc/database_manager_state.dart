part of 'database_manager_bloc.dart';

abstract class DatabaseManagerState extends Equatable {
  const DatabaseManagerState();
  
  @override
  List<Object> get props => [];
}

class DatabaseManagerInitial extends DatabaseManagerState {}

class OnLoadingPdfFiles extends DatabaseManagerState{

}

class OnPdfFilesLoaded extends DatabaseManagerState{
  final List<PdfFile> files;
  const OnPdfFilesLoaded({
    required this.files
  });
  @override
  List<Object> get props => [...super.props, files];
}

class OnCreatingPdfFile extends DatabaseManagerState{
  final PdfFile file;
  final bool canEnd;
  const OnCreatingPdfFile({
    required this.file, 
    required this.canEnd
  });
  @override
  List<Object> get props => [...super.props, file, canEnd];
}