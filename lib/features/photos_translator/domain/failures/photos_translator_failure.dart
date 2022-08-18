import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/domain/failures.dart';

class PhotosTranslatorFailure extends Failure{
  const PhotosTranslatorFailure({
    required String message,
    required AppException exception
  }):super(
    message: message,
    exception: exception
  );
}