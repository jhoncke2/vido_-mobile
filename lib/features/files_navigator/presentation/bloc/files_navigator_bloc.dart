import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:vido/core/domain/entities/folder.dart';
import 'package:vido/core/domain/translations_transmitter.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigator_failure.dart';
import 'package:vido/features/files_navigator/presentation/files_transmitter/files_transmitter.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/get_current_file.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_appearance_pdf.dart';
import 'package:vido/core/domain/entities/app_file.dart';
import 'package:vido/core/domain/entities/pdf_file.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_file_pdf.dart';
import '../use_cases/generate_icr.dart';
import '../use_cases/load_folder_brothers.dart';
import '../use_cases/load_folder_children.dart';
import '../use_cases/search.dart';
import '../utils/waiter.dart';

part 'files_navigator_event.dart';
part 'files_navigator_state.dart';

class FilesNavigatorBloc extends Bloc<FilesNavigatorEvent, FilesNavigatorState> {

  static const generalErrorMessage = 'Ha ocurrido un error inesperado';
  static const noPermissionsErrorMessage = 'No tienes permiso para eso';
  static const tempErrorMillisecondsWait = 750;
  
  final LoadFolderChildren loadFolderChildren;
  final LoadFolderBrothers loadFolderBrothers;
  final LoadFilePdf loadFilePdf;
  final LoadAppearancePdf loadAppearancePdf;
  final Search search;
  final GenerateIcr generateIcr;
  final GetCurrentFile getCurrentFile;
  late List<AppFile> _lastAppFiles;
  final AppFilesTransmitter appFilesTransmitter;
  final TranslationsFilesTransmitter translationsFilesTransmitter;
  final TextEditingController searchController;
  final Waiter waiter;

