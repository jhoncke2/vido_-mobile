import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:vido/features/photos_translator/domain/failures/photos_translator_failure.dart';

abstract class CreatePdfFile{
  Future<Either<PhotosTranslatorFailure, void>> call(String name, File pdf);
}