import 'package:dartz/dartz.dart';
import '../../../../core/domain/failures.dart';

abstract class ThereIsAuthentication{
  Future<Either<Failure, bool>> call();
}