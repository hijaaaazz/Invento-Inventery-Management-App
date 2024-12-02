import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

 Widget buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    validator 
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:  TextStyle(fontWeight: FontWeight.w600,color: AppStyle.blueGrey),
        ),
        TextFormField(
          cursorColor: Colors.grey,
          cursorRadius: const Radius.circular(10),
          controller: controller,
          keyboardType: keyboardType, 
          style: GoogleFonts.inter(
            fontSize: 13,
            color:  AppStyle.blueGrey,
          ),
          decoration: const InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 96, 96, 96)
              )
            ),
            
            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          ),
        ),
        
      ],
    );
  }
