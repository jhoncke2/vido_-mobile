// Mocks generated by Mockito 5.3.0 from annotations
// in vido/test/features/files_navigator/presentation/bloc/files_navigator_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;
import 'dart:convert' as _i24;
import 'dart:io' as _i6;
import 'dart:typed_data' as _i25;
import 'dart:ui' as _i23;

import 'package:dartz/dartz.dart' as _i2;
import 'package:flutter/foundation.dart' as _i5;
import 'package:flutter/rendering.dart' as _i3;
import 'package:flutter/services.dart' as _i4;
import 'package:flutter/src/widgets/editable_text.dart' as _i21;
import 'package:flutter/src/widgets/framework.dart' as _i22;
import 'package:mockito/mockito.dart' as _i1;
import 'package:vido/core/domain/translations_transmitter.dart' as _i19;
import 'package:vido/features/files_navigator/domain/entities/search_appearance.dart'
    as _i14;
import 'package:vido/features/files_navigator/domain/failures/files_navigation_failure.dart'
    as _i9;
import 'package:vido/features/files_navigator/presentation/files_transmitter/files_transmitter.dart'
    as _i17;
import 'package:vido/features/files_navigator/presentation/use_cases/generate_icr.dart'
    as _i16;
import 'package:vido/features/files_navigator/presentation/use_cases/load_appearance_pdf.dart'
    as _i13;
import 'package:vido/features/files_navigator/presentation/use_cases/load_file_pdf.dart'
    as _i11;
import 'package:vido/features/files_navigator/presentation/use_cases/load_folder_brothers.dart'
    as _i10;
import 'package:vido/features/files_navigator/presentation/use_cases/load_folder_children.dart'
    as _i7;
import 'package:vido/features/files_navigator/presentation/use_cases/search.dart'
    as _i15;
import 'package:vido/core/domain/entities/app_file.dart'
    as _i18;
