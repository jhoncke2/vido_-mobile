import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:vido/core/external/app_files_remote_adapter.dart';
import 'package:vido/core/external/storage_pdf_picker.dart';
import 'package:vido/features/files_navigator/domain/user_cases/generate_icr_impl.dart';
import 'package:vido/features/files_navigator/external/files_navigator_remote_adapter.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/generate_icr.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/search.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/create_folder.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/create_pdf_file.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/pick_pdf.dart';
import 'core/external/persistence.dart';
import 'core/utils/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:vido/core/domain/translations_transmitter.dart';
import 'package:vido/core/domain/use_case_error_handler.dart';
import 'package:vido/core/external/photos_translator.dart';
import 'package:vido/core/external/shared_preferences_manager.dart';
import 'package:vido/core/utils/http_responses_manager.dart';
import 'package:vido/core/utils/image_rotation_fixer.dart';
import 'package:vido/features/authentication/data/data_sources/authentication_local_data_source.dart';
import 'package:vido/features/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:vido/features/authentication/data/repository/authentication_repository_impl.dart';
import 'package:vido/features/authentication/domain/repository/authentication_repository.dart';
import 'package:vido/features/authentication/domain/use_cases/login.dart';
import 'package:vido/features/authentication/external/data_sources/authentication_local_data_source_impl.dart';
import 'package:vido/features/authentication/external/data_sources/authentication_remote_adapter.dart';
import 'package:vido/features/authentication/external/data_sources/authentication_remote_data_source_impl.dart';
import 'package:vido/features/authentication/external/data_sources/fake/authentication_remote_data_source_fake.dart';
import 'package:vido/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:vido/features/authentication/presentation/use_cases/login.dart';
import 'package:vido/features/authentication/presentation/use_cases/logout.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_local_data_source.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_remote_data_source.dart';
import 'package:vido/features/files_navigator/data/repository/files_navigator_repository_impl.dart';
import 'package:vido/features/files_navigator/domain/app_files_transmitter_impl.dart';
import 'package:vido/features/files_navigator/domain/repository/files_navigator_repository.dart';
import 'package:vido/features/files_navigator/external/fake/files_navigator_remote_data_source_fake.dart';
import 'package:vido/features/files_navigator/external/files_navigator_local_data_source_impl.dart';
import 'package:vido/features/files_navigator/external/files_navigator_remote_data_source_impl.dart';
import 'package:vido/features/files_navigator/presentation/bloc/files_navigator_bloc.dart';
import 'package:vido/features/files_navigator/presentation/files_transmitter/files_transmitter.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_folder_brothers.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_folder_children.dart';
import 'package:vido/features/init/domain/use_cases/there_is_authentication_impl.dart';
import 'package:vido/features/init/presentation/bloc/init_bloc.dart';
import 'package:vido/features/init/presentation/use_cases/there_is_authentication.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_local_data_source.dart';
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_remote_data_source.dart';
import 'package:vido/features/photos_translator/data/repository/photos_translator_repository_impl.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/domain/repository/photos_translator_repository.dart';
import 'package:vido/features/photos_translator/domain/use_cases/create_translators_file_impl.dart';
import 'package:vido/features/photos_translator/domain/use_cases/end_photos_translation_file_impl.dart';
import 'package:vido/features/photos_translator/domain/use_cases/translate_photo_impl.dart';
import 'package:vido/features/photos_translator/external/photos_translator_local_data_source_impl.dart';
import 'package:vido/features/photos_translator/external/photos_translator_remote_adapter.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/create_translations_file.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/end_photos_translations_file.dart';
import 'package:vido/features/files_navigator/presentation/use_cases/load_file_pdf.dart';
import 'package:vido/features/photos_translator/presentation/use_cases/translate_photo.dart';
import 'features/authentication/domain/use_cases/logout.dart';
import 'features/files_navigator/domain/user_cases/load_appearance_pdf_impl.dart';
import 'features/files_navigator/domain/user_cases/load_file_pdf_impl.dart';
import 'features/files_navigator/domain/user_cases/load_folder_brothers_impl.dart';
import 'features/files_navigator/domain/user_cases/load_folder_children_impl.dart';
import 'features/files_navigator/domain/user_cases/search_impl.dart';
import 'features/files_navigator/presentation/use_cases/load_appearance_pdf.dart';
import 'features/photos_translator/domain/use_cases/create_folder_impl.dart';
import 'features/photos_translator/domain/use_cases/create_pdf_file.dart';
import 'features/photos_translator/domain/use_cases/pick_pdf_impl.dart';
import 'features/photos_translator/external/fake/photos_translator_remote_data_source_fake.dart';
import 'features/photos_translator/external/photos_translator_local_adapter.dart';
import 'features/photos_translator/external/photos_translator_remote_data_source_impl.dart';
import 'features/files_navigator/external/fake/files_tree.dart' as files_tree;

final sl = GetIt.instance;
bool useRealData = true;

