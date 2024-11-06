import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:lottie/lottie.dart';


Future<void> showAddCategoryDialog(BuildContext context, String userId) async {
  showDialog(
    context: context,
    builder: (context) => AddCategoryDialog(
      onConfirm: (String id, String name) {
        addCategory(
          userId: userId,
          categoryName: name // Use the passed userId
          
        );
        log("Added category: id = $id, name = $name for userId = $userId");
      },
    ),
  );
}

class AddCategoryDialog extends StatefulWidget {
  final Function(String, String) onConfirm;

  AddCategoryDialog({required this.onConfirm});

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add New Category",
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                height: screenHeight * 0.2,
                child: Lottie.asset('assets/gifs/logout.json'),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a category name')),
                    );
                    return;
                  }
                  widget.onConfirm(
                    DateTime.now().millisecondsSinceEpoch.toString(),
                    nameController.text.trim(),
                  );

                  Navigator.of(context).pop();
                },
                child: Text(
                  "Add",
                  style: GoogleFonts.outfit(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(
                height: 25,
                color: const Color.fromARGB(255, 231, 231, 231),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.outfit(),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
