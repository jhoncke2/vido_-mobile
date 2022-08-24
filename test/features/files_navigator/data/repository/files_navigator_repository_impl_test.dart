import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/domain/file_parent_type.dart';
import 'package:vido/core/external/user_extra_info_getter.dart';
import 'package:vido/features/files_navigator/data/app_files_receiver.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_local_data_source.dart';
import 'package:vido/features/files_navigator/data/data_sources/files_navigator_remote_data_source.dart';
import 'package:vido/features/files_navigator/data/repository/files_navigator_repository_impl.dart';
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart';
import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import 'package:vido/features/photos_translator/domain/entities/folder.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'files_navigator_repository_impl_test.mocks.dart';

late FilesNavigatorRepositoryImpl filesNavigatorRepository;
late MockFilesNavigatorRemoteDataSource remoteDataSource;
late MockFilesNavigatorLocalDataSource localDataSource;
late MockUserExtraInfoGetter userExtraInfoGetter;
late MockAppFilesReceiver appFilesReceiver;

@GenerateMocks([
  FilesNavigatorRemoteDataSource,
  FilesNavigatorLocalDataSource,
  UserExtraInfoGetter,
  AppFilesReceiver,
  File
])

void main(){
  setUp((){
    appFilesReceiver = MockAppFilesReceiver();
    userExtraInfoGetter = MockUserExtraInfoGetter();
    localDataSource = MockFilesNavigatorLocalDataSource();
    remoteDataSource = MockFilesNavigatorRemoteDataSource();
    filesNavigatorRepository = FilesNavigatorRepositoryImpl(
      remoteDataSource: remoteDataSource, 
      localDataSource: localDataSource, 
      userExtraInfoGetter: userExtraInfoGetter,
      appFilesReceiver: appFilesReceiver
    );
  });

  group('load folder children', _testLoadFolderChildrenGroup);
  group('load folder brothers', _testLoadFolderBrothersGroup);
  group('load pdf', _testLoadPdfGroup);
  group('search', _testSearchGroup);
}

