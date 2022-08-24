import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/domain/failures.dart';

class FilesNavigationFailure extends Failure{
  const FilesNavigationFailure({
    required String message, 
    required AppException exception
  }) : super(message: message, exception: exception);
}