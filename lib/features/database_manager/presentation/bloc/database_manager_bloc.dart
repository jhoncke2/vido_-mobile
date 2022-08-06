import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';

import '../../external/database_manager_local_data_source.dart';
part 'database_manager_event.dart';
part 'database_manager_state.dart';

class DatabaseManagerBloc extends Bloc<DatabaseManagerEvent, DatabaseManagerState> {
  final DatabaseManagerLocalDataSource localDataSource; 
  DatabaseManagerBloc({
    required this.localDataSource
  }) : super(DatabaseManagerInitial()) {
    on<DatabaseManagerEvent>((event, emit)async{
      if(event is LoadPdfFiles){
        emit(OnLoadingPdfFiles());
        final pdfFiles = await localDataSource.getPdfFiles();
        emit(OnPdfFilesLoaded(files: pdfFiles));
      }else if(event is InitPdfFileCreation){
        emit(const OnCreatingPdfFile(file: PdfFile(id: 0, name: '', url: ''), canEnd: false));
      }else if(event is ChangePdfFileName){
        final currentFile = (state as OnCreatingPdfFile).file;
        final newFile = PdfFile(id: 0, name: event.name, url: currentFile.url);
        emit(OnCreatingPdfFile(file: newFile, canEnd: _fileIsCompleted(newFile)));
      }else if(event is ChangePdfUrl){
        final currentFile = (state as OnCreatingPdfFile).file;
        final newFile = PdfFile(id: 0, name: currentFile.name, url: event.url);
        emit(OnCreatingPdfFile(file: newFile, canEnd: _fileIsCompleted(newFile)));
      }else if(event is EndPdfFileCreation){
        final currentFile = (state as OnCreatingPdfFile).file;
        emit(OnLoadingPdfFiles());
        await localDataSource.addPdfFile(currentFile);
        final pdfFiles = await localDataSource.getPdfFiles();
        emit(OnPdfFilesLoaded(files: pdfFiles));
      }
    });
  }

  bool _fileIsCompleted(PdfFile file) => file.name.isNotEmpty && file.url.isNotEmpty;
}