void _testLoadFolderChildrenGroup(){
  late String tAccessToken;
  setUp((){
    tAccessToken = 'access_token';
    when(userExtraInfoGetter.getAccessToken())
        .thenAnswer((_) async => tAccessToken);
  });

  group('when the id is null', (){
    late List<AppFile> tFolderChildren;
    late int tParentId;
    late int? tTreeLvl;
    setUp((){
      tParentId = 100;
      tFolderChildren = [
        Folder(id: 0, name: 'fol_1', children: [], parentId: tParentId),
        PdfFile(id: 0, name: 'pdff_1', url: 'url_1', parentId: tParentId),
        PdfFile(id: 1, name: 'pdf_2', url: 'url_2', parentId: tParentId),
        Folder(id: 1, name: 'fol_2', children: [], parentId: tParentId)
      ];
    });

    group('when the tree level is null', (){
      late int tUserId;
      setUp((){
        tTreeLvl = null;
        tUserId = 100;
        when(localDataSource.getFilesTreeLevel())
            .thenAnswer((_) async => tTreeLvl);
        when(userExtraInfoGetter.getId())
            .thenAnswer((_) async => tUserId);
      });

      test('should call the specified methods', ()async{
        when(remoteDataSource.getChildren(any, any, any))
            .thenAnswer((_) async => tFolderChildren);
        await filesNavigatorRepository.loadFolderChildren(null);
        verify(userExtraInfoGetter.getAccessToken());
        verify(localDataSource.getFilesTreeLevel());
        verify(userExtraInfoGetter.getId());
        verify(remoteDataSource.getChildren(tUserId, FileParentType.user, tAccessToken));
        verify(appFilesReceiver.setAppFiles(tFolderChildren));
        verify(localDataSource.setFilesTreeLvl(0));
        verify(localDataSource.setParentId(tParentId));
      });

      test('should return the expected result when all goes good', ()async{
        when(remoteDataSource.getChildren(any, any, any))
            .thenAnswer((_) async => tFolderChildren);
        final result = await filesNavigatorRepository.loadFolderChildren(null);
        expect(result, const Right(null));
      });

      test('should return the expected result when there is an AppException', ()async{
        when(remoteDataSource.getChildren(any, any, any)).thenThrow(const ServerException(type: ServerExceptionType.UNHAUTORAIZED));
        final result = await filesNavigatorRepository.loadFolderChildren(null);
        expect(result, const Left(FilesNavigationFailure(exception: ServerException(type: ServerExceptionType.UNHAUTORAIZED), message: '')));
      });

      test('should return the expected result when there is another Exception', ()async{
        when(remoteDataSource.getChildren(any, any, any)).thenThrow(Exception());
        final result = await filesNavigatorRepository.loadFolderChildren(null);
        expect(result, const Left(FilesNavigationFailure(exception: AppException(''), message: 'Ha ocurrido un error inesperado')));
      });
    });

    group('when the tree level is 0', (){
      late int tUserId;
      setUp((){
        tTreeLvl = 0;
        tUserId = 100;
        when(localDataSource.getFilesTreeLevel())
            .thenAnswer((_) async => tTreeLvl);
        when(userExtraInfoGetter.getId())
            .thenAnswer((_) async => tUserId);
      });

      test('should call the specified methods', ()async{
        when(remoteDataSource.getChildren(any, any, any))
            .thenAnswer((_) async => tFolderChildren);
        await filesNavigatorRepository.loadFolderChildren(null);
        verify(userExtraInfoGetter.getAccessToken());
        verify(localDataSource.getFilesTreeLevel());
        verify(userExtraInfoGetter.getId());
        verify(remoteDataSource.getChildren(tUserId, FileParentType.user, tAccessToken));
        verify(appFilesReceiver.setAppFiles(tFolderChildren));
        verify(localDataSource.setParentId(tParentId));
        verifyNever(localDataSource.setFilesTreeLvl(any));
      });

      test('should return the expected result when all goes good', ()async{
        when(remoteDataSource.getChildren(any, any, any))
            .thenAnswer((_) async => tFolderChildren);
        final result = await filesNavigatorRepository.loadFolderChildren(null);
        expect(result, const Right(null));
      });

      test('should return the expected result when there is an AppException', ()async{
        when(remoteDataSource.getChildren(any, any, any)).thenThrow(const ServerException(type: ServerExceptionType.UNHAUTORAIZED));
        final result = await filesNavigatorRepository.loadFolderChildren(null);
        expect(result, const Left(FilesNavigationFailure(exception: ServerException(type: ServerExceptionType.UNHAUTORAIZED), message: '')));
      });

      test('should return the expected result when there is another Exception', ()async{
        when(remoteDataSource.getChildren(any, any, any)).thenThrow(Exception());
        final result = await filesNavigatorRepository.loadFolderChildren(null);
        expect(result, const Left(FilesNavigationFailure(exception: AppException(''), message: 'Ha ocurrido un error inesperado')));
      });
    });
    
    group('when the tree level is 1', (){
      late int tFileId;
      setUp((){
        tTreeLvl = 1;
        tFileId = 101;
        when(localDataSource.getFilesTreeLevel())
            .thenAnswer((_) async => tTreeLvl);
        when(localDataSource.getCurrentFileId())
            .thenAnswer((_) async => tFileId);
      });

      test('should call the specified methods', ()async{
        when(remoteDataSource.getChildren(any, any, any))
            .thenAnswer((_) async => tFolderChildren);
        await filesNavigatorRepository.loadFolderChildren(null);
        verify(userExtraInfoGetter.getAccessToken());
        verify(localDataSource.getFilesTreeLevel());
        verify(localDataSource.getCurrentFileId());
        verify(remoteDataSource.getChildren(tFileId, FileParentType.folder, tAccessToken));
        verify(appFilesReceiver.setAppFiles(tFolderChildren));
        verify(localDataSource.setParentId(tParentId));
        verifyNever(localDataSource.setFilesTreeLvl(any));
      });

      test('should return the expected result when all goes good', ()async{
        when(remoteDataSource.getChildren(any, any, any))
            .thenAnswer((_) async => tFolderChildren);
        final result = await filesNavigatorRepository.loadFolderChildren(null);
        expect(result, const Right(null));
      });

      test('should return the expected result when there is an AppException', ()async{
        when(remoteDataSource.getChildren(any, any, any)).thenThrow(const ServerException(type: ServerExceptionType.UNHAUTORAIZED));
        final result = await filesNavigatorRepository.loadFolderChildren(null);
        expect(result, const Left(FilesNavigationFailure(exception: ServerException(type: ServerExceptionType.UNHAUTORAIZED), message: '')));
      });

      test('should return the expected result when there is another Exception', ()async{
        when(remoteDataSource.getChildren(any, any, any)).thenThrow(Exception());
        final result = await filesNavigatorRepository.loadFolderChildren(null);
        expect(result, const Left(FilesNavigationFailure(exception: AppException(''), message: 'Ha ocurrido un error inesperado')));
      });
    });
  });

  group('when the id is not null', (){
    late int tId;
    late List<AppFile> tFolderChildren;
    late int tFilesTreeLvlInit;
    late int tFilesTreeLvlUpdated;
    setUp((){
      tId = 1002;
      tFolderChildren = const [
        Folder(id: 0, name: 'fol_1', children: [], parentId: 100),
        PdfFile(id: 0, name: 'pdff_1', url: 'url_1', parentId: 100),
        PdfFile(id: 1, name: 'pdf_2', url: 'url_2', parentId: 100),
        Folder(id: 1, name: 'fol_2', children: [], parentId: 100)
      ];
      tFilesTreeLvlInit = 2;
      tFilesTreeLvlUpdated = 3;
      when(localDataSource.getFilesTreeLevel())
          .thenAnswer((_) async => tFilesTreeLvlInit);
    });

    test('should call the specified methods', ()async{
      when(remoteDataSource.getChildren(any, any, any))
          .thenAnswer((_) async => tFolderChildren);
      await filesNavigatorRepository.loadFolderChildren(tId);
      verify(userExtraInfoGetter.getAccessToken());
      verify(remoteDataSource.getChildren(tId, FileParentType.folder, tAccessToken));
      verify(appFilesReceiver.setAppFiles(tFolderChildren));
      verify(localDataSource.getFilesTreeLevel());
      verify(localDataSource.setFilesTreeLvl(tFilesTreeLvlUpdated));
      verify(localDataSource.setCurrentFileId(tId));
      verifyNever(userExtraInfoGetter.getId());
    });

    test('should return the expected result when all goes good', ()async{
      when(remoteDataSource.getChildren(any, any, any))
          .thenAnswer((_) async => tFolderChildren);
      final result = await filesNavigatorRepository.loadFolderChildren(tId);
      expect(result, const Right(null));
    });

    test('should return the expected result when there is an AppException', ()async{
      when(remoteDataSource.getChildren(any, any, any)).thenThrow(const ServerException(type: ServerExceptionType.UNHAUTORAIZED));
      final result = await filesNavigatorRepository.loadFolderChildren(tId);
      expect(result, const Left(FilesNavigationFailure(exception: ServerException(type: ServerExceptionType.UNHAUTORAIZED), message: '')));
    });

    test('should return the expected result when there is another Exception', ()async{
      when(remoteDataSource.getChildren(any, any, any)).thenThrow(Exception());
      final result = await filesNavigatorRepository.loadFolderChildren(tId);
      expect(result, const Left(FilesNavigationFailure(exception: AppException(''), message: 'Ha ocurrido un error inesperado')));
    });
  });
}

