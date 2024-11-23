import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

AppBar appBarHelper(String title, {List<Widget>? actions}) {
  return AppBar(
    leadingWidth: 30,
    elevation: 0,
    backgroundColor: AppStyle.BackgroundWhite,
    title: Text(
      title,
      style: GoogleFonts.inter(
        color: AppStyle.TextPurple,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: IconThemeData(
      color: AppStyle.TextPurple, // Set the leading icon color
    ),
    actions: actions,
  );
}
