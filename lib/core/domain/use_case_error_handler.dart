import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/failures.dart';
import 'package:vido/core/domain/repositories/authentication_fixer.dart';
import 'exceptions.dart';

abstract class UseCaseErrorHandler{
  Future<Either<N, B>> executeFunction<N extends Failure, B>(Future<Either<N, B>> Function() function);
}

class UseCaseErrorHandlerImpl implements UseCaseErrorHandler{
  final AuthenticationFixer authenticationFixer;
  const UseCaseErrorHandlerImpl({
    required this.authenticationFixer
  });

  @override
  Future<Either<N, B>> executeFunction<N extends Failure, B>(Future<Either<N, B>> Function() function)async{
    final eitherFunction = await function();
    return await eitherFunction.fold((failure)async{
      final exception = failure.exception;
      if(exception is ServerException){
        if(exception.type == ServerExceptionType.UNHAUTORAIZED){
          await authenticationFixer.reLogin();
          return await function();
        }
      }
      return Left(failure);
    }, (returnedValue)async{
      return Right(returnedValue);
    });
  }

}