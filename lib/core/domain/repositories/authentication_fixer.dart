import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/failures.dart';

abstract class AuthenticationFixer{
  Future<Either<Failure, void>> reLogin();
}