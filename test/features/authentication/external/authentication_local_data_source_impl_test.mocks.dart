// Mocks generated by Mockito 5.3.0 from annotations
// in vido/test/features/authentication/external/authentication_local_data_source_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:vido/core/external/persistence.dart' as _i4;
import 'package:vido/core/external/shared_preferences_manager.dart' as _i2;

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

/// A class which mocks [SharedPreferencesManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharedPreferencesManager extends _i1.Mock
    implements _i2.SharedPreferencesManager {
  MockSharedPreferencesManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<String> getString(String? key) =>
      (super.noSuchMethod(Invocation.method(#getString, [key]),
          returnValue: _i3.Future<String>.value('')) as _i3.Future<String>);
  @override
  _i3.Future<void> setString(String? key, String? value) => (super.noSuchMethod(
      Invocation.method(#setString, [key, value]),
      returnValue: _i3.Future<void>.value(),
      returnValueForMissingStub: _i3.Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<void> remove(String? key) => (super.noSuchMethod(
      Invocation.method(#remove, [key]),
      returnValue: _i3.Future<void>.value(),
      returnValueForMissingStub: _i3.Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<void> clear() => (super.noSuchMethod(Invocation.method(#clear, []),
      returnValue: _i3.Future<void>.value(),
      returnValueForMissingStub: _i3.Future<void>.value()) as _i3.Future<void>);
}

/// A class which mocks [DatabaseManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabaseManager extends _i1.Mock implements _i4.DatabaseManager {
  MockDatabaseManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<Map<String, dynamic>>> queryAll(String? tableName) =>
      (super.noSuchMethod(Invocation.method(#queryAll, [tableName]),
              returnValue: _i3.Future<List<Map<String, dynamic>>>.value(
                  <Map<String, dynamic>>[]))
          as _i3.Future<List<Map<String, dynamic>>>);
  @override
  _i3.Future<Map<String, dynamic>> querySingleOne(String? tableName, int? id) =>
      (super.noSuchMethod(Invocation.method(#querySingleOne, [tableName, id]),
              returnValue:
                  _i3.Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i3.Future<Map<String, dynamic>>);
  @override
  _i3.Future<List<Map<String, dynamic>>> queryWhere(String? tableName,
          String? whereStatement, List<dynamic>? whereVariables) =>
      (super.noSuchMethod(
              Invocation.method(
                  #queryWhere, [tableName, whereStatement, whereVariables]),
              returnValue: _i3.Future<List<Map<String, dynamic>>>.value(
                  <Map<String, dynamic>>[]))
          as _i3.Future<List<Map<String, dynamic>>>);
  @override
  _i3.Future<int> insert(String? tableName, Map<String, dynamic>? data) =>
      (super.noSuchMethod(Invocation.method(#insert, [tableName, data]),
          returnValue: _i3.Future<int>.value(0)) as _i3.Future<int>);
  @override
  _i3.Future<void> update(
          String? tableName, Map<String, dynamic>? updatedData, int? id) =>
      (super.noSuchMethod(
              Invocation.method(#update, [tableName, updatedData, id]),
              returnValue: _i3.Future<void>.value(),
              returnValueForMissingStub: _i3.Future<void>.value())
          as _i3.Future<void>);
  @override
  _i3.Future<void> remove(String? tableName, int? id) => (super.noSuchMethod(
      Invocation.method(#remove, [tableName, id]),
      returnValue: _i3.Future<void>.value(),
      returnValueForMissingStub: _i3.Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<void> removeAll(String? tableName) => (super.noSuchMethod(
      Invocation.method(#removeAll, [tableName]),
      returnValue: _i3.Future<void>.value(),
      returnValueForMissingStub: _i3.Future<void>.value()) as _i3.Future<void>);
}