import 'package:vido/core/domain/entities/pdf_file.dart'
    as _i12;
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart'
    as _i20;

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

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeTextSelection_1 extends _i1.SmartFake implements _i3.TextSelection {
  _FakeTextSelection_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeTextEditingValue_2 extends _i1.SmartFake
    implements _i4.TextEditingValue {
  _FakeTextEditingValue_2(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeTextSpan_3 extends _i1.SmartFake implements _i3.TextSpan {
  _FakeTextSpan_3(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);

  @override
  String toString({_i5.DiagnosticLevel? minLevel = _i5.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeFile_4 extends _i1.SmartFake implements _i6.File {
  _FakeFile_4(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeUri_5 extends _i1.SmartFake implements Uri {
  _FakeUri_5(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeDirectory_6 extends _i1.SmartFake implements _i6.Directory {
  _FakeDirectory_6(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeDateTime_7 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_7(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeRandomAccessFile_8 extends _i1.SmartFake
    implements _i6.RandomAccessFile {
  _FakeRandomAccessFile_8(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeIOSink_9 extends _i1.SmartFake implements _i6.IOSink {
  _FakeIOSink_9(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeFileStat_10 extends _i1.SmartFake implements _i6.FileStat {
  _FakeFileStat_10(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeFileSystemEntity_11 extends _i1.SmartFake
    implements _i6.FileSystemEntity {
  _FakeFileSystemEntity_11(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [LoadFolderChildren].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoadFolderChildren extends _i1.Mock
    implements _i7.LoadFolderChildren {
  MockLoadFolderChildren() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<_i2.Either<_i9.FilesNavigationFailure, void>> call(int? id) =>
      (super.noSuchMethod(Invocation.method(#call, [id]),
          returnValue:
              _i8.Future<_i2.Either<_i9.FilesNavigationFailure, void>>.value(
                  _FakeEither_0<_i9.FilesNavigationFailure, void>(
                      this, Invocation.method(#call, [id])))) as _i8
          .Future<_i2.Either<_i9.FilesNavigationFailure, void>>);
}

/// A class which mocks [LoadFolderBrothers].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoadFolderBrothers extends _i1.Mock
    implements _i10.LoadFolderBrothers {
  MockLoadFolderBrothers() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<_i2.Either<_i9.FilesNavigationFailure, void>> call() =>
      (super.noSuchMethod(Invocation.method(#call, []),
          returnValue:
              _i8.Future<_i2.Either<_i9.FilesNavigationFailure, void>>.value(
                  _FakeEither_0<_i9.FilesNavigationFailure, void>(
                      this, Invocation.method(#call, [])))) as _i8
          .Future<_i2.Either<_i9.FilesNavigationFailure, void>>);
}

/// A class which mocks [LoadFilePdf].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoadFilePdf extends _i1.Mock implements _i11.LoadFilePdf {
  MockLoadFilePdf() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<_i2.Either<_i9.FilesNavigationFailure, _i6.File>> call(
          _i12.PdfFile? file) =>
      (super.noSuchMethod(Invocation.method(#call, [file]),
          returnValue:
              _i8.Future<_i2.Either<_i9.FilesNavigationFailure, _i6.File>>.value(
                  _FakeEither_0<_i9.FilesNavigationFailure, _i6.File>(
                      this, Invocation.method(#call, [file])))) as _i8
          .Future<_i2.Either<_i9.FilesNavigationFailure, _i6.File>>);
}

/// A class which mocks [LoadAppearancePdf].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoadAppearancePdf extends _i1.Mock implements _i13.LoadAppearancePdf {
  MockLoadAppearancePdf() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<_i2.Either<_i9.FilesNavigationFailure, _i6.File>> call(
          _i14.SearchAppearance? appearance) =>
      (super.noSuchMethod(Invocation.method(#call, [appearance]),
          returnValue:
              _i8.Future<_i2.Either<_i9.FilesNavigationFailure, _i6.File>>.value(
                  _FakeEither_0<_i9.FilesNavigationFailure, _i6.File>(
                      this, Invocation.method(#call, [appearance])))) as _i8
          .Future<_i2.Either<_i9.FilesNavigationFailure, _i6.File>>);
}

/// A class which mocks [Search].
///
/// See the documentation for Mockito's code generation for more information.
class MockSearch extends _i1.Mock implements _i15.Search {
  MockSearch() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<_i2.Either<_i9.FilesNavigationFailure, List<_i14.SearchAppearance>>>
      call(String? text) => (super.noSuchMethod(
          Invocation.method(#call, [text]),
          returnValue:
              _i8.Future<_i2.Either<_i9.FilesNavigationFailure, List<_i14.SearchAppearance>>>.value(
                  _FakeEither_0<_i9.FilesNavigationFailure, List<_i14.SearchAppearance>>(
                      this, Invocation.method(#call, [text])))) as _i8
          .Future<_i2.Either<_i9.FilesNavigationFailure, List<_i14.SearchAppearance>>>);
}

/// A class which mocks [GenerateIcr].
///
/// See the documentation for Mockito's code generation for more information.
class MockGenerateIcr extends _i1.Mock implements _i16.GenerateIcr {
  MockGenerateIcr() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<_i2.Either<_i9.FilesNavigationFailure, List<Map<String, dynamic>>>>
      call(List<int>? filesIds) => (super.noSuchMethod(
          Invocation.method(#call, [filesIds]),
          returnValue:
              _i8.Future<_i2.Either<_i9.FilesNavigationFailure, List<Map<String, dynamic>>>>.value(
                  _FakeEither_0<_i9.FilesNavigationFailure, List<Map<String, dynamic>>>(
                      this, Invocation.method(#call, [filesIds])))) as _i8
          .Future<_i2.Either<_i9.FilesNavigationFailure, List<Map<String, dynamic>>>>);
}

/// A class which mocks [AppFilesTransmitter].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppFilesTransmitter extends _i1.Mock
    implements _i17.AppFilesTransmitter {
  MockAppFilesTransmitter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Stream<List<_i18.AppFile>> get appFiles =>
      (super.noSuchMethod(Invocation.getter(#appFiles),
              returnValue: _i8.Stream<List<_i18.AppFile>>.empty())
          as _i8.Stream<List<_i18.AppFile>>);
  @override
  _i8.Future<void> setAppFiles(List<_i18.AppFile>? files) =>
      (super.noSuchMethod(Invocation.method(#setAppFiles, [files]),
              returnValue: _i8.Future<void>.value(),
              returnValueForMissingStub: _i8.Future<void>.value())
          as _i8.Future<void>);
}

/// A class which mocks [TranslationsFilesTransmitter].
///
/// See the documentation for Mockito's code generation for more information.
class MockTranslationsFilesTransmitter extends _i1.Mock
    implements _i19.TranslationsFilesTransmitter {
  MockTranslationsFilesTransmitter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Stream<List<_i20.TranslationsFile>> get translationsFiles =>
      (super.noSuchMethod(Invocation.getter(#translationsFiles),
              returnValue: _i8.Stream<List<_i20.TranslationsFile>>.empty())
          as _i8.Stream<List<_i20.TranslationsFile>>);
  @override
  _i8.Future<void> setTranslationsFiles(List<_i20.TranslationsFile>? files) =>
      (super.noSuchMethod(Invocation.method(#setTranslationsFiles, [files]),
              returnValue: _i8.Future<void>.value(),
              returnValueForMissingStub: _i8.Future<void>.value())
          as _i8.Future<void>);
}

/// A class which mocks [TextEditingController].
///
/// See the documentation for Mockito's code generation for more information.
class MockTextEditingController extends _i1.Mock
    implements _i21.TextEditingController {
  MockTextEditingController() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get text =>
      (super.noSuchMethod(Invocation.getter(#text), returnValue: '') as String);
  @override
  set text(String? newText) =>
      super.noSuchMethod(Invocation.setter(#text, newText),
          returnValueForMissingStub: null);
  @override
  set value(_i4.TextEditingValue? newValue) =>
      super.noSuchMethod(Invocation.setter(#value, newValue),
          returnValueForMissingStub: null);
  @override
  _i3.TextSelection get selection =>
      (super.noSuchMethod(Invocation.getter(#selection),
              returnValue:
                  _FakeTextSelection_1(this, Invocation.getter(#selection)))
          as _i3.TextSelection);
  @override
  set selection(_i3.TextSelection? newSelection) =>
      super.noSuchMethod(Invocation.setter(#selection, newSelection),
          returnValueForMissingStub: null);
  @override
  _i4.TextEditingValue get value => (super.noSuchMethod(
          Invocation.getter(#value),
          returnValue: _FakeTextEditingValue_2(this, Invocation.getter(#value)))
      as _i4.TextEditingValue);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i3.TextSpan buildTextSpan(
          {_i22.BuildContext? context,
          _i3.TextStyle? style,
          bool? withComposing}) =>
      (super.noSuchMethod(
          Invocation.method(#buildTextSpan, [], {
            #context: context,
            #style: style,
            #withComposing: withComposing
          }),
          returnValue: _FakeTextSpan_3(
              this,
              Invocation.method(#buildTextSpan, [], {
                #context: context,
                #style: style,
                #withComposing: withComposing
              }))) as _i3.TextSpan);
  @override
  void clear() => super.noSuchMethod(Invocation.method(#clear, []),
      returnValueForMissingStub: null);
  @override
  void clearComposing() =>
      super.noSuchMethod(Invocation.method(#clearComposing, []),
          returnValueForMissingStub: null);
  @override
  bool isSelectionWithinTextBounds(_i3.TextSelection? selection) =>
      (super.noSuchMethod(
          Invocation.method(#isSelectionWithinTextBounds, [selection]),
          returnValue: false) as bool);
  @override
  void addListener(_i23.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i23.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [File].
///
/// See the documentation for Mockito's code generation for more information.
class MockFile extends _i1.Mock implements _i6.File {
  MockFile() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.File get absolute => (super.noSuchMethod(Invocation.getter(#absolute),
          returnValue: _FakeFile_4(this, Invocation.getter(#absolute)))
      as _i6.File);
  @override
  String get path =>
      (super.noSuchMethod(Invocation.getter(#path), returnValue: '') as String);
  @override
  Uri get uri => (super.noSuchMethod(Invocation.getter(#uri),
      returnValue: _FakeUri_5(this, Invocation.getter(#uri))) as Uri);
  @override
  bool get isAbsolute =>
      (super.noSuchMethod(Invocation.getter(#isAbsolute), returnValue: false)
          as bool);
  @override
  _i6.Directory get parent => (super.noSuchMethod(Invocation.getter(#parent),
          returnValue: _FakeDirectory_6(this, Invocation.getter(#parent)))
      as _i6.Directory);
  @override
  _i8.Future<_i6.File> create({bool? recursive = false}) => (super.noSuchMethod(
          Invocation.method(#create, [], {#recursive: recursive}),
          returnValue: _i8.Future<_i6.File>.value(_FakeFile_4(
              this, Invocation.method(#create, [], {#recursive: recursive}))))
      as _i8.Future<_i6.File>);
  @override
  void createSync({bool? recursive = false}) => super.noSuchMethod(
      Invocation.method(#createSync, [], {#recursive: recursive}),
      returnValueForMissingStub: null);
  @override
  _i8.Future<_i6.File> rename(String? newPath) =>
      (super.noSuchMethod(Invocation.method(#rename, [newPath]),
              returnValue: _i8.Future<_i6.File>.value(
                  _FakeFile_4(this, Invocation.method(#rename, [newPath]))))
          as _i8.Future<_i6.File>);
  @override
  _i6.File renameSync(String? newPath) =>
      (super.noSuchMethod(Invocation.method(#renameSync, [newPath]),
              returnValue:
                  _FakeFile_4(this, Invocation.method(#renameSync, [newPath])))
          as _i6.File);
  @override
  _i8.Future<_i6.File> copy(String? newPath) =>
      (super.noSuchMethod(Invocation.method(#copy, [newPath]),
              returnValue: _i8.Future<_i6.File>.value(
                  _FakeFile_4(this, Invocation.method(#copy, [newPath]))))
          as _i8.Future<_i6.File>);
  @override
  _i6.File copySync(String? newPath) =>
      (super.noSuchMethod(Invocation.method(#copySync, [newPath]),
              returnValue:
                  _FakeFile_4(this, Invocation.method(#copySync, [newPath])))
          as _i6.File);
  @override
  _i8.Future<int> length() =>
      (super.noSuchMethod(Invocation.method(#length, []),
          returnValue: _i8.Future<int>.value(0)) as _i8.Future<int>);
  @override
  int lengthSync() =>
      (super.noSuchMethod(Invocation.method(#lengthSync, []), returnValue: 0)
          as int);
  @override
  _i8.Future<DateTime> lastAccessed() =>
      (super.noSuchMethod(Invocation.method(#lastAccessed, []),
              returnValue: _i8.Future<DateTime>.value(
                  _FakeDateTime_7(this, Invocation.method(#lastAccessed, []))))
          as _i8.Future<DateTime>);
  @override
  DateTime lastAccessedSync() => (super.noSuchMethod(
          Invocation.method(#lastAccessedSync, []),
          returnValue:
              _FakeDateTime_7(this, Invocation.method(#lastAccessedSync, [])))
      as DateTime);
  @override
  _i8.Future<dynamic> setLastAccessed(DateTime? time) =>
      (super.noSuchMethod(Invocation.method(#setLastAccessed, [time]),
          returnValue: _i8.Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  void setLastAccessedSync(DateTime? time) =>
      super.noSuchMethod(Invocation.method(#setLastAccessedSync, [time]),
          returnValueForMissingStub: null);
  @override
  _i8.Future<DateTime> lastModified() =>
      (super.noSuchMethod(Invocation.method(#lastModified, []),
              returnValue: _i8.Future<DateTime>.value(
                  _FakeDateTime_7(this, Invocation.method(#lastModified, []))))
          as _i8.Future<DateTime>);
  @override
  DateTime lastModifiedSync() => (super.noSuchMethod(
          Invocation.method(#lastModifiedSync, []),
          returnValue:
              _FakeDateTime_7(this, Invocation.method(#lastModifiedSync, [])))
      as DateTime);
  @override
  _i8.Future<dynamic> setLastModified(DateTime? time) =>
      (super.noSuchMethod(Invocation.method(#setLastModified, [time]),
          returnValue: _i8.Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  void setLastModifiedSync(DateTime? time) =>
      super.noSuchMethod(Invocation.method(#setLastModifiedSync, [time]),
          returnValueForMissingStub: null);
  @override
  _i8.Future<_i6.RandomAccessFile> open(
          {_i6.FileMode? mode = _i6.FileMode.read}) =>
      (super.noSuchMethod(Invocation.method(#open, [], {#mode: mode}),
              returnValue: _i8.Future<_i6.RandomAccessFile>.value(
                  _FakeRandomAccessFile_8(
                      this, Invocation.method(#open, [], {#mode: mode}))))
          as _i8.Future<_i6.RandomAccessFile>);
  @override
  _i6.RandomAccessFile openSync({_i6.FileMode? mode = _i6.FileMode.read}) =>
      (super.noSuchMethod(Invocation.method(#openSync, [], {#mode: mode}),
              returnValue: _FakeRandomAccessFile_8(
                  this, Invocation.method(#openSync, [], {#mode: mode})))
          as _i6.RandomAccessFile);
  @override
  _i8.Stream<List<int>> openRead([int? start, int? end]) =>
      (super.noSuchMethod(Invocation.method(#openRead, [start, end]),
          returnValue: _i8.Stream<List<int>>.empty()) as _i8.Stream<List<int>>);
  @override
  _i6.IOSink openWrite(
          {_i6.FileMode? mode = _i6.FileMode.write,
          _i24.Encoding? encoding = const _i24.Utf8Codec()}) =>
      (super.noSuchMethod(
          Invocation.method(#openWrite, [], {#mode: mode, #encoding: encoding}),
          returnValue: _FakeIOSink_9(
              this,
              Invocation.method(
                  #openWrite, [], {#mode: mode, #encoding: encoding}))) as _i6
          .IOSink);
  @override
  _i8.Future<_i25.Uint8List> readAsBytes() =>
      (super.noSuchMethod(Invocation.method(#readAsBytes, []),
              returnValue: _i8.Future<_i25.Uint8List>.value(_i25.Uint8List(0)))
          as _i8.Future<_i25.Uint8List>);
  @override
  _i25.Uint8List readAsBytesSync() =>
      (super.noSuchMethod(Invocation.method(#readAsBytesSync, []),
          returnValue: _i25.Uint8List(0)) as _i25.Uint8List);
  @override
  _i8.Future<String> readAsString(
          {_i24.Encoding? encoding = const _i24.Utf8Codec()}) =>
      (super.noSuchMethod(
          Invocation.method(#readAsString, [], {#encoding: encoding}),
          returnValue: _i8.Future<String>.value('')) as _i8.Future<String>);
  @override
  String readAsStringSync({_i24.Encoding? encoding = const _i24.Utf8Codec()}) =>
      (super.noSuchMethod(
          Invocation.method(#readAsStringSync, [], {#encoding: encoding}),
          returnValue: '') as String);
  @override
  _i8.Future<List<String>> readAsLines(
          {_i24.Encoding? encoding = const _i24.Utf8Codec()}) =>
      (super.noSuchMethod(
              Invocation.method(#readAsLines, [], {#encoding: encoding}),
              returnValue: _i8.Future<List<String>>.value(<String>[]))
          as _i8.Future<List<String>>);
  @override
  List<String> readAsLinesSync(
          {_i24.Encoding? encoding = const _i24.Utf8Codec()}) =>
      (super.noSuchMethod(
          Invocation.method(#readAsLinesSync, [], {#encoding: encoding}),
          returnValue: <String>[]) as List<String>);
  @override
  _i8.Future<_i6.File> writeAsBytes(List<int>? bytes,
          {_i6.FileMode? mode = _i6.FileMode.write, bool? flush = false}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #writeAsBytes, [bytes], {#mode: mode, #flush: flush}),
              returnValue: _i8.Future<_i6.File>.value(_FakeFile_4(this,
                  Invocation.method(#writeAsBytes, [bytes], {#mode: mode, #flush: flush}))))
          as _i8.Future<_i6.File>);
  @override
  void writeAsBytesSync(List<int>? bytes,
          {_i6.FileMode? mode = _i6.FileMode.write, bool? flush = false}) =>
      super.noSuchMethod(
          Invocation.method(
              #writeAsBytesSync, [bytes], {#mode: mode, #flush: flush}),
          returnValueForMissingStub: null);
  @override
  _i8.Future<_i6.File> writeAsString(String? contents,
          {_i6.FileMode? mode = _i6.FileMode.write,
          _i24.Encoding? encoding = const _i24.Utf8Codec(),
          bool? flush = false}) =>
      (super
          .noSuchMethod(Invocation.method(#writeAsString, [contents], {#mode: mode, #encoding: encoding, #flush: flush}),
              returnValue: _i8.Future<_i6.File>.value(_FakeFile_4(
                  this,
                  Invocation.method(#writeAsString, [
                    contents
                  ], {
                    #mode: mode,
                    #encoding: encoding,
                    #flush: flush
                  })))) as _i8.Future<_i6.File>);
  @override
  void writeAsStringSync(String? contents,
          {_i6.FileMode? mode = _i6.FileMode.write,
          _i24.Encoding? encoding = const _i24.Utf8Codec(),
          bool? flush = false}) =>
      super.noSuchMethod(
          Invocation.method(#writeAsStringSync, [contents],
              {#mode: mode, #encoding: encoding, #flush: flush}),
          returnValueForMissingStub: null);
  @override
  _i8.Future<bool> exists() =>
      (super.noSuchMethod(Invocation.method(#exists, []),
          returnValue: _i8.Future<bool>.value(false)) as _i8.Future<bool>);
  @override
  bool existsSync() => (super.noSuchMethod(Invocation.method(#existsSync, []),
      returnValue: false) as bool);
  @override
  _i8.Future<String> resolveSymbolicLinks() =>
      (super.noSuchMethod(Invocation.method(#resolveSymbolicLinks, []),
          returnValue: _i8.Future<String>.value('')) as _i8.Future<String>);
  @override
  String resolveSymbolicLinksSync() =>
      (super.noSuchMethod(Invocation.method(#resolveSymbolicLinksSync, []),
          returnValue: '') as String);
  @override
  _i8.Future<_i6.FileStat> stat() =>
      (super.noSuchMethod(Invocation.method(#stat, []),
              returnValue: _i8.Future<_i6.FileStat>.value(
                  _FakeFileStat_10(this, Invocation.method(#stat, []))))
          as _i8.Future<_i6.FileStat>);
  @override
  _i6.FileStat statSync() => (super.noSuchMethod(
          Invocation.method(#statSync, []),
          returnValue: _FakeFileStat_10(this, Invocation.method(#statSync, [])))
      as _i6.FileStat);
  @override
  _i8.Future<_i6.FileSystemEntity> delete({bool? recursive = false}) => (super
          .noSuchMethod(Invocation.method(#delete, [], {#recursive: recursive}),
              returnValue: _i8.Future<_i6.FileSystemEntity>.value(
                  _FakeFileSystemEntity_11(this,
                      Invocation.method(#delete, [], {#recursive: recursive}))))
      as _i8.Future<_i6.FileSystemEntity>);
  @override
  void deleteSync({bool? recursive = false}) => super.noSuchMethod(
      Invocation.method(#deleteSync, [], {#recursive: recursive}),
      returnValueForMissingStub: null);
  @override
  _i8.Stream<_i6.FileSystemEvent> watch(
          {int? events = 15, bool? recursive = false}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #watch, [], {#events: events, #recursive: recursive}),
              returnValue: _i8.Stream<_i6.FileSystemEvent>.empty())
          as _i8.Stream<_i6.FileSystemEvent>);
}
