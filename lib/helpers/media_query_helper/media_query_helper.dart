import 'package:flutter/material.dart';

class MediaQueryInfo {
  static late double screenHeight;
  static late double screenWidth;

  // Function to initialize screen height and width
  static void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }
}
