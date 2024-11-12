import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

class InventoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchClicked; // To track the search state
  final Function toggleSearch; // Function to toggle the search state
  final AppStyle appStyle;

  const InventoryAppBar({
    super.key,
    required this.isSearchClicked,
    required this.toggleSearch,
    required this.appStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "Inventory",
        style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: isSearchClicked
                ? Icon(Icons.close, color: appStyle.primaryColor)
                : Icon(Icons.search, color: appStyle.primaryColor),
            onPressed: () {
              toggleSearch(); 
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Return standard app bar height
}