Future<void> init() async {
  sl.registerLazySingleton<PhotosTranslator>(() => PhotosTranslatorImpl());
  final cameras = await availableCameras();
  // ********************************************** Core
  sl.registerLazySingleton<http.Client>(() => http.Client());
  final db = await CustomDataBaseFactory.dataBase;
  sl.registerLazySingleton<Database>(() => db);
  sl.registerLazySingleton<DatabaseManager>(() => DataBaseManagerImpl(db: sl()));
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<SharedPreferencesManager>(
    () => SharedPreferencesManagerImpl(preferences: sl<SharedPreferences>())
  );
  sl.registerLazySingleton<UseCaseErrorHandler>(
    () => UseCaseErrorHandlerImpl(authenticationFixer: sl<AuthenticationRepository>())
  );
  sl.registerLazySingleton<AppFilesRemoteAdapter>(
    () => AppFilesRemoteAdapterImpl()
  );
  sl.registerLazySingleton<StoragePdfPicker>(
    () => StoragePdfPickerImpl()
  );

  // ********************************************************* Authentication
  sl.registerLazySingleton<AuthenticationRemoteAdapter>(
    () => AuthenticationRemoteAdapterImpl()
  );
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => _implementRealOrFake(
      realImpl: AuthenticationRemoteDataSourceImpl(
        client: sl<http.Client>(), 
        adapter: sl<AuthenticationRemoteAdapter>()
      ), 
      fakeImpl: AuthenticationRemoteDataSourceFake()
    )
  );
  sl.registerLazySingleton<AuthenticationLocalDataSource>(
    () => AuthenticationLocalDataSourceImpl(
      preferencesManager: sl<SharedPreferencesManager>(), 
      dbManager: sl<DatabaseManager>()
    )
  );
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      remoteDataSource: sl<AuthenticationRemoteDataSource>(), 
      localDataSource: sl<AuthenticationLocalDataSource>()
    )
  );
  sl.registerLazySingleton<Login>(
    () => LoginImpl(
      errorHandler: sl<UseCaseErrorHandler>(), 
      repository: sl<AuthenticationRepository>()
    )
  );
  sl.registerLazySingleton<Logout>(
    () => LogoutImpl(
      errorHandler: sl<UseCaseErrorHandler>(), 
      repository: sl<AuthenticationRepository>()
    )
  );
  sl.registerFactory<AuthenticationBloc>(
    () => AuthenticationBloc(
      login: sl<Login>(), 
      logout: sl<Logout>()
    )
  );

  // ******************************************************** Files Navigator
  sl.registerLazySingleton<AppFilesTransmitter>(
    () => AppFilesTransmitterImpl(
      streamController: StreamController<List<AppFile>>()
    )
  );
  sl.registerLazySingleton<FilesNavigatorLocalDataSource>(
    () => FilesNavigatorLocalDataSourceImpl(
      sharedPreferencesManager: sl<SharedPreferencesManager>()
    )
  );
  sl.registerLazySingleton<FilesNavigatorRemoteAdapterImpl>(
    () => FilesNavigatorRemoteAdapterImpl()
  );
  sl.registerLazySingleton<FilesNavigatorRemoteDataSource>(
    () => _implementRealOrFake(
      realImpl: FilesNavigatorRemoteDataSourceImpl(
        pathProvider: sl<PathProvider>(),
        httpResponsesManager: sl<HttpResponsesManager>(),
        client: sl<http.Client>(),
        adapter: sl<FilesNavigatorRemoteAdapterImpl>()
      ), 
      fakeImpl: FilesNavigatorRemoteDataSourceFake(
        pathProvider: sl<PathProvider>(),
        httpResponsesManager: sl<HttpResponsesManager>(),
        filesTree: files_tree.appFiles
      )
    )
  );
  sl.registerLazySingleton<FilesNavigatorRepository>(
    () => FilesNavigatorRepositoryImpl(
      localDataSource: sl<FilesNavigatorLocalDataSource>(),
      remoteDataSource: sl<FilesNavigatorRemoteDataSource>(),
      appFilesReceiver: sl<AppFilesTransmitter>(),
      userExtraInfoGetter: sl<AuthenticationLocalDataSource>()
    )
  );
  sl.registerLazySingleton<LoadFolderChildren>(
    () => LoadFolderChildrenImpl(
      repository: sl<FilesNavigatorRepository>(),
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerLazySingleton<LoadFolderBrothers>(
    () => LoadFolderBrothersImpl(
      repository: sl<FilesNavigatorRepository>(),
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerLazySingleton<LoadFilePdf>(
    () => LoadFilePdfImpl(
      repository: sl<FilesNavigatorRepository>(),
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerLazySingleton<LoadAppearancePdf>(
    () => LoadAppearancePdfImpl(
      repository: sl<FilesNavigatorRepository>(),
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerLazySingleton<Search>(
    () => SearchImpl(
      repository: sl<FilesNavigatorRepository>(),
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerLazySingleton<GenerateIcr>(
    () => GenerateIcrImpl(
      repository: sl<FilesNavigatorRepository>(),
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerFactory<FilesNavigatorBloc>(
    () => FilesNavigatorBloc(
      loadFolderChildren: sl<LoadFolderChildren>(), 
      loadFolderBrothers: sl<LoadFolderBrothers>(), 
      loadFilePdf: sl<LoadFilePdf>(),
      loadAppearancePdf: sl<LoadAppearancePdf>(),
      search: sl<Search>(),
      generateIcr: sl<GenerateIcr>(),
      appFilesTransmitter: sl<AppFilesTransmitter>(), 
      translationsFilesTransmitter: sl<TranslationsFilesTransmitter>(),
      searchController: TextEditingController(text: '')
    )
  );

  // *************************************** Photos translator
  sl.registerLazySingleton<PhotosTranslatorRemoteAdapterImpl>(() => PhotosTranslatorRemoteAdapterImpl());
  sl.registerLazySingleton<PhotosTranslatorLocalAdapter>(() => PhotosTranslatorLocalAdapterImpl());
  
  sl.registerLazySingleton<PathProvider>(() => PathProviderImpl());
  sl.registerLazySingleton<HttpResponsesManager>(() => HttpResponsesManagerImpl());
  ///*
  sl.registerLazySingleton<PhotosTranslatorRemoteDataSource>(
    () => _implementRealOrFake<PhotosTranslatorRemoteDataSource>(
      realImpl: PhotosTranslatorRemoteDataSourceImpl(
        client: sl<http.Client>(),
        adapter: sl<PhotosTranslatorRemoteAdapterImpl>(),
        pathProvider: sl<PathProvider>(),
        httpResponsesManager: sl<HttpResponsesManager>()
      ),
      fakeImpl: PhotosTranslatorRemoteDataSourceFake(
        persistenceManager: sl<DatabaseManager>(), 
        adapter: sl<PhotosTranslatorLocalAdapter>(), 
        pathProvider: sl<PathProvider>(), 
        httpResponsesManager: sl<HttpResponsesManager>(),
        filesTree: files_tree.appFiles
      )
    )
  );

  sl.registerLazySingleton<ImageRotationFixer>(() => ImageRotationFixerImpl());
  sl.registerLazySingleton<PhotosTranslatorLocalDataSource>(
    () => PhotosTranslatorLocalDataSourceImpl(
      adapter: sl<PhotosTranslatorLocalAdapter>(), 
      databaseManager: sl<DatabaseManager>(), 
      translator: sl<PhotosTranslator>(),
      rotationFixer: sl<ImageRotationFixer>(),
      storagePdfPicker: sl<StoragePdfPicker>()
    )
  );
  final translationsFilesController = StreamController<List<TranslationsFile>>();
  sl.registerLazySingleton<TranslationsFilesTransmitter>(
    () => TranslationsFilesTransmitterImpl(translationsFilesController: translationsFilesController)
  );
  sl.registerSingleton<PhotosTranslatorRepository>(PhotosTranslatorRepositoryImpl(
    remoteDataSource: sl<PhotosTranslatorRemoteDataSource>(),
    localDataSource: sl<PhotosTranslatorLocalDataSource>(),
    translationsFilesReceiver: sl<TranslationsFilesTransmitter>(),
    translFileParentFolderGetter: sl<FilesNavigatorLocalDataSource>(),
    userExtraInfoGetter: sl<AuthenticationLocalDataSource>()
  )..initPendingTranslations());
  sl.registerLazySingleton<CreateTranslationsFile>(
    () => CreateTranslationsFileImpl(
      repository: sl<PhotosTranslatorRepository>(),
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerLazySingleton<EndPhotosTranslationsFile>(
    () => EndPhotosTranslationsFileImpl(
      repository: sl<PhotosTranslatorRepository>(),
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerLazySingleton<TranslatePhoto>(
    () => TranslatePhotoImpl(
      repository: sl<PhotosTranslatorRepository>(),
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerLazySingleton<CreateFolder>(
    () => CreateFolderImpl(
      repository: sl<PhotosTranslatorRepository>(),
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerLazySingleton<PickPdf>(
    () => PickPdfImpl(
      repository: sl<PhotosTranslatorRepository>(),
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerLazySingleton<CreatePdfFile>(
    () => CreatePdfFileImpl(
      repository: sl<PhotosTranslatorRepository>(),
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerFactory<PhotosTranslatorBloc>( () => PhotosTranslatorBloc(
    createTranslationsFile: sl<CreateTranslationsFile>(),
    translatePhoto: sl<TranslatePhoto>(),
    endPhotosTranslation: sl<EndPhotosTranslationsFile>(),
    createFolder: sl<CreateFolder>(),
    pickPdf: sl<PickPdf>(),
    createPdfFile: sl<CreatePdfFile>(),
    cameras: cameras,
    getNewCameraController: (CameraDescription cam) => CameraController(
      cam,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    )
  ));

  // ********** Init
  sl.registerLazySingleton<ThereIsAuthentication>(
    () => ThereIsAuthenticationImpl(accessTokenGetter: sl<AuthenticationLocalDataSource>())
  );
  sl.registerLazySingleton<InitBloc>(
    () => InitBloc(thereIsAuthentication: sl<ThereIsAuthentication>())
  );
}

T _implementRealOrFake<T>({
  required T realImpl, 
  required T fakeImpl
}) => useRealData? realImpl
                 : fakeImpl;