void _testLoadFolderBrothersGroup(){
  late int tFilesTreeLvlInit;
  setUp((){
    when(localDataSource.getFilesTreeLevel())
        .thenAnswer((_) async => tFilesTreeLvlInit);
  });
  group('when files tree level is 1', (){
    late String tAccessToken;
    late int tCurrentFolderId;
    late int tFilesTreeLvlUpdated;
    late AppFile tParent;
    setUp((){
      tAccessToken = 'access_token';
      tFilesTreeLvlInit = 1;
      tFilesTreeLvlUpdated = 0;
      tCurrentFolderId = 1003;
      tParent = const Folder(
        id: 1080, 
        name: 'Parent', 
        parentId: 1070, 
        children: [
          Folder(id: 0, name: 'fol_1', children: [], parentId: 100),
          PdfFile(id: 0, name: 'pdff_1', url: 'url_1', parentId: 100),
          PdfFile(id: 1, name: 'pdf_2', url: 'url_2', parentId: 100),
          Folder(id: 1, name: 'fol_2', children: [], parentId: 100)
        ]
      );
      when(localDataSource.getCurrentFileId())
          .thenAnswer((_) async => tCurrentFolderId);
      when(userExtraInfoGetter.getAccessToken())
          .thenAnswer((_) async => tAccessToken);
    });

    test('should call the specified methods', ()async{
      when(remoteDataSource.getParentWithBrothers(any, any))
          .thenAnswer((_) async => tParent);
      await filesNavigatorRepository.loadFolderBrothers();
      verify(localDataSource.getFilesTreeLevel());
      verify(userExtraInfoGetter.getAccessToken());
      verify(localDataSource.getCurrentFileId());
      verify(remoteDataSource.getParentWithBrothers(tCurrentFolderId, tAccessToken));
      verify(appFilesReceiver.setAppFiles((tParent as Folder).children));
      verify(localDataSource.setFilesTreeLvl(tFilesTreeLvlUpdated));
      verify(localDataSource.setCurrentFileId(tParent.id));
    });

    test('should return the expected result when all goes good', ()async{
      when(remoteDataSource.getParentWithBrothers(any, any))
          .thenAnswer((_) async => tParent);
      final result = await filesNavigatorRepository.loadFolderBrothers();
      expect(result, const Right(null));
    });

    test('should return the expected result when there is an AppException', ()async{
      when(remoteDataSource.getParentWithBrothers(any, any)).thenThrow(const ServerException(type: ServerExceptionType.UNHAUTORAIZED));
      final result = await filesNavigatorRepository.loadFolderBrothers();
      expect(result, const Left(FilesNavigationFailure(exception: ServerException(type: ServerExceptionType.UNHAUTORAIZED), message: '')));
    });

    test('should return the expected result when there is another Exception', ()async{
      when(remoteDataSource.getParentWithBrothers(any, any)).thenThrow(Exception());
      final result = await filesNavigatorRepository.loadFolderBrothers();
      expect(result, const Left(FilesNavigationFailure(exception: AppException(''), message: 'Ha ocurrido un error inesperado')));
    });
  });

  group('when the files tree level is 0', (){
    setUp((){
      tFilesTreeLvlInit = 0;
    });

    test('should call the specified methods', ()async{
      await filesNavigatorRepository.loadFolderBrothers();
      verify(localDataSource.getFilesTreeLevel());
      verifyNever(userExtraInfoGetter.getAccessToken());
      verifyNever(localDataSource.getCurrentFileId());
      verifyNever(remoteDataSource.getParentWithBrothers(any, any));
      verifyNever(appFilesReceiver.setAppFiles(any));
      verifyNever(localDataSource.setFilesTreeLvl(any));
    });

    test('should return the expected result', ()async{
      final result = await filesNavigatorRepository.loadFolderBrothers();
      expect(result, const Right(null));
    });
  });
}

void _testLoadPdfGroup(){
  late String tAccessToken;
  late PdfFile tFile;
  late MockFile tPdf;
  late int tTreeLvlInit;
  late int tTreeLvlUpdated;
  setUp((){
    tAccessToken = 'access_token';
    tFile = const PdfFile(id: 0, name: 'file_0', url: 'url_0', parentId: 100);
    tPdf = MockFile();
    tTreeLvlInit = 2;
    tTreeLvlUpdated = 3;
    when(tPdf.path).thenReturn('pdf_0');
    when(userExtraInfoGetter.getAccessToken()).thenAnswer((_) async => tAccessToken);
    when(localDataSource.getFilesTreeLevel()).thenAnswer((_) async => tTreeLvlInit);
  });

  test('should call the specified methods', ()async{
    when(remoteDataSource.getGeneratedPdf(any, any)).thenAnswer((_) async => tPdf);
    await filesNavigatorRepository.loadPdf(tFile);
    verify(userExtraInfoGetter.getAccessToken());
    verify(remoteDataSource.getGeneratedPdf(tFile, tAccessToken));
    verify(localDataSource.setCurrentFileId(tFile.id));
    verify(localDataSource.getFilesTreeLevel());
    verify(localDataSource.setFilesTreeLvl(tTreeLvlUpdated));
  });

  test('should return the expected ordered states', ()async{
    when(remoteDataSource.getGeneratedPdf(any, any)).thenAnswer((_) async => tPdf);
    final result = await filesNavigatorRepository.loadPdf(tFile);
    expect(result, Right(tPdf));
  });
  
  test('should return the expected result when there is an AppException', ()async{
    when(remoteDataSource.getGeneratedPdf(any, any)).thenThrow(const ServerException(type: ServerExceptionType.UNHAUTORAIZED));
    final result = await filesNavigatorRepository.loadPdf(tFile);
    expect(result, const Left(FilesNavigationFailure(exception: ServerException(type: ServerExceptionType.UNHAUTORAIZED), message: '')));
  });

  test('should return the expected result when there is another Exception', ()async{
    when(remoteDataSource.getGeneratedPdf(any, any)).thenThrow(Exception());
    final result = await filesNavigatorRepository.loadPdf(tFile);
    expect(result, const Left(FilesNavigationFailure(exception: AppException(''), message: 'Ha ocurrido un error inesperado')));
  });
}

