import 'package:equatable/equatable.dart';

class PhotosTranslatorFailure extends Equatable{
  final String message;
  const PhotosTranslatorFailure(this.message);
  @override
  List<Object?> get props => [
    message
  ];
}