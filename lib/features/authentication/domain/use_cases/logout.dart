import 'package:dartz/dartz.dart';
import 'package:vido/features/authentication/domain/failures/failures.dart';
import 'package:vido/features/authentication/presentation/use_cases/logout.dart';
import '../../../../core/domain/use_case_error_handler.dart';
import '../repository/authentication_repository.dart';

class LogoutImpl implements Logout{
  final UseCaseErrorHandler errorHandler;
  final AuthenticationRepository repository;
  LogoutImpl({
    required this.errorHandler, 
    required this.repository
  });

  @override
  Future<Either<AuthenticationFailure, void>> call()async{
    return await errorHandler.executeFunction<AuthenticationFailure, void>(
      () => repository.logout()
    );
  }
}
