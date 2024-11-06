import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';

class EditProfileFields extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Icon icon;

  const EditProfileFields({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userDataNotifier,
      builder: (ctx, newValue, _){
        return Row(
        children: [
          Container(
            width: MediaQueryInfo.screenHeight * 0.07,
            height: MediaQueryInfo.screenHeight * 0.07,
            child: icon,
          ),
          Flexible(
            child: TextFormField(
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color.fromARGB(221, 105, 105, 105),
              ),
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 219, 17, 255),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      );
      },
    );
  }
}
