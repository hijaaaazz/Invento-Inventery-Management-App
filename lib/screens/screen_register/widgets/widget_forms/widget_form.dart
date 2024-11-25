import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? errorText;
  final TextInputType? keyboardType; // Added keyboardType parameter
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final TextCapitalization? capital;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.errorText,
    this.keyboardType, // Accept keyboardType in constructor
    this.icon,
    this.onChanged,
    this.capital,
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
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textCapitalization: capital ?? TextCapitalization.none, // Provide default value
                      controller: controller,
                      obscureText: obscureText,
                      keyboardType: keyboardType,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 129, 129, 129),
                      ),
                      onChanged: onChanged,
                      cursorColor: Colors.grey,
                      cursorHeight: 15,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 129, 129, 129),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF3F3F3),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(icon, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
        if (errorText != null) const SizedBox(height: 4),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(255, 255, 0, 0),
              ),
            ),
          ),
      ],
    );
  }
}
