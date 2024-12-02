import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

AppBar appBarHelper(String title, {List<Widget>? actions}) {
  return AppBar(
    leadingWidth: 30,
    elevation: 0,
    backgroundColor: AppStyle.backgroundWhite,
    title: Text(
      title,
      style: GoogleFonts.inter(
        color: AppStyle.textPurple,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: IconThemeData(
      color: AppStyle.textPurple, 
    ),
    actions: actions,
  );
}
