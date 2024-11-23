import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showAddCustomerDialog(
  BuildContext context,
  Function(String name, int contact) onAddCustomer, {
  required TextEditingController nameController,
  required TextEditingController contactController,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddCustomerDialog(
        onConfirm: (String name, int contact) {
          onAddCustomer(name, contact);
        },
        nameController: nameController,
        contactController: contactController,
      );
    },
  );
}

class AddCustomerDialog extends StatefulWidget {
  final Function(String, int) onConfirm;
  final TextEditingController nameController;
  final TextEditingController contactController;

  const AddCustomerDialog({
    super.key,
    required this.onConfirm,
    required this.nameController,
    required this.contactController,
  });

  @override
  _AddCustomerDialogState createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add Customer",
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      
                      controller: widget.nameController,
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
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      controller: widget.contactController,
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
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (widget.nameController.text.trim().isEmpty ||
                      widget.contactController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  String name = widget.nameController.text.trim();
                  int contact =
                      int.tryParse(widget.contactController.text.trim()) ??
                          00000000;

                  widget.onConfirm(name, contact);
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
