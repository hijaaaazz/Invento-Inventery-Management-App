import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_register/widgets/widget_forms/widget_form.dart';

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
  // ignore: library_private_types_in_public_api
  _AddCustomerDialogState createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
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
                "Add Customer",
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  color: AppStyle.textBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
                child: CustomTextField(
                  
                  
                  controller: widget.nameController,
                 
                
                  keyboardType: TextInputType.text,
                  capital: TextCapitalization.words,
                  hintText: "Customer's Name",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: CustomTextField(
                  controller: widget.contactController,
                hintText: "Customer's Contact",
                keyboardType: TextInputType.phone,)
                
              ),
              const SizedBox(
                height: 20,
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
              Divider(
                height: 25,
                color: AppStyle.backgroundGrey,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.outfit(
                    color: AppStyle.textBlack
                  ),
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
