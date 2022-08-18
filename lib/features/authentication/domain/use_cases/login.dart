import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/use_case_error_handler.dart';
import 'package:vido/features/authentication/domain/failures/failures.dart';
import 'package:vido/features/authentication/domain/entities/user.dart';
import 'package:vido/features/authentication/domain/repository/authentication_repository.dart';
import 'package:vido/features/authentication/presentation/use_cases/login.dart';

class LoginImpl implements Login{
  final UseCaseErrorHandler errorHandler;
  final AuthenticationRepository repository;
  const LoginImpl({
    required this.errorHandler, 
    required this.repository
  });
  @override
  Future<Either<AuthenticationFailure, void>> call(User user)async{
    return await errorHandler.executeFunction<AuthenticationFailure, void>(
      () => repository.login(user)
    );
  }
}