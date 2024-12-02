
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

void showRangeOptions(dynamic context,showCustomRangePicker,updateRange) async {
  final selectedOption = await showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
        decoration: BoxDecoration(
          color: AppStyle.backgroundWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))
        ),
        child: Column(
          
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title:  Text("Update Range",
              style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),),
              onTap: () {
                Navigator.pop(context, "update");
              },
            ),
            const Divider(),
            ListTile(
              title:  Text("Clear Range",
              style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),),
              onTap: () {
                Navigator.pop(context, "clear");
              },
            ),
          ],
        ),
      );
    },
  );

  if (selectedOption == "update") {
    showCustomRangePicker();
  } else if (selectedOption == "clear") {
    
    updateRange();
  }
}
