// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vido/features/init/presentation/page/init_page.dart';
import './injection_container.dart' as ic;
import './globals.dart' as globals;

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'vido trial',
      home: InitPage(),
      routes: globals.routes,
    );
  }
}