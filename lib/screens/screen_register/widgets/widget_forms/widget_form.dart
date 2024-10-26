import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? errorText; // New field for error text

  CustomTextField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.errorText, // Added parameter for error text
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.07,
          decoration: BoxDecoration(
            color: Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 129, 129, 129),
                ),
                cursorColor: Colors.grey,
                cursorHeight: 15,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 129, 129, 129),
                  ),
                  filled: true,
                  fillColor: Color(0xFFF3F3F3),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null) SizedBox(height: 4), // Space if there's an error
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4), // Optional left padding
            child: Text(
              errorText!,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(255, 255, 0, 0), // Red color for errors
              ),
            ),
          ),
      ],
    );
  }
}
