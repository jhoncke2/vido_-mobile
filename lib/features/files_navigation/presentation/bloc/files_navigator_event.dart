part of 'files_navigation_bloc.dart';

@immutable
abstract class FilesNavigatorEvent {}

class SelectPdfFileEvent extends FilesNavigatorEvent{
  final PdfFile file;
  SelectPdfFileEvent(this.file);
}

class _UpdateUncompletedTranslationsFilesEvent extends FilesNavigatorEvent{
  final List<TranslationsFile> files;
  _UpdateUncompletedTranslationsFilesEvent(this.files);
}