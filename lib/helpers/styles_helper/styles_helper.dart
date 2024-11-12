import 'package:flutter/material.dart';

class AppStyle {
  // Singleton implementation
  AppStyle._internal();

  static final AppStyle _instance = AppStyle._internal();

  factory AppStyle() {
    return _instance;
  }

  // Colors
  final Color primaryColor = const Color.fromARGB(255, 0, 0, 0);
  final Color secondaryColor = const Color.fromARGB(255, 255, 255, 255);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color textPrimaryColor = const Color(0xFF212121);
  final Color textSecondaryColor = const Color(0xFF757575);
  final Color buttonColor = const Color(0xFF6200EE);

  final TextStyle headingStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF212121),
  );
  
  final TextStyle subheadingStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFF757575),
  );

  final TextStyle bodyTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Color(0xFF212121),
  );

  final TextStyle buttonTextStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  final String primaryFont = 'Roboto'; 
  final String secondaryFont = 'Lobster'; 
  

  void someFunction() {
    print('Function called');
  }
}
