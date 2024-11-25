import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

void showCustomSnackbar(String message, BuildContext ctx,Color color,{LottieBuilder? lottie}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(100)),   
    duration: const Duration(seconds: 3),
    elevation: 5,
    content: Row(
      children: [
        SizedBox(
          width: 25,
          height: 25,
          child: ClipRRect(
            
            child: lottie ?? Lottie.asset(
              'assets/gifs/add_sales.json', // Lottie file path
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(width: 10), // Spacing between animation and text
        Expanded(
          child: Center(
            child: Text(
              message,
              style: GoogleFonts.outfit(fontSize: 16, color:color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: const Color.fromARGB(255, 255, 255, 255), // No background for default SnackBar
  );

  // Displaying the custom SnackBar
  ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
}