  FilesNavigatorBloc({
    required this.loadFolderChildren,
    required this.loadFolderBrothers,
    required this.loadFilePdf,
    required this.loadAppearancePdf,
    required this.search,
    required this.generateIcr,
    required this.getCurrentFile,
    required this.appFilesTransmitter,
    required this.translationsFilesTransmitter,
    required this.searchController,
    required this.waiter
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
      }else if(event is SearchEvent){
        await _search(emit, event);
      }else if(event is RemoveSearchEvent){
        _removeSearch(emit);
      }else if(event is SelectSearchAppearanceEvent){
        await _selectSearchAppearance(emit, event);
      }else if(event is BackToSearchAppearancesEvent){
        _backToSearchAppearances(emit);
      }else if(event is LongPressFileEvent){
        await _longPressFileEvent(emit, event);
      }else if(event is GenerateIcrEvent){
        await _generateIcr(emit);
      }
    });
  }

  Future<void> _loadInitiapAppFiles(Emitter<FilesNavigatorState> emit)async{
    emit(OnLoadingAppFiles());
    await loadFolderChildren(null);
    final currentFileResult = await getCurrentFile();
    currentFileResult.fold((failure){
      final errorMessage = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
      emit(OnLoadingAppFilesError(
        message: errorMessage
      ));
    }, (currentFile){
      emit(OnAppFilesSuccess(
        parentFileCanBeCreatedOn: _getCanBeCreatedOnItFromFile(currentFile)
      ));
    });
  }

  bool _getCanBeCreatedOnItFromFile(AppFile file) => (file is Folder)? file.canBeCreatedOnIt: false;

  Future<void> _selectAppFile(Emitter<FilesNavigatorState> emit, SelectAppFileEvent event)async{
    final appFile = event.appFile;
    final parentCanBeCreatedOn = (state as OnAppFiles).parentFileCanBeCreatedOn;
    if(appFile is PdfFile){
      if(state is OnShowingUnselectedAppFiles){
        await _trySelectPdfToRead(appFile, emit, parentCanBeCreatedOn);
      }else{
        await _selectPdfToIcr(appFile, emit, parentCanBeCreatedOn);
      }
    }else if(state is OnShowingUnselectedAppFiles){//Si es Folder y no está en Icr, puede seleccionarlo
      await _trySelectFolderToRead(appFile as Folder, emit, parentCanBeCreatedOn);
    }
  }

  Future<void> _trySelectPdfToRead(PdfFile appFile, Emitter<FilesNavigatorState> emit, bool parentCanBeCreatedOn)async{
    if(appFile.canBeRead){
      emit(OnLoadingAppFiles());
      final pdfResult = await loadFilePdf(appFile);
      pdfResult.fold((error){
        emit(OnPdfFileError(
          message: error.message.isNotEmpty? error.message : generalErrorMessage,
          file: appFile,
          parentFileCanBeCreatedOn: parentCanBeCreatedOn
        ));
      }, (pdf){
        emit(OnPdfFileLoaded(
          file: appFile, 
          pdf: pdf,
          parentFileCanBeCreatedOn: parentCanBeCreatedOn
        ));
      });
    }else{
      emit(OnAppFilesError(
        message: noPermissionsErrorMessage, 
        parentFileCanBeCreatedOn: parentCanBeCreatedOn
      ));
      await waiter.wait(tempErrorMillisecondsWait);
      emit(OnAppFilesSuccess(
        parentFileCanBeCreatedOn: parentCanBeCreatedOn
      ));
    }
  }

  Future<void> _selectPdfToIcr(PdfFile appFile, Emitter<FilesNavigatorState> emit, bool parentCanBeCreatedOn)async{
    final filesIds = (state as OnIcrFilesSelectionSuccess).filesIds;
    if(appFile.canBeRead){
      if(filesIds.contains(appFile.id)){
        if(filesIds.length == 1){
          emit(OnAppFilesSuccess(
            parentFileCanBeCreatedOn: parentCanBeCreatedOn
          ));
        }else{
          final newList = List<int>.from(filesIds)
            ..remove(appFile.id);
          emit(OnIcrFilesSelectionSuccess(
            filesIds: newList,
            parentFileCanBeCreatedOn: parentCanBeCreatedOn
          ));
        }
      }else{
        emit(OnIcrFilesSelectionSuccess(
          filesIds: [...filesIds, appFile.id],
          parentFileCanBeCreatedOn: parentCanBeCreatedOn
        ));
      }
    }else{
      emit(OnIcrFilesSelectionError(
        message: noPermissionsErrorMessage, 
        filesIds: filesIds, 
        parentFileCanBeCreatedOn: parentCanBeCreatedOn
      ));
      await waiter.wait(tempErrorMillisecondsWait);
      emit(OnIcrFilesSelectionSuccess(
        filesIds: filesIds,
        parentFileCanBeCreatedOn: parentCanBeCreatedOn
      ));
    }
  }

  Future<void> _trySelectFolderToRead(Folder appFile, Emitter<FilesNavigatorState> emit, bool parentCanBeCreatedOn)async{
    if(appFile.canBeRead){
      emit(OnLoadingAppFiles());
      await loadFolderChildren(appFile.id);
      final currentFileResult = await getCurrentFile();
      currentFileResult.fold((failure){
        final errorMessage = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
        emit(OnAppFilesError(
          message: errorMessage,
          parentFileCanBeCreatedOn: parentCanBeCreatedOn
        ));
      }, (currentFile){
        emit(OnAppFilesSuccess(
          parentFileCanBeCreatedOn: _getCanBeCreatedOnItFromFile(currentFile)
        ));
      });
    }else{
      emit(OnAppFilesError(
        message: noPermissionsErrorMessage, 
        parentFileCanBeCreatedOn: parentCanBeCreatedOn
      ));
      await waiter.wait(tempErrorMillisecondsWait);
      emit(OnAppFilesSuccess(
        parentFileCanBeCreatedOn: parentCanBeCreatedOn
      ));
    }
  }
  
  Future<void> _selectFilesParent(Emitter<FilesNavigatorState> emit)async{
    final parentCanBeCreatedOn = (state as OnAppFiles).parentFileCanBeCreatedOn;
    emit(OnLoadingAppFiles());
    await loadFolderBrothers();
    final currentFileResult = await getCurrentFile();
    currentFileResult.fold((failure){
      final errorMessage = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
      emit(OnAppFilesError(
        message: errorMessage,
        parentFileCanBeCreatedOn: parentCanBeCreatedOn
      ));
    }, (currentFile){
      emit(OnAppFilesSuccess(
        parentFileCanBeCreatedOn: _getCanBeCreatedOnItFromFile(currentFile)
      ));
    });
  }

  Future<void> _search(Emitter<FilesNavigatorState> emit, SearchEvent event)async{
    final parentCanBeCreatedOn = (state as OnAppFiles).parentFileCanBeCreatedOn;
    if(searchController.text.isNotEmpty){
      emit(OnLoadingAppFiles());
      final appearancesResult = await search(searchController.text);
      appearancesResult.fold((failure){
        final message = failure.message.isNotEmpty? failure.message : generalErrorMessage;
        emit(OnSearchAppearancesError(
          message: message,
          parentFileCanBeCreatedOn: parentCanBeCreatedOn
        ));
      }, (appearances){
        emit(OnSearchAppearancesSuccessShowing(
          appearances: appearances,
          parentFileCanBeCreatedOn: parentCanBeCreatedOn
        ));
      });
    }
  }

  void _removeSearch(Emitter<FilesNavigatorState> emit){
    final parentCanBeCreatedOn = (state as OnAppFiles).parentFileCanBeCreatedOn;
    searchController.clear();
    emit(OnAppFilesSuccess(
      parentFileCanBeCreatedOn: parentCanBeCreatedOn
    ));
  }

  Future<void> _selectSearchAppearance(Emitter<FilesNavigatorState> emit, SelectSearchAppearanceEvent event)async{
    final parentCanBeCreatedOn = (state as OnAppFiles).parentFileCanBeCreatedOn;
    final appearances = (state as OnSearchAppearancesSuccess).appearances;
    emit(OnLoadingAppFiles());
    final pdfResult = await loadAppearancePdf(event.appearance);
    pdfResult.fold((failure){
      final message = failure.message.isNotEmpty? failure.message : generalErrorMessage;
      emit(OnSearchAppearancesPdfError(
        message: message,
        appearances: appearances,
        parentFileCanBeCreatedOn: parentCanBeCreatedOn
      ));
    }, (pdf){
      emit(OnSearchAppearancesPdfLoaded(
        pdf: pdf, 
        appearance: event.appearance, 
        appearances: appearances,
        parentFileCanBeCreatedOn: parentCanBeCreatedOn
      ));
    });
  }

  void _backToSearchAppearances(Emitter<FilesNavigatorState> emit){
    final parentCanBeCreatedOn = (state as OnAppFiles).parentFileCanBeCreatedOn;
    final appearances = (state as OnSearchAppearancesPdf).appearances;
    emit(OnSearchAppearancesSuccessShowing(
      parentFileCanBeCreatedOn: parentCanBeCreatedOn,
      appearances: appearances
    ));
  }

  Future<void> _longPressFileEvent(Emitter<FilesNavigatorState> emit, LongPressFileEvent event)async{
    final canBeRead = event.file.canBeRead;
    final parentCanBeCreatedOn = (state as OnAppFiles).parentFileCanBeCreatedOn;
    if(canBeRead){
      if(state is OnAppFilesSuccess){
        emit(OnIcrFilesSelectionSuccess(
          filesIds: [event.file.id],
          parentFileCanBeCreatedOn: parentCanBeCreatedOn
        ));
      }
    }else{
      emit(OnAppFilesError(
        message: noPermissionsErrorMessage, 
        parentFileCanBeCreatedOn: parentCanBeCreatedOn
      ));
      await waiter.wait(tempErrorMillisecondsWait);
      emit(OnAppFilesSuccess(
        parentFileCanBeCreatedOn: parentCanBeCreatedOn
      ));
    }
  }

  Future<void> _generateIcr(Emitter<FilesNavigatorState> emit)async{
    final parentCanBeCreatedOn = (state as OnAppFiles).parentFileCanBeCreatedOn;
    final filesIds = (state as OnIcrFilesSelectionSuccess).filesIds;
    emit(OnLoadingAppFiles());
    final icrResult = await generateIcr(filesIds);
    icrResult.fold((failure){
      _emitOnFailedIcr(failure, emit, filesIds, parentCanBeCreatedOn);
    }, (tableItems){
      _manageSuccessIcr(tableItems, emit, parentCanBeCreatedOn);
    });
  }

  void _emitOnFailedIcr(FilesNavigatorFailure failure, Emitter<FilesNavigatorState> emit, List<int> filesIds, bool parentCanBeCreatedOn){
    final message = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
    emit(OnIcrFilesSelectionError(
      filesIds: filesIds, 
      message: message,
      parentFileCanBeCreatedOn: parentCanBeCreatedOn
    ));
  }

  void _manageSuccessIcr(List<Map<String, dynamic>> tableItems, Emitter<FilesNavigatorState> emit, bool parentCanBeCreatedOn){
    final columnsHeads = tableItems.first.keys.toList();
    final List<List<String>> rows = [];
    for(final item in tableItems){
      final row = item.values.map<String>(
        (v) => v.toString()
      ).toList();
      rows.add(row);
    }
    emit(OnIcrTable(
      colsHeads: columnsHeads, 
      rows: rows,
      parentFileCanBeCreatedOn: parentCanBeCreatedOn
    ));
  }

  List<AppFile> get lastAppFiles => _lastAppFiles;
}