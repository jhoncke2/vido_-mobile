import 'package:flutter/material.dart';

class AppColors{
  static const primary = Color.fromRGBO(255, 195, 0, 1);
  static const secondary = Color.fromRGBO(244, 132, 97, 1);
  static const textPrimary = Colors.black;
  static const textSecondary = Colors.grey;
}

class AppDimens{
  static final AppDimens _instance = AppDimens._();
  
  AppDimens._():
    _screenWidth = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width,
    _screenHeight = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

  factory AppDimens() => _instance;

  final double _screenHeight;
  final double _screenWidth;

  double get scaffoldHorizontalPadding => _screenWidth * 0.02; 
  double get scaffoldVerticalPadding => _screenHeight * 0.01;
}