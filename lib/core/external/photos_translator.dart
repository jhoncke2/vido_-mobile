import 'package:flutter/services.dart';

abstract class PhotosTranslator{
  Future<String> translate(String photoUrl);
}

class PhotosTranslatorImpl implements PhotosTranslator{
  static const platform = MethodChannel('image_reader');
  @override
  Future<String> translate(String photoUrl)async{
    //final file = XFile(photoUrl);
    //final bytes = await file.readAsBytes();
    //final content = base64.encode(bytes);
    final text = await platform.invokeMethod('read_image', photoUrl);
    return text;
  }
}