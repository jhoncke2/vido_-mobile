// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vido/features/photos_translator/presentation/pages/photos_translator_page.dart';
import './injection_container.dart' as ic;

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await ic.init();
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  MyApp(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'vido trial',
      home: PhotosTranslatorPage(),
    );
  }
}