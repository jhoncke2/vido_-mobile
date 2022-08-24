import 'package:camera/camera.dart';
import 'package:vido/features/authentication/presentation/page/login_page.dart';
import 'package:vido/features/files_navigator/presentation/page/files_navigation_page.dart';
import 'package:vido/features/photos_translator/presentation/pages/photos_translator_page.dart';

import 'features/init/presentation/page/init_page.dart';

late List<CameraDescription> cameras;

class NavigationRoutes{
  static const init = 'init';
  static const authentication = 'authentication';
  static const filesNavigator = 'files_navigator';
  static const photosTranslator = 'photos_translator';
}

final routes = {
  NavigationRoutes.init: (_) => InitPage(),
  NavigationRoutes.authentication: (_) => LoginPage(),
  NavigationRoutes.filesNavigator: (_) => FilesNavigationPage(),
  NavigationRoutes.photosTranslator: (_) => PhotosTranslatorPage()
};