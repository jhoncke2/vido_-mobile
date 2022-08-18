import 'dart:async';
import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vido/core/external/photos_translator.dart';
import 'package:http/http.dart' as http;
import 'package:vido/core/utils/http_responses_manager.dart';
import 'package:vido/core/utils/image_rotation_fixer.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_local_data_source.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_remote_data_source.dart';
import 'package:vido/features/photos_translator/data/repository/photos_translator_repository_impl.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import 'package:vido/features/photos_translator/domain/use_cases/create_translators_file_impl.dart';
import 'package:vido/features/photos_translator/domain/use_cases/end_photos_translation_file_impl.dart';
import 'package:vido/features/photos_translator/domain/use_cases/get_completed_files_impl.dart';
import 'package:vido/features/photos_translator/domain/use_cases/get_uncompleted_translations_files_impl.dart';
import 'package:vido/features/photos_translator/domain/use_cases/translate_photo_impl.dart';
import 'package:vido/features/photos_translator/external/fake/photos_translator_local_data_source_fake.dart';
import 'package:vido/features/photos_translator/external/photos_translator_remote_adapter.dart';
import 'package:vido/features/photos_translator/external/photos_translator_remote_data_source_impl.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/create_translations_file.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/end_photos_translations_file.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/generate_pdf.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/get_completed_files.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/get_uncompleted_translations_files.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/translate_photo.dart';
import 'core/external/persistence.dart';
import 'core/utils/path_provider.dart';
import 'features/photos_translator/domain/use_cases/generate_pdf_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<PhotosTranslator>(() => PhotosTranslatorImpl());
  final cameras = await availableCameras();
  // ********** core
  sl.registerLazySingleton<http.Client>(() => http.Client());
  final db = await CustomDataBaseFactory.dataBase;
  sl.registerLazySingleton<Database>(() => db);
  sl.registerLazySingleton<PersistenceManager>(() => DataBaseManagerImpl(db: sl()));
  

  // ********** photos translator
  final adapter = PhotosTranslatorRemoteAdapterImpl();
  //sl.registerLazySingleton<PhotosTranslatorRemoteDataSource>(
  //    () => PhotosTranslatorRemoteDataSourceFake());
  sl.registerLazySingleton<PathProvider>(() => PathProviderImpl());
  sl.registerLazySingleton<HttpResponsesManager>(() => HttpResponsesManagerImpl());
  sl.registerLazySingleton<PhotosTranslatorRemoteDataSource>(
    () => PhotosTranslatorRemoteDataSourceImpl(
      client: sl<http.Client>(),
      adapter: adapter,
      pathProvider: sl<PathProvider>(),
      httpResponsesManager: sl<HttpResponsesManager>()
    )
  );
  sl.registerLazySingleton<ImageRotationFixer>(() => ImageRotationFixerImpl());
  final uncompletedTranslFilesStreamController =
      StreamController<List<TranslationsFile>>();
  final inCompletingProcessFileStreamController = 
      StreamController<List<TranslationsFile>>();
  final completedTranslFilesStreamController =
      StreamController<List<PdfFile>>();
  sl.registerLazySingleton<PhotosTranslatorLocalDataSource>(() =>
    PhotosTranslatorLocalDataSourceFake(
      translator: sl<PhotosTranslator>(),
      rotationFixer: sl<ImageRotationFixer>()
    )
  );
  sl.registerLazySingleton<PhotosTranslatorRepository>(() => PhotosTranslatorRepositoryImpl(
    remoteDataSource: sl<PhotosTranslatorRemoteDataSource>(),
    localDataSource: sl<PhotosTranslatorLocalDataSource>(),
    uncompletedFilesReceiver: uncompletedTranslFilesStreamController,
    inCompletingProcessFileReceiver: inCompletingProcessFileStreamController,
    completedFilesReceiver: completedTranslFilesStreamController
  ));
  sl.registerLazySingleton<CreateTranslationsFile>(
    () => CreateTranslationsFileImpl(repository: sl<PhotosTranslatorRepository>())
);
  sl.registerLazySingleton<EndPhotosTranslationsFile>(
    () => EndPhotosTranslationsFileImpl(repository: sl<PhotosTranslatorRepository>())
  );
  sl.registerLazySingleton<GetUncompletedTranslationsFiles>(
    () => GetUncompletedTranslationsFilesImpl(repository: sl<PhotosTranslatorRepository>())
  );
  sl.registerLazySingleton<TranslatePhoto>(
    () => TranslatePhotoImpl(repository: sl<PhotosTranslatorRepository>())
  );
  sl.registerLazySingleton<GetCompletedFiles>(
    () => GetCompletedFilesImpl(repository: sl<PhotosTranslatorRepository>())
  );
  sl.registerLazySingleton<GeneratePdf>(
    () => GeneratePdfImpl(repository: sl<PhotosTranslatorRepository>())
  );
  sl.registerFactory( () => PhotosTranslatorBloc(
    createTranslationsFile: sl<CreateTranslationsFile>(),
    translatePhoto: sl<TranslatePhoto>(),
    endPhotosTranslation: sl<EndPhotosTranslationsFile>(),
    getUncompletedTranslationsFiles: sl<GetUncompletedTranslationsFiles>(),
    getCompletedTranslationsFiles: sl<GetCompletedFiles>(),
    generatePdf: sl<GeneratePdf>(),
    uncompletedFilesStream: uncompletedTranslFilesStreamController.stream.asBroadcastStream(),
    inCompletingProcessFilesStream: inCompletingProcessFileStreamController.stream.asBroadcastStream(),
    completedFilesStream: completedTranslFilesStreamController.stream.asBroadcastStream(),
    cameras: cameras,
    getNewCameraController: (CameraDescription cam) => CameraController(
      cam,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    )
  ));
}
