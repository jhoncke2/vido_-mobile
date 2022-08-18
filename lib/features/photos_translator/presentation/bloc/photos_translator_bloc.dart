import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/create_translations_file.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/end_photos_translations_file.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/generate_pdf.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/get_completed_files.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/get_uncompleted_translations_files.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/translate_photo.dart';
part 'photos_translator_event.dart';
part 'photos_translator_state.dart';

class PhotosTranslatorBloc extends Bloc<PhotosTranslatorEvent, PhotosTranslatorState> {
  final CreateTranslationsFile createTranslationsFile;
  final TranslatePhoto translatePhoto;
  final EndPhotosTranslationsFile endPhotosTranslation;
  final GetUncompletedTranslationsFiles getUncompletedTranslationsFiles;
  final GetCompletedFiles getCompletedTranslationsFiles;
  final GeneratePdf generatePdf;

  final List<CameraDescription> cameras;
  final CameraController Function(CameraDescription) getNewCameraController;
  final Stream<List<TranslationsFile>> uncompletedFilesStream;
  final Stream<List<TranslationsFile>> inCompletingProcessFilesStream;
  final Stream<List<PdfFile>> completedFilesStream;
  
  late CameraController? cameraController;
  late List<TranslationsFile> _lastUncompletedFiles;
  late List<TranslationsFile> _lastInCompletingProcessFiles;
  late List<PdfFile> _lastCompletedFiles;
  PhotosTranslatorBloc({
    required this.createTranslationsFile,
    required this.translatePhoto,
    required this.endPhotosTranslation,
    required this.getUncompletedTranslationsFiles,
    required this.getCompletedTranslationsFiles,
    required this.generatePdf,
    required this.cameras,
    required this.getNewCameraController,
    required this.uncompletedFilesStream,
    required this.inCompletingProcessFilesStream,   
    required this.completedFilesStream
  }): super(PhotosTranslatorInitial()) {
    cameraController = null;
    _lastUncompletedFiles = [];
    _lastInCompletingProcessFiles = [];
    _lastCompletedFiles = [];
    //TODO: Verificar que la app funcione al quitarle estos .listen
    uncompletedFilesStream.listen((files) {
      _lastUncompletedFiles = files;
    });
    inCompletingProcessFilesStream.listen((files){
      _lastInCompletingProcessFiles = files;
    });
    completedFilesStream.listen((files){
      _lastCompletedFiles = files;
    });

    on<PhotosTranslatorEvent>((event, emit) async {
      if (event is LoadTranslationsFilesEvent) {
        await _loadTranslationsFiles(emit);
      } else if (event is InitTranslationsFileEvent) {
        await _initTranslationsFile(emit);
      } else if (event is ChooseCameraEvent) {
        await _chooseCamera(emit, event);
      } else if (event is ChangeFileNameEvent) {
        _changeFileName(emit, event);
      }else if(event is SaveCurrentFileNameEvent){
        await _saveCurrentFileName(emit);
      }else if (event is AddPhotoTranslationEvent) {
        await _addPhotoTranslation(emit);
      }  else if (event is EndTranslationsFileEvent) {
        await _endTranslationsFile(emit);
      }else if (event is _UpdateUncompletedTranslationsFilesEvent){
        _updateUncompletedTranslationsFiles(emit, event);
      }else if(event is UpdateCompletedTranslationsFilesEvent){
        await _updateCompletedTranslationsFiles(emit);
      }else if(event is SelectPdfFileEvent){
        await _selectPdfFile(emit, event);
      }
    });
  }

  Future<void> _loadTranslationsFiles(
      Emitter<PhotosTranslatorState> emit) async {
    emit(OnLoadingTranslations());
    final eitherUncompletedFiles = await getUncompletedTranslationsFiles();
    await eitherUncompletedFiles.fold(
      (uncompletedFailure)async{
        emit(OnLoadingTranslationsError(error: 'Error en los incompletos: ' + uncompletedFailure.message));
      }, 
      (uncompletedFiles)async{
        final eitherCompletedFiles = await getCompletedTranslationsFiles();
        eitherCompletedFiles.fold((completedFailure){
          emit(OnLoadingTranslationsError(error: 'Error en los completos: ' + completedFailure.message));
        }, (completedFiles){
          emit(OnTranslationsFilesLoaded(uncompletedFiles: uncompletedFiles, completedFiles: completedFiles));
        });
    });
  }

  Future<void> _initTranslationsFile(Emitter<PhotosTranslatorState> emit) async {
    emit(OnLoadingTranslations());
    if(cameraController == null){
      emit(OnSelectingCamera());
    }else{
      emit(const OnNamingTranslationsFile(name: '', canEnd: false));
    }
  }

  Future<void> _chooseCamera(Emitter<PhotosTranslatorState> emit, ChooseCameraEvent event) async {
    await cameraController?.dispose();
    cameraController = getNewCameraController(event.camera);
    await cameraController!.initialize();
    emit(const OnNamingTranslationsFile(name: '', canEnd: false));
  }

  void _changeFileName(Emitter<PhotosTranslatorState> emit, ChangeFileNameEvent event) {
    final newName = event.name;
    emit( OnNamingTranslationsFile(name: newName, canEnd: newName.isNotEmpty) );
  }
  
  Future<void> _saveCurrentFileName(Emitter<PhotosTranslatorState> emit)async{
    final name = (state as OnNamingTranslationsFile).name;
    emit(OnLoadingTranslations());
    final eitherId = await createTranslationsFile(name);
    eitherId.fold((_){

    }, (id){
      emit(OnInitializingTranslations(
        id: id, 
        name: name,
        canTranslate: true,
        canEnd: false, 
        cameraController: cameraController
      ));
    });
  }

  Future<void> _addPhotoTranslation(Emitter<PhotosTranslatorState> emit) async {
    final onCreatingState = (state as OnInitializingTranslations);
    emit(OnInitializingTranslations(
        id: onCreatingState.id,
        name: onCreatingState.name,
        canTranslate: false,
        canEnd: false,
        cameraController: onCreatingState.cameraController
      )
    );
    final picture = await onCreatingState.cameraController!.takePicture();
    emit(OnInitializingTranslations(
        id: onCreatingState.id,
        name: onCreatingState.name,
        canTranslate: true,
        canEnd: true,
        cameraController: onCreatingState.cameraController
      )
    );
    await translatePhoto(picture.path);
  }

  Future<void> _endTranslationsFile(Emitter<PhotosTranslatorState> emit) async {
    emit(OnLoadingTranslations());
    await endPhotosTranslation();
    final eitherUnCompletedTranslationsFiles = await getUncompletedTranslationsFiles();
    eitherUnCompletedTranslationsFiles.fold((l){

    }, (uncompletedFiles){
      emit(OnTranslationsFilesLoaded(uncompletedFiles: uncompletedFiles, completedFiles: const []));
    });
  }

  void _updateUncompletedTranslationsFiles(Emitter<PhotosTranslatorState> emit, _UpdateUncompletedTranslationsFilesEvent event){
    emit(OnTranslationsFilesLoaded(uncompletedFiles: event.files, completedFiles: const []));
  }

  Future<void> _updateCompletedTranslationsFiles(Emitter<PhotosTranslatorState> emit)async{
    final onFilesState = state as OnTranslationsFilesLoaded;
    emit(OnLoadingTranslations());
    final eitherCompletedFiles = await getCompletedTranslationsFiles();
    eitherCompletedFiles.fold((_){

    }, (files){
      emit(OnTranslationsFilesLoaded(uncompletedFiles: onFilesState.uncompletedFiles, completedFiles: files));
    });
  }

  Future<void> _selectPdfFile(Emitter<PhotosTranslatorState> emit, SelectPdfFileEvent event)async{
    emit(OnLoadingTranslations());
    final eitherPdf = await generatePdf(event.file);
    eitherPdf.fold((_){

    }, (pdf){
      emit(OnPdfFileLoaded(file: event.file, pdf: pdf));
    });
  }
  
  List<TranslationsFile> get lastUncompletedFiles => _lastUncompletedFiles;
  List<TranslationsFile> get lastInCreatingProcessFiles => _lastInCompletingProcessFiles;
  List<PdfFile> get lastCompletedFiles => _lastCompletedFiles;
}
