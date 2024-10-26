import 'package:flutter/material.dart';

class MediaQueryInfo {
  static late double screenHeight;
  static late double screenWidth;
  
  static void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }
}
