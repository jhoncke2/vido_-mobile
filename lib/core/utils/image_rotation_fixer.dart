import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart' as img;

abstract class ImageRotationFixer{
  Future<File> fix(String filePath);
}

class ImageRotationFixerImpl implements ImageRotationFixer{
  static const portKey = 'port';
  static const pathKey = 'path';
  
  @override
  Future<File> fix(String filePath)async{
    final receiver = ReceivePort();
    final Map<String, dynamic> initialSpawnValues = {
      portKey: receiver.sendPort,
      pathKey: filePath
    };
    await Isolate.spawn(_doFixHardProcess, initialSpawnValues);
    return await receiver.first as File;
  }

  static Future<void> _doFixHardProcess(Map<String, dynamic> values)async{
    final SendPort port = values[portKey];
    final String filePath = values[pathKey];
    final img.Image capturedImage = img.decodeImage(await File(filePath).readAsBytes())!;
    final img.Image orientedImage = img.bakeOrientation(capturedImage);
    final newFile = await File(filePath).writeAsBytes(img.encodeJpg(orientedImage));
    Isolate.exit(port, newFile);
  }
}