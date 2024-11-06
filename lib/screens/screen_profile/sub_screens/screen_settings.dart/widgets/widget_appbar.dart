import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar settingsAppBar(BuildContext context) { // Accept context as a parameter
  return AppBar(
    titleSpacing: 0,
    backgroundColor: Colors.white,
    leading: Padding(
      padding: const EdgeInsets.only(left: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop(); // Use the passed context here
        },
        child: const Icon(Icons.arrow_back_ios, size: 14),
      ),
    ),
    title: Text(
      "Settings",
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
