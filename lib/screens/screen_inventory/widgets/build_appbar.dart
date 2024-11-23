import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

class InventoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchClicked; // To track the search state
  final Function toggleSearch; // Function to toggle the search state

  const InventoryAppBar({
    super.key,
    required this.isSearchClicked,
    required this.toggleSearch,
   
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppStyle.BackgroundWhite,
      title: Text(
        "Inventory",
        style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
       
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Return standard app bar height
}