void _testSearchGroup(){
  late String tText;
  late List<SearchAppearance> tSearchResult;
  setUp((){
    tText = 'search_text';
    tSearchResult = const [
      SearchAppearance(title: 'title_0', text: 'text_0', pdfUrl: 'url_0', pdfPage: 0),
      SearchAppearance(title: 'title_10', text: 'text_10', pdfUrl: 'url_10', pdfPage: 2),
      SearchAppearance(title: 'title_12', text: 'text_12', pdfUrl: 'url_12', pdfPage: 11)
    ];
  });

  test('should call the specified methods', ()async{
    when(remoteDataSource.search(any))
        .thenAnswer((_) async => tSearchResult);
    await filesNavigatorRepository.search(tText);
    verify(remoteDataSource.search(tText));
  });

  test('should return the expected result when all goes good', ()async{
    when(remoteDataSource.search(any))
        .thenAnswer((_) async => tSearchResult);
    final result = await filesNavigatorRepository.search(tText);
    expect(result, Right(tSearchResult));
  });

  test('should return the expected result when there is an AppException', ()async{
    when(remoteDataSource.search(any)).thenThrow(const ServerException(type: ServerExceptionType.UNHAUTORAIZED));
    final result = await filesNavigatorRepository.search(tText);
    expect(result, const Left(FilesNavigationFailure(exception: ServerException(type: ServerExceptionType.UNHAUTORAIZED), message: '')));
  });

  test('should return the expected result when there is another Exception', ()async{
    when(remoteDataSource.search(any)).thenThrow(Exception());
    final result = await filesNavigatorRepository.search(tText);
    expect(result, const Left(FilesNavigationFailure(exception: AppException(''), message: 'Ha ocurrido un error inesperado')));
  });
}