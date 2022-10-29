import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:vido/core/domain/exceptions.dart';

abstract class StoragePdfPicker{
  Future<File> pick();
}

class StoragePdfPickerImpl implements StoragePdfPicker{
  @override
  Future<File> pick()async{
    final pickingResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf']
    );
    if(pickingResult != null){
      return File(pickingResult.files.single.path!);
    }else{
      throw const StorageException(
        message: 'Ningún archivo fue seleccionado',
        type: StorageExceptionType.EMPTYDATA
      );
    }
  }
}