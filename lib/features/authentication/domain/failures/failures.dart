import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/domain/failures.dart';

class AuthenticationFailure extends Failure{
  const AuthenticationFailure({
    required String message, 
    required AppException exception
  }) : super(message: message, exception: exception);
}