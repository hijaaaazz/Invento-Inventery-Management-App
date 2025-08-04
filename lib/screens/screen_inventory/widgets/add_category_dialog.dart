import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

Future<void> showAddCategoryDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) => AddCategoryDialog(
      onConfirm: (String name, String categoryId) {
        addCategory(
          categoryId: categoryId,
          categoryName: name,
        );
      },
    ),
  );
}

class AddCategoryDialog extends StatefulWidget {
  final Function(String, String) onConfirm;

  const AddCategoryDialog({super.key, required this.onConfirm});

  @override
  // ignore: library_private_types_in_public_api
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: AppStyle.backgroundWhite,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextFormField(
                    controller: nameController,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 129, 129, 129),
                    ),
                    cursorColor: Colors.grey,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
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
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a category name')),
                    );
                    return;
                  }

                  String categoryId = DateTime.now().millisecondsSinceEpoch.toString();
                  String name = nameController.text.trim();

                  widget.onConfirm(name, categoryId);

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
              const Divider(
                height: 25,
                color: Color.fromARGB(255, 231, 231, 231),
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
