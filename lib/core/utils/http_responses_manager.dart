import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' as foundation;

abstract class HttpResponsesManager{
  Future<Uint8List> getBytesFromResponse(HttpClientResponse response);
}

class HttpResponsesManagerImpl implements HttpResponsesManager{
  @override
  Future<Uint8List> getBytesFromResponse(HttpClientResponse response)async{
    return await foundation.consolidateHttpClientResponseBytes(response); 
  }
}