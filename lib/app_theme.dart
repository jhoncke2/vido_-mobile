import 'package:flutter/material.dart';

class AppColors{
  static const primary = Color.fromRGBO(47, 157, 192, 1);
  static const primaryLight = Color.fromRGBO(79, 190, 220, 1);
  static const primaryDark = Color.fromRGBO(25, 86, 114, 1);
  static const secondary = Color.fromRGBO(240, 240, 240, 1);
  static const secondaryLight = Color.fromRGBO(249, 249, 249, 1);
  static const textPrimary = Colors.black;
  static const textPrimaryDark = Colors.white;
  static const textSecondary = Colors.grey;
  static const shadow = Color.fromRGBO(200, 200, 200, 1);
  static const backgroundPrimary = Colors.white;
  static const backgroundSecondary = Color.fromRGBO(240, 240, 240, 1);
  static const iconPrimary = Color.fromRGBO(143, 171, 221, 1);
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
  double get normalContainerHorizontalMargin => _screenWidth * 0.022;
  double get normalContainerVerticalMargin => _screenHeight * 0.011;
  double get titleTextSize => 26;
  double get subtitleTextSize => 20;
  double get normalTextSize => 17;
  double get littleTextSize => 15;
  double get normalContainerHorizontalPadding => _screenWidth * 0.015;
  double get bigContainerHorizontalPadding => _screenWidth * 0.045;
  double get normalContainerVerticalPadding => _screenHeight * 0.02;
  double get littleContainerHorizontalPadding => _screenWidth * 0.0075;
  double get littleContainerVerticalPadding => _screenHeight * 0.01;
  double get normalVerticalSpace => _screenHeight * 0.04;
  double get littleVerticalSpace => _screenHeight * 0.02;
  double get littleIconSize => 22;
  double get normalIconSize => 52.5;
  double get bigIconSize => 70;
  double get bigButtonHorizontalPadding => 40;
  double get appBarHeight => _screenHeight * 0.09;
  double get bigBorderRadius => _screenWidth * 0.1;
  double getHeightPercentage(double perc) => _screenHeight * perc;
  double getWidthPercentage(double perc) => _screenWidth * perc;
}