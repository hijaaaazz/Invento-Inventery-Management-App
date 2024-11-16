import 'package:flutter/material.dart';

class AppStyle {
  AppStyle._internal();

  static final AppStyle _instance = AppStyle._internal();

  factory AppStyle() {
    return _instance;
  }

  // ignore: non_constant_identifier_names
  final Color BackgroundBlack = const Color.fromARGB(255, 0, 0, 0);
  // ignore: non_constant_identifier_names
  final Color BackgroundWhite = const Color.fromARGB(255, 255, 255, 255);
  // ignore: non_constant_identifier_names
  final Color BackgroundPurple =  Colors.purple;
  
}
