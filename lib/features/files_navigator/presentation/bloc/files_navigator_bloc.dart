import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:vido/core/domain/translations_transmitter.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
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

part 'files_navigator_event.dart';
part 'files_navigator_state.dart';

class FilesNavigatorBloc extends Bloc<FilesNavigatorEvent, FilesNavigatorState> {

  static const generalErrorMessage = 'Ha ocurrido un error inesperado';
  
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
    required this.searchController
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
        _longPressFileEvent(emit, event);
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
      emit(OnAppFilesSuccess());
    });
  }

  Future<void> _selectAppFile(Emitter<FilesNavigatorState> emit, SelectAppFileEvent event)async{
    final appFile = event.appFile;
    if(appFile is PdfFile){
      if(state is OnAppFilesSuccess){
        emit(OnLoadingAppFiles());
        final pdfResult = await loadFilePdf(appFile);
        pdfResult.fold((error){
          emit(OnPdfFileError(
            message: error.message.isNotEmpty? error.message : 'Ha ocurrido un error inesperado',
            file: appFile
          ));
        }, (pdf){
          emit(OnPdfFileLoaded(file: appFile, pdf: pdf));
        });
      }else{
        final filesIds = (state as OnIcrFilesSelection).filesIds;
        if(filesIds.contains(appFile.id)){
          if(filesIds.length == 1){
            emit(OnAppFilesSuccess());
          }else{
            final newList = List<int>.from(filesIds)
              ..remove(appFile.id);
            emit(OnIcrFilesSelection(filesIds: newList));
          }
        }else{
          emit(OnIcrFilesSelection(filesIds: [...filesIds, event.appFile.id]));
        }
      }
    }else if(state is OnAppFilesSuccess){
      emit(OnLoadingAppFiles());
      await loadFolderChildren(event.appFile.id);
      final currentFileResult = await getCurrentFile();
      currentFileResult.fold((failure){
        final errorMessage = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
        emit(OnAppFilesError(
          message: errorMessage
        ));
      }, (currentFile){
        emit(OnAppFilesSuccess());
      });
    }
  }
  
  Future<void> _selectFilesParent(Emitter<FilesNavigatorState> emit)async{
    emit(OnLoadingAppFiles());
    await loadFolderBrothers();
    final currentFileResult = await getCurrentFile();
    currentFileResult.fold((failure){
      final errorMessage = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
      emit(OnAppFilesError(
        message: errorMessage
      ));
    }, (currentFile){
      emit(OnAppFilesSuccess());
    });
  }

  Future<void> _search(Emitter<FilesNavigatorState> emit, SearchEvent event)async{
    if(searchController.text.isNotEmpty){
      emit(OnLoadingAppFiles());
      final appearancesResult = await search(searchController.text);
      appearancesResult.fold((failure){
        final message = failure.message.isNotEmpty? failure.message : generalErrorMessage;
        emit(OnSearchAppearancesError(message: message));
      }, (appearances){
        emit(OnSearchAppearancesSuccessShowing(appearances: appearances));
      });
    }
  }

  void _removeSearch(Emitter<FilesNavigatorState> emit){
    searchController.clear();
    emit(OnAppFilesSuccess());
  }

  Future<void> _selectSearchAppearance(Emitter<FilesNavigatorState> emit, SelectSearchAppearanceEvent event)async{
    final appearances = (state as OnSearchAppearancesSuccess).appearances;
    emit(OnLoadingAppFiles());
    final pdfResult = await loadAppearancePdf(event.appearance);
    pdfResult.fold((failure){
      final message = failure.message.isNotEmpty? failure.message : generalErrorMessage;
      emit(OnSearchAppearancesPdfError(
        message: message,
        appearances: appearances
      ));
    }, (pdf){
      emit(OnSearchAppearancesPdfLoaded(pdf: pdf, appearance: event.appearance, appearances: appearances));
    });
  }

  void _backToSearchAppearances(Emitter<FilesNavigatorState> emit){
    final appearances = (state as OnSearchAppearancesPdf).appearances;
    emit(OnSearchAppearancesSuccessShowing(appearances: appearances));
  }

  void _longPressFileEvent(Emitter<FilesNavigatorState> emit, LongPressFileEvent event){
    if(state is OnAppFilesSuccess){
      emit(OnIcrFilesSelection(filesIds: [event.file.id]));
    }
  }

  Future<void> _generateIcr(Emitter<FilesNavigatorState> emit)async{
    final filesIds = (state as OnIcrFilesSelection).filesIds;
    emit(OnLoadingAppFiles());
    final icrResult = await generateIcr(filesIds);
    icrResult.fold((failure){
      final message = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
      emit(OnIcrFilesSelectionError(filesIds: filesIds, message: message));
    }, (tableItems){
      final columnsHeads = tableItems.first.keys.toList();
      final List<List<String>> rows = [];
      for(final item in tableItems){
        final row = item.values.map<String>(
          (v) => v.toString()
        ).toList();
        rows.add(row);
      }
      emit(OnIcrTable(colsHeads: columnsHeads, rows: rows));
    });
  }

  List<AppFile> get lastAppFiles => _lastAppFiles;
}