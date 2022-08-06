part of 'database_manager_bloc.dart';

abstract class DatabaseManagerEvent extends Equatable {
  const DatabaseManagerEvent();

  @override
  List<Object> get props => [];
}

class LoadPdfFiles extends DatabaseManagerEvent{

}

class InitPdfFileCreation extends DatabaseManagerEvent{

}

class ChangePdfFileName extends DatabaseManagerEvent{
  final String name;
  const ChangePdfFileName(this.name);
}

class ChangePdfUrl extends DatabaseManagerEvent{
  final String url;
  const ChangePdfUrl(this.url);
}

class EndPdfFileCreation extends DatabaseManagerEvent{
  
}