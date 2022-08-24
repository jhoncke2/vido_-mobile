import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vido/core/domain/translations_transmitter.dart';
import 'package:vido/features/files_navigator/presentation/files_transmitter/files_transmitter.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_pdf.dart';
import '../use_cases/load_folder_brothers.dart';
import '../use_cases/load_folder_children.dart';
import '../use_cases/search.dart';

part 'files_navigator_event.dart';
part 'files_navigator_state.dart';

class FilesNavigatorBloc extends Bloc<FilesNavigatorEvent, FilesNavigatorState> {
  final LoadFolderChildren loadFolderChildren;
  final LoadFolderBrothers loadFolderBrothers;
  final LoadPdf loadPdf;
  final Search search;

  late List<AppFile> _lastAppFiles;
  final AppFilesTransmitter appFilesTransmitter;
  final TranslationsFilesTransmitter translationsFilesTransmitter;
  
  FilesNavigatorBloc({
    required this.loadFolderChildren,
    required this.loadFolderBrothers,
    required this.loadPdf,
    required this.search,
    required this.appFilesTransmitter,
    required this.translationsFilesTransmitter
  }): super(OnFilesNavigatorInitial()) {
    _lastAppFiles = [];
    appFilesTransmitter.appFiles.listen((files){
      _lastAppFiles = files;
    });
    on<FilesNavigatorEvent>((event, emit) async {
      if(event is LoadInitialAppFilesEvent){
        await _loadInitiapAppFiles(emit);
      }else if(event is SelectAppFileEvent){
        await _selectAppFile(emit, event);
      }else if(event is SelectFilesParentEvent){
        await _selectFilesParent(emit);
      }
    });
  }

  Future<void> _loadInitiapAppFiles(Emitter<FilesNavigatorState> emit)async{
    emit(OnLoadingAppFiles());
    await loadFolderChildren(null);
    emit(OnAppFiles());
  }

  Future<void> _selectAppFile(Emitter<FilesNavigatorState> emit, SelectAppFileEvent event)async{
    emit(OnLoadingAppFiles());
    final appFile = event.appFile;
    if(appFile is PdfFile){
      final pdfResult = await loadPdf(appFile);
      pdfResult.fold((error){
        emit(OnPdfFileError(
          message: error.message.isNotEmpty? error.message : 'Ha ocurrido un error inesperado',
          file: appFile
        ));
      }, (pdf){
        emit(OnPdfFileLoaded(file: appFile, pdf: pdf));
      });
    }else{
      await loadFolderChildren(event.appFile.id);
      emit(OnAppFiles());
    }
  }
  
  Future<void> _selectFilesParent(Emitter<FilesNavigatorState> emit)async{
    emit(OnLoadingAppFiles());
    await loadFolderBrothers();
    emit(OnAppFiles());
  }

  List<AppFile> get lastAppFiles => _lastAppFiles;
}
