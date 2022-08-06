import 'package:path_provider/path_provider.dart';

abstract class PathProvider{
  Future<String> generatePath();
}

class PathProviderImpl implements PathProvider{
  @override
  Future<String> generatePath()async{
    return ( await getApplicationDocumentsDirectory() ).path;
  }
}