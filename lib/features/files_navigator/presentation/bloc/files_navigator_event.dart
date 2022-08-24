part of 'files_navigator_bloc.dart';

@immutable
abstract class FilesNavigatorEvent {}

class LoadInitialAppFilesEvent extends FilesNavigatorEvent{
  
}

class SelectAppFileEvent extends FilesNavigatorEvent{
  final AppFile appFile;
  SelectAppFileEvent(this.appFile);
}

class SelectFilesParentEvent extends FilesNavigatorEvent{

}