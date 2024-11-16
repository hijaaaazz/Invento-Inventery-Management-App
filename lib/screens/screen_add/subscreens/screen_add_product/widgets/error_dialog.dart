import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

void showErrorDialog(ctx, String message, String message2) {
  showDialog(
    context: ctx,
    builder: (BuildContext context) {
      return Dialog(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    color: Colors.red
                  ),),
                  SizedBox(
                    height: 100,
                    child: ClipRRect
                    (
                      child: Lottie.asset("assets/gifs/error.json")),
                  ),
                    Text(message2,textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 13
                    ),)
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}