// Mocks generated by Mockito 5.3.0 from annotations
// in vido/test/features/photos_translator/data/repository/photos_translator_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:convert' as _i12;
import 'dart:io' as _i5;
import 'dart:typed_data' as _i13;

import 'package:mockito/mockito.dart' as _i1;
import 'package:vido/core/external/translations_file_parent_folder_getter.dart'
    as _i10;
import 'package:vido/core/external/user_extra_info_getter.dart' as _i11;
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_local_data_source.dart'
    as _i8;
import 'package:vido/features/photos_translator/data/data_sources/photos_translator_remote_data_source.dart'
    as _i6;
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart'
    as _i3;
import 'package:vido/features/photos_translator/domain/entities/translation.dart'
    as _i4;
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart'
    as _i2;
import 'package:vido/features/photos_translator/domain/translations_files_receiver.dart'
    as _i9;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeTranslationsFile_0 extends _i1.SmartFake
    implements _i2.TranslationsFile {
  _FakeTranslationsFile_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakePdfFile_1 extends _i1.SmartFake implements _i3.PdfFile {
  _FakePdfFile_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeTranslation_2 extends _i1.SmartFake implements _i4.Translation {
  _FakeTranslation_2(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeFile_3 extends _i1.SmartFake implements _i5.File {
  _FakeFile_3(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeUri_4 extends _i1.SmartFake implements Uri {
  _FakeUri_4(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeDirectory_5 extends _i1.SmartFake implements _i5.Directory {
  _FakeDirectory_5(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeDateTime_6 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_6(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeRandomAccessFile_7 extends _i1.SmartFake
    implements _i5.RandomAccessFile {
  _FakeRandomAccessFile_7(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeIOSink_8 extends _i1.SmartFake implements _i5.IOSink {
  _FakeIOSink_8(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeFileStat_9 extends _i1.SmartFake implements _i5.FileStat {
  _FakeFileStat_9(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeFileSystemEntity_10 extends _i1.SmartFake
    implements _i5.FileSystemEntity {
  _FakeFileSystemEntity_10(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [PhotosTranslatorRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockPhotosTranslatorRemoteDataSource extends _i1.Mock
    implements _i6.PhotosTranslatorRemoteDataSource {
  MockPhotosTranslatorRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i2.TranslationsFile> createTranslationsFile(
          String? name, int? parentId, String? accessToken) =>
      (super.noSuchMethod(Invocation.method(#createTranslationsFile, [name, parentId, accessToken]),
          returnValue: _i7.Future<_i2.TranslationsFile>.value(
              _FakeTranslationsFile_0(
                  this,
                  Invocation.method(#createTranslationsFile, [
                    name,
                    parentId,
                    accessToken
                  ])))) as _i7.Future<_i2.TranslationsFile>);
  @override
  _i7.Future<int> addTranslation(
          int? fileId, _i4.Translation? translation, String? accessToken) =>
      (super.noSuchMethod(
          Invocation.method(
              #addTranslation, [fileId, translation, accessToken]),
          returnValue: _i7.Future<int>.value(0)) as _i7.Future<int>);
  @override
  _i7.Future<_i3.PdfFile> endTranslationFile(int? id, String? accessToken) =>
      (super.noSuchMethod(
              Invocation.method(#endTranslationFile, [id, accessToken]),
              returnValue: _i7.Future<_i3.PdfFile>.value(_FakePdfFile_1(this,
                  Invocation.method(#endTranslationFile, [id, accessToken]))))
          as _i7.Future<_i3.PdfFile>);
  @override
  _i7.Future<void> createFolder(
          String? name, int? parentId, String? accessToken) =>
      (super.noSuchMethod(
              Invocation.method(#createFolder, [name, parentId, accessToken]),
              returnValue: _i7.Future<void>.value(),
              returnValueForMissingStub: _i7.Future<void>.value())
          as _i7.Future<void>);
}

/// A class which mocks [PhotosTranslatorLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockPhotosTranslatorLocalDataSource extends _i1.Mock
    implements _i8.PhotosTranslatorLocalDataSource {
  MockPhotosTranslatorLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get translating =>
      (super.noSuchMethod(Invocation.getter(#translating), returnValue: false)
          as bool);
  @override
  _i7.Future<void> createTranslationsFile(_i2.TranslationsFile? newFile) =>
      (super.noSuchMethod(Invocation.method(#createTranslationsFile, [newFile]),
              returnValue: _i7.Future<void>.value(),
              returnValueForMissingStub: _i7.Future<void>.value())
          as _i7.Future<void>);
  @override
  _i7.Future<void> saveUncompletedTranslation(String? photoUrl) =>
      (super.noSuchMethod(
              Invocation.method(#saveUncompletedTranslation, [photoUrl]),
              returnValue: _i7.Future<void>.value(),
              returnValueForMissingStub: _i7.Future<void>.value())
          as _i7.Future<void>);
  @override
  _i7.Future<_i4.Translation> translate(
          _i4.Translation? uncompletedTranslation, int? translationsFileId) =>
      (super.noSuchMethod(
              Invocation.method(
                  #translate, [uncompletedTranslation, translationsFileId]),
              returnValue: _i7.Future<_i4.Translation>.value(_FakeTranslation_2(
                  this,
                  Invocation.method(#translate, [uncompletedTranslation, translationsFileId]))))
          as _i7.Future<_i4.Translation>);
  @override
  _i7.Future<void> updateTranslation(
          int? fileId, _i4.Translation? translation) =>
      (super.noSuchMethod(
              Invocation.method(#updateTranslation, [fileId, translation]),
              returnValue: _i7.Future<void>.value(),
              returnValueForMissingStub: _i7.Future<void>.value())
          as _i7.Future<void>);
  @override
  _i7.Future<void> endTranslationsFileCreation() => (super.noSuchMethod(
      Invocation.method(#endTranslationsFileCreation, []),
      returnValue: _i7.Future<void>.value(),
      returnValueForMissingStub: _i7.Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<List<_i2.TranslationsFile>> getTranslationsFiles() =>
      (super.noSuchMethod(Invocation.method(#getTranslationsFiles, []),
              returnValue: _i7.Future<List<_i2.TranslationsFile>>.value(
                  <_i2.TranslationsFile>[]))
          as _i7.Future<List<_i2.TranslationsFile>>);
  @override
  _i7.Future<_i2.TranslationsFile> getTranslationsFile(int? fileId) =>
      (super.noSuchMethod(Invocation.method(#getTranslationsFile, [fileId]),
              returnValue: _i7.Future<_i2.TranslationsFile>.value(
                  _FakeTranslationsFile_0(
                      this, Invocation.method(#getTranslationsFile, [fileId]))))
          as _i7.Future<_i2.TranslationsFile>);
  @override
  _i7.Future<_i2.TranslationsFile?> getCurrentCreatedFile() =>
      (super.noSuchMethod(Invocation.method(#getCurrentCreatedFile, []),
              returnValue: _i7.Future<_i2.TranslationsFile?>.value())
          as _i7.Future<_i2.TranslationsFile?>);
  @override
  _i7.Future<void> removeTranslationsFile(_i2.TranslationsFile? file) =>
      (super.noSuchMethod(Invocation.method(#removeTranslationsFile, [file]),
              returnValue: _i7.Future<void>.value(),
              returnValueForMissingStub: _i7.Future<void>.value())
          as _i7.Future<void>);
}

/// A class which mocks [TranslationsFilesReceiver].
///
/// See the documentation for Mockito's code generation for more information.
class MockTranslationsFilesReceiver extends _i1.Mock
    implements _i9.TranslationsFilesReceiver {
  MockTranslationsFilesReceiver() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<void> setTranslationsFiles(List<_i2.TranslationsFile>? files) =>
      (super.noSuchMethod(Invocation.method(#setTranslationsFiles, [files]),
              returnValue: _i7.Future<void>.value(),
              returnValueForMissingStub: _i7.Future<void>.value())
          as _i7.Future<void>);
}

/// A class which mocks [TranslationsFileParentFolderGetter].
///
/// See the documentation for Mockito's code generation for more information.
class MockTranslationsFileParentFolderGetter extends _i1.Mock
    implements _i10.TranslationsFileParentFolderGetter {
  MockTranslationsFileParentFolderGetter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<int> getCurrentFileId() =>
      (super.noSuchMethod(Invocation.method(#getCurrentFileId, []),
          returnValue: _i7.Future<int>.value(0)) as _i7.Future<int>);
  @override
  _i7.Future<int?> getFilesTreeLevel() =>
      (super.noSuchMethod(Invocation.method(#getFilesTreeLevel, []),
          returnValue: _i7.Future<int?>.value()) as _i7.Future<int?>);
  @override
  _i7.Future<int> getParentId() =>
      (super.noSuchMethod(Invocation.method(#getParentId, []),
          returnValue: _i7.Future<int>.value(0)) as _i7.Future<int>);
}

/// A class which mocks [UserExtraInfoGetter].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserExtraInfoGetter extends _i1.Mock
    implements _i11.UserExtraInfoGetter {
  MockUserExtraInfoGetter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<String> getAccessToken() =>
      (super.noSuchMethod(Invocation.method(#getAccessToken, []),
          returnValue: _i7.Future<String>.value('')) as _i7.Future<String>);
  @override
  _i7.Future<int> getId() => (super.noSuchMethod(Invocation.method(#getId, []),
      returnValue: _i7.Future<int>.value(0)) as _i7.Future<int>);
}

/// A class which mocks [File].
///
/// See the documentation for Mockito's code generation for more information.
class MockFile extends _i1.Mock implements _i5.File {
  MockFile() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.File get absolute => (super.noSuchMethod(Invocation.getter(#absolute),
          returnValue: _FakeFile_3(this, Invocation.getter(#absolute)))
      as _i5.File);
  @override
  String get path =>
      (super.noSuchMethod(Invocation.getter(#path), returnValue: '') as String);
  @override
  Uri get uri => (super.noSuchMethod(Invocation.getter(#uri),
      returnValue: _FakeUri_4(this, Invocation.getter(#uri))) as Uri);
  @override
  bool get isAbsolute =>
      (super.noSuchMethod(Invocation.getter(#isAbsolute), returnValue: false)
          as bool);
  @override
  _i5.Directory get parent => (super.noSuchMethod(Invocation.getter(#parent),
          returnValue: _FakeDirectory_5(this, Invocation.getter(#parent)))
      as _i5.Directory);
  @override
  _i7.Future<_i5.File> create({bool? recursive = false}) => (super.noSuchMethod(
          Invocation.method(#create, [], {#recursive: recursive}),
          returnValue: _i7.Future<_i5.File>.value(_FakeFile_3(
              this, Invocation.method(#create, [], {#recursive: recursive}))))
      as _i7.Future<_i5.File>);
  @override
  void createSync({bool? recursive = false}) => super.noSuchMethod(
      Invocation.method(#createSync, [], {#recursive: recursive}),
      returnValueForMissingStub: null);
  @override
  _i7.Future<_i5.File> rename(String? newPath) =>
      (super.noSuchMethod(Invocation.method(#rename, [newPath]),
              returnValue: _i7.Future<_i5.File>.value(
                  _FakeFile_3(this, Invocation.method(#rename, [newPath]))))
          as _i7.Future<_i5.File>);
  @override
  _i5.File renameSync(String? newPath) =>
      (super.noSuchMethod(Invocation.method(#renameSync, [newPath]),
              returnValue:
                  _FakeFile_3(this, Invocation.method(#renameSync, [newPath])))
          as _i5.File);
  @override
  _i7.Future<_i5.File> copy(String? newPath) =>
      (super.noSuchMethod(Invocation.method(#copy, [newPath]),
              returnValue: _i7.Future<_i5.File>.value(
                  _FakeFile_3(this, Invocation.method(#copy, [newPath]))))
          as _i7.Future<_i5.File>);
  @override
  _i5.File copySync(String? newPath) =>
      (super.noSuchMethod(Invocation.method(#copySync, [newPath]),
              returnValue:
                  _FakeFile_3(this, Invocation.method(#copySync, [newPath])))
          as _i5.File);
  @override
  _i7.Future<int> length() =>
      (super.noSuchMethod(Invocation.method(#length, []),
          returnValue: _i7.Future<int>.value(0)) as _i7.Future<int>);
  @override
  int lengthSync() =>
      (super.noSuchMethod(Invocation.method(#lengthSync, []), returnValue: 0)
          as int);
  @override
  _i7.Future<DateTime> lastAccessed() =>
      (super.noSuchMethod(Invocation.method(#lastAccessed, []),
              returnValue: _i7.Future<DateTime>.value(
                  _FakeDateTime_6(this, Invocation.method(#lastAccessed, []))))
          as _i7.Future<DateTime>);
  @override
  DateTime lastAccessedSync() => (super.noSuchMethod(
          Invocation.method(#lastAccessedSync, []),
          returnValue:
              _FakeDateTime_6(this, Invocation.method(#lastAccessedSync, [])))
      as DateTime);
  @override
  _i7.Future<dynamic> setLastAccessed(DateTime? time) =>
      (super.noSuchMethod(Invocation.method(#setLastAccessed, [time]),
          returnValue: _i7.Future<dynamic>.value()) as _i7.Future<dynamic>);
  @override
  void setLastAccessedSync(DateTime? time) =>
      super.noSuchMethod(Invocation.method(#setLastAccessedSync, [time]),
          returnValueForMissingStub: null);
  @override
  _i7.Future<DateTime> lastModified() =>
      (super.noSuchMethod(Invocation.method(#lastModified, []),
              returnValue: _i7.Future<DateTime>.value(
                  _FakeDateTime_6(this, Invocation.method(#lastModified, []))))
          as _i7.Future<DateTime>);
  @override
  DateTime lastModifiedSync() => (super.noSuchMethod(
          Invocation.method(#lastModifiedSync, []),
          returnValue:
              _FakeDateTime_6(this, Invocation.method(#lastModifiedSync, [])))
      as DateTime);
  @override
  _i7.Future<dynamic> setLastModified(DateTime? time) =>
      (super.noSuchMethod(Invocation.method(#setLastModified, [time]),
          returnValue: _i7.Future<dynamic>.value()) as _i7.Future<dynamic>);
  @override
  void setLastModifiedSync(DateTime? time) =>
      super.noSuchMethod(Invocation.method(#setLastModifiedSync, [time]),
          returnValueForMissingStub: null);
  @override
  _i7.Future<_i5.RandomAccessFile> open(
          {_i5.FileMode? mode = _i5.FileMode.read}) =>
      (super.noSuchMethod(Invocation.method(#open, [], {#mode: mode}),
              returnValue: _i7.Future<_i5.RandomAccessFile>.value(
                  _FakeRandomAccessFile_7(
                      this, Invocation.method(#open, [], {#mode: mode}))))
          as _i7.Future<_i5.RandomAccessFile>);
  @override
  _i5.RandomAccessFile openSync({_i5.FileMode? mode = _i5.FileMode.read}) =>
      (super.noSuchMethod(Invocation.method(#openSync, [], {#mode: mode}),
              returnValue: _FakeRandomAccessFile_7(
                  this, Invocation.method(#openSync, [], {#mode: mode})))
          as _i5.RandomAccessFile);
  @override
  _i7.Stream<List<int>> openRead([int? start, int? end]) =>
      (super.noSuchMethod(Invocation.method(#openRead, [start, end]),
          returnValue: _i7.Stream<List<int>>.empty()) as _i7.Stream<List<int>>);
  @override
  _i5.IOSink openWrite(
          {_i5.FileMode? mode = _i5.FileMode.write,
          _i12.Encoding? encoding = const _i12.Utf8Codec()}) =>
      (super.noSuchMethod(
          Invocation.method(#openWrite, [], {#mode: mode, #encoding: encoding}),
          returnValue: _FakeIOSink_8(
              this,
              Invocation.method(
                  #openWrite, [], {#mode: mode, #encoding: encoding}))) as _i5
          .IOSink);
  @override
  _i7.Future<_i13.Uint8List> readAsBytes() =>
      (super.noSuchMethod(Invocation.method(#readAsBytes, []),
              returnValue: _i7.Future<_i13.Uint8List>.value(_i13.Uint8List(0)))
          as _i7.Future<_i13.Uint8List>);
  @override
  _i13.Uint8List readAsBytesSync() =>
      (super.noSuchMethod(Invocation.method(#readAsBytesSync, []),
          returnValue: _i13.Uint8List(0)) as _i13.Uint8List);
  @override
  _i7.Future<String> readAsString(
          {_i12.Encoding? encoding = const _i12.Utf8Codec()}) =>
      (super.noSuchMethod(
          Invocation.method(#readAsString, [], {#encoding: encoding}),
          returnValue: _i7.Future<String>.value('')) as _i7.Future<String>);
  @override
  String readAsStringSync({_i12.Encoding? encoding = const _i12.Utf8Codec()}) =>
      (super.noSuchMethod(
          Invocation.method(#readAsStringSync, [], {#encoding: encoding}),
          returnValue: '') as String);
  @override
  _i7.Future<List<String>> readAsLines(
          {_i12.Encoding? encoding = const _i12.Utf8Codec()}) =>
      (super.noSuchMethod(
              Invocation.method(#readAsLines, [], {#encoding: encoding}),
              returnValue: _i7.Future<List<String>>.value(<String>[]))
          as _i7.Future<List<String>>);
  @override
  List<String> readAsLinesSync(
          {_i12.Encoding? encoding = const _i12.Utf8Codec()}) =>
      (super.noSuchMethod(
          Invocation.method(#readAsLinesSync, [], {#encoding: encoding}),
          returnValue: <String>[]) as List<String>);
  @override
  _i7.Future<_i5.File> writeAsBytes(List<int>? bytes,
          {_i5.FileMode? mode = _i5.FileMode.write, bool? flush = false}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #writeAsBytes, [bytes], {#mode: mode, #flush: flush}),
              returnValue: _i7.Future<_i5.File>.value(_FakeFile_3(this,
                  Invocation.method(#writeAsBytes, [bytes], {#mode: mode, #flush: flush}))))
          as _i7.Future<_i5.File>);
  @override
  void writeAsBytesSync(List<int>? bytes,
          {_i5.FileMode? mode = _i5.FileMode.write, bool? flush = false}) =>
      super.noSuchMethod(
          Invocation.method(
              #writeAsBytesSync, [bytes], {#mode: mode, #flush: flush}),
          returnValueForMissingStub: null);
  @override
  _i7.Future<_i5.File> writeAsString(String? contents,
          {_i5.FileMode? mode = _i5.FileMode.write,
          _i12.Encoding? encoding = const _i12.Utf8Codec(),
          bool? flush = false}) =>
      (super
          .noSuchMethod(Invocation.method(#writeAsString, [contents], {#mode: mode, #encoding: encoding, #flush: flush}),
              returnValue: _i7.Future<_i5.File>.value(_FakeFile_3(
                  this,
                  Invocation.method(#writeAsString, [
                    contents
                  ], {
                    #mode: mode,
                    #encoding: encoding,
                    #flush: flush
                  })))) as _i7.Future<_i5.File>);
  @override
  void writeAsStringSync(String? contents,
          {_i5.FileMode? mode = _i5.FileMode.write,
          _i12.Encoding? encoding = const _i12.Utf8Codec(),
          bool? flush = false}) =>
      super.noSuchMethod(
          Invocation.method(#writeAsStringSync, [contents],
              {#mode: mode, #encoding: encoding, #flush: flush}),
          returnValueForMissingStub: null);
  @override
  _i7.Future<bool> exists() =>
      (super.noSuchMethod(Invocation.method(#exists, []),
          returnValue: _i7.Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  bool existsSync() => (super.noSuchMethod(Invocation.method(#existsSync, []),
      returnValue: false) as bool);
  @override
  _i7.Future<String> resolveSymbolicLinks() =>
      (super.noSuchMethod(Invocation.method(#resolveSymbolicLinks, []),
          returnValue: _i7.Future<String>.value('')) as _i7.Future<String>);
  @override
  String resolveSymbolicLinksSync() =>
      (super.noSuchMethod(Invocation.method(#resolveSymbolicLinksSync, []),
          returnValue: '') as String);
  @override
  _i7.Future<_i5.FileStat> stat() =>
      (super.noSuchMethod(Invocation.method(#stat, []),
              returnValue: _i7.Future<_i5.FileStat>.value(
                  _FakeFileStat_9(this, Invocation.method(#stat, []))))
          as _i7.Future<_i5.FileStat>);
  @override
  _i5.FileStat statSync() => (super.noSuchMethod(
          Invocation.method(#statSync, []),
          returnValue: _FakeFileStat_9(this, Invocation.method(#statSync, [])))
      as _i5.FileStat);
  @override
  _i7.Future<_i5.FileSystemEntity> delete({bool? recursive = false}) => (super
          .noSuchMethod(Invocation.method(#delete, [], {#recursive: recursive}),
              returnValue: _i7.Future<_i5.FileSystemEntity>.value(
                  _FakeFileSystemEntity_10(this,
                      Invocation.method(#delete, [], {#recursive: recursive}))))
      as _i7.Future<_i5.FileSystemEntity>);
  @override
  void deleteSync({bool? recursive = false}) => super.noSuchMethod(
      Invocation.method(#deleteSync, [], {#recursive: recursive}),
      returnValueForMissingStub: null);
  @override
  _i7.Stream<_i5.FileSystemEvent> watch(
          {int? events = 15, bool? recursive = false}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #watch, [], {#events: events, #recursive: recursive}),
              returnValue: _i7.Stream<_i5.FileSystemEvent>.empty())
          as _i7.Stream<_i5.FileSystemEvent>);
}
