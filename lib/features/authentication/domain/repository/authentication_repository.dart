import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/repositories/authentication_fixer.dart';
import 'package:vido/features/authentication/domain/entities/user.dart';
import '../failures/failures.dart';

abstract class AuthenticationRepository implements AuthenticationFixer{
  Future<Either<AuthenticationFailure, void>> login(User user);
  Future<Either<AuthenticationFailure, void>> logout();
}