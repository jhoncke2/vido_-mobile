import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vido/features/files_navigation/presentation/use_cases/load_folder_children.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/generate_pdf.dart';
part 'files_navigator_event.dart';
part 'files_navigator_state.dart';

class FilesNavigatorBloc extends Bloc<FilesNavigatorEvent, FilesNavigatorState> {
  final LoadFolderChildren loadFolderChildren;
  final GeneratePdf generatePdf;

  final Stream<List<AppFile>> folderChildrenStream;
  final Stream<List<TranslationsFile>> translationsFilesStream;
  
  late List<AppFile> _lastFolderChildren;
  late List<TranslationsFile> _lastTranslationsFiles;
  
  FilesNavigatorBloc({
    required this.loadFolderChildren,
    required this.generatePdf,
    required this.folderChildrenStream,
    required this.translationsFilesStream
  }): super(FilesNavigatorInitial()) {
    _lastFolderChildren = [];
    _lastTranslationsFiles = [];
    //TODO: Verificar que la app funcione al quitarle estos .listen
    folderChildrenStream.listen((children) {
      _lastFolderChildren = children;
    });
    translationsFilesStream.listen((files) {
      _lastTranslationsFiles = files;
    });

    on<FilesNavigatorEvent>((event, emit) async {
      if(event is SelectPdfFileEvent){
        await _selectPdfFile(emit, event);
      }
    });
  }

  Future<void> _selectPdfFile(Emitter<FilesNavigatorState> emit, SelectPdfFileEvent event)async{
    emit(OnLoadingFiles());
    final eitherPdf = await generatePdf(event.file);
    eitherPdf.fold((_){

    }, (pdf){
      emit(OnPdfFileLoaded(file: event.file, pdf: pdf));
    });
  }
  
  List<AppFile> get lasFolderChildren => _lastFolderChildren;
  List<TranslationsFile> get lastUncompletedFiles => _lastTranslationsFiles;
}
