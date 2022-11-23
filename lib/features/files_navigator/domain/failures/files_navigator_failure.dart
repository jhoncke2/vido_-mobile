import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/domain/failures.dart';

class FilesNavigatorFailure extends Failure{
  const FilesNavigatorFailure({
    required String message, 
    required AppException exception
  }) : super(message: message, exception: exception);
}