// Mocks generated by Mockito 5.3.0 from annotations
// in vido/test/features/init/domain/use_cases/there_is_authentication_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:vido/core/external/user_extra_info_getter.dart' as _i2;

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

/// A class which mocks [UserExtraInfoGetter].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserExtraInfoGetter extends _i1.Mock
    implements _i2.UserExtraInfoGetter {
  MockUserExtraInfoGetter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<String> getAccessToken() =>
      (super.noSuchMethod(Invocation.method(#getAccessToken, []),
          returnValue: _i3.Future<String>.value('')) as _i3.Future<String>);
  @override
  _i3.Future<int> getId() => (super.noSuchMethod(Invocation.method(#getId, []),
      returnValue: _i3.Future<int>.value(0)) as _i3.Future<int>);
}
