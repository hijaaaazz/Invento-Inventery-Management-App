import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStyle {
  static final ValueNotifier<bool> isDarkThemeNotifier = ValueNotifier(false);

  static bool get isDarkTheme => isDarkThemeNotifier.value;


  
static ThemeData get theme {
  final TextTheme defaultTextTheme = TextTheme(
    bodyMedium: TextStyle(  
      color: AppStyle.textBlack, 
    ),
  );
  return ThemeData(
    textTheme: defaultTextTheme,  
  );
}



  static const Color lightBackgroundBlack = Color.fromARGB(255, 0, 0, 0);
  static const Color lightBackgroundWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color lightBackgroundPurple = Colors.purple;
  static Color? lightBackgroundGrey = Colors.grey[200];
  static const Color lightTextBlack = Colors.black;
  static const Color lightTextPurple = Colors.purple;
  static const Color lightTextWhite = Colors.white;
  static const Color lightTextGreen = Colors.green;

  static const List<Color> lightGradientGreen = [
    Color(0xFF2DA811),
    Color(0xFF78F439)
  ];

  static const List<Color> lightGradientBlue = [
    Color(0xFF0C48A3),
    Color(0xFF3577D9)
  ];

  static const List<Color> lightGradientOrange = [
    Color(0xFFFF9B15),
    Color(0xFFFFC86F)
  ];

  static const List<Color> lightGradientRed = [
    Color.fromARGB(255, 255, 21, 21),
    Color.fromARGB(255, 255, 111, 111)
  ];

  static List<Color?> lightPurpleShades = [
    Colors.purple.shade900,
    Colors.purple.shade700,
    Colors.purple.shade500,
    Colors.purple.shade300,
    Colors.purple.shade100,
  ];

  // Gradient Definitions
  static const List<Color> lightsalesGradient = [
    Color.fromARGB(255, 66, 0, 116),
    Color.fromARGB(255, 131, 15, 255),
  ];

  static const List<Color> lightpurchasesGradient = [
    Color.fromARGB(255, 22, 119, 0),
    Color.fromARGB(255, 26, 255, 49),
  ];

  static const List<Color> lightstockGradient = [
    Color.fromARGB(255, 88, 0, 75),
    Color.fromARGB(255, 255, 26, 244),
  ];

  static const List<Color> lightrevenueGradient = [
    Color.fromARGB(255, 15, 0, 112),
    Color.fromARGB(255, 45, 26, 255),
  ];

  // Dark Theme Colors
  static const Color darkBackgroundBlack = Color.fromARGB(255, 121, 121, 121);
  static const Color darkBackgroundWhite = Color.fromARGB(255, 20, 20, 20);
  static const Color darkBackgroundPurple = Color.fromARGB(255, 56, 13, 107);
  static Color? darkBackgroundGrey = Colors.grey[850];
  static const Color darkTextBlack = Color.fromARGB(221, 145, 145, 145);
  static const Color darkTextPurple = Color(0xFFCE93D8);
  static const Color darkTextWhite = Color.fromARGB(179, 192, 192, 192);
  static const Color darkTextGreen = Color(0xFF388E3C);

  static const List<Color> darkGradientGreen = [
    Color.fromARGB(255, 13, 53, 16),
    Color.fromARGB(255, 32, 58, 33)
  ];

  static const List<Color> darkGradientBlue = [
    Color.fromARGB(255, 11, 49, 94),
    Color.fromARGB(255, 34, 65, 90)
  ];

  static const List<Color> darkGradientOrange = [
    Color.fromARGB(255, 66, 36, 26),
    Color.fromARGB(255, 80, 54, 46)
  ];

  static const List<Color> darkGradientRed = [
    Color(0xFFD32F2F),
    Color(0xFFEF9A9A)
  ];

  static List<Color?> darkPurpleShades = [
    Colors.deepPurple.shade900,
    Colors.deepPurple.shade700,
    Colors.deepPurple.shade500,
    Colors.deepPurple.shade300,
    Colors.deepPurple.shade100,
  ];

  static const List<Color> darksalesGradient = [
    Color.fromARGB(255, 54, 3, 94),
    Color.fromARGB(255, 81, 13, 155),
  ];

  static const List<Color> darkpurchasesGradient = [
    Color.fromARGB(255, 13, 70, 0),
    Color.fromARGB(255, 10, 88, 18),
  ];

  static const List<Color> darkstockGradient = [
    Color.fromARGB(255, 77, 2, 65),
    Color.fromARGB(255, 75, 8, 71),
  ];

  static const List<Color> darkrevenueGradient = [
    Color.fromARGB(255, 15, 0, 112),
    Color.fromARGB(255, 18, 11, 102),
  ];

  // Dynamic Getters for Theme-based Colors
  static Color get backgroundBlack =>
      isDarkTheme ? darkBackgroundBlack : lightBackgroundBlack;

  static Color get backgroundWhite =>
      isDarkTheme ? darkBackgroundWhite : lightBackgroundWhite;

  static Color get backgroundPurple =>
      isDarkTheme ? const Color.fromARGB(255, 68, 32, 112) : lightBackgroundPurple;

  static Color? get backgroundGrey =>
      isDarkTheme ? darkBackgroundGrey : lightBackgroundGrey;

  static Color get textBlack => isDarkTheme ? darkTextBlack : lightTextBlack;

  static Color get textPurple =>
      isDarkTheme ? const Color.fromARGB(255, 150, 150, 150) : lightTextPurple;

  static Color get textWhite => isDarkTheme ? darkTextWhite : lightTextWhite;

  static Color get textGreen => isDarkTheme ? darkTextGreen : lightTextGreen;

  static List<Color> get gradientGreen =>
      isDarkTheme ? darkGradientGreen : lightGradientGreen;

  static List<Color> get gradientBlue =>
      isDarkTheme ? darkGradientBlue : lightGradientBlue;

  static List<Color> get gradientOrange =>
      isDarkTheme ? darkGradientOrange : lightGradientOrange;

  static List<Color> get gradientRed =>
      isDarkTheme ? darkGradientRed : lightGradientRed;

  static List<Color?> get purpleShades =>
      isDarkTheme ? darkPurpleShades : lightPurpleShades;

  static List<Color> get salesGradient =>
      isDarkTheme ? darksalesGradient : lightsalesGradient;

  static List<Color> get purchaseGradient =>
      isDarkTheme ? darkpurchasesGradient : lightpurchasesGradient;

  static List<Color> get stockGradient =>
      isDarkTheme ? darkstockGradient : lightstockGradient;

  static List<Color> get revenueGradient =>
      isDarkTheme ? darkrevenueGradient : lightrevenueGradient;

  static Color get blueGrey => isDarkTheme
      ? const Color.fromARGB(255, 160, 183, 194)
      : const Color.fromARGB(255, 41, 67, 80);

  static TextStyle get textStyle => GoogleFonts.outfit(
        fontWeight: FontWeight.bold,
        color: isDarkTheme ? darkTextWhite : lightTextWhite,
        fontSize: 20,
      );

   static Future<void> initTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool? storedTheme = prefs.getBool('isDarkTheme');
    isDarkThemeNotifier.value = storedTheme ?? false; // Default to false if null
  }

  // Method to toggle theme mode
  static Future<void> toggleTheme(bool isDark) async {
    isDarkThemeNotifier.value = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDark);
  }
}
