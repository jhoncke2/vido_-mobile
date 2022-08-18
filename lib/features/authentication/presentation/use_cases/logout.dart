import 'package:dartz/dartz.dart';
import 'package:vido/features/authentication/domain/failures/failures.dart';

abstract class Logout{
  Future<Either<AuthenticationFailure, void>> call();
}