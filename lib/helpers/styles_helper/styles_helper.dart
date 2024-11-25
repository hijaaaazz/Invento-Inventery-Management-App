import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {

  AppStyle();

  static const Color backgroundBlack = Color.fromARGB(255, 0, 0, 0);
  static const Color backgroundWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color backgroundPurple =  Colors.purple;
  static const Color textBlack= Colors.black;
  static const Color textPurple= Colors.purple;
  static const Color textWhite= Colors.white;
  static const List<Color> gradientGreen =[ Color(0xFF2DA811), Color(0xFF78F439)];
  static const List<Color> gradientblue =[Color(0xFF0C48A3), Color(0xFF3577D9)];
  static const List<Color> gradientorange =[Color(0xFFFF9B15), Color(0xFFFFC86F)];
  static const List<Color> gradientred =[Color.fromARGB(255, 255, 21, 21), Color.fromARGB(255, 255, 111, 111)];



  
  static TextStyle textWhiteOutfit = GoogleFonts.outfit(
    fontWeight: FontWeight.bold,
    color: AppStyle.textWhite,
    fontSize: 20,
  );

  static BoxShadow lightShadow = BoxShadow(
  color: Colors.black.withOpacity(0.2),
  blurRadius: 1,
  spreadRadius: 1,
  offset: const Offset(1,2),
);

  
}
