

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/product/product_model.dart';

void showEditStockManagementDialog(
    BuildContext context,
    ValueNotifier<ProductModel> productNotifier,
    ValueNotifier<List<ProductModel>>? gridViewNotifier) {
  final reorderLevelController =
      TextEditingController(text: productNotifier.value.minlimit.toInt().toString());
  final maxLimitController =
      TextEditingController(text: productNotifier.value.maxlimit.toInt().toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
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
                  "Stock Management",
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Reorder Level Section
                Text(
                  "Reorder Level",
                  style: GoogleFonts.outfit(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      controller: reorderLevelController,
                      keyboardType: TextInputType.number,
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
                const SizedBox(height: 20),

                Text(
                  "Maximum Limit",
                  style: GoogleFonts.outfit(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      controller: maxLimitController,
                      keyboardType: TextInputType.number,
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
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel Button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.outfit(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        final newMinLimit = double.tryParse(reorderLevelController.text) ?? 0;
                        final newMaxLimit = double.tryParse(maxLimitController.text) ?? 0;

                        await updateProduct(
                          id: productNotifier.value.productId,
                          name: productNotifier.value.name,
                          description: productNotifier.value.description,
                          minlimit: newMinLimit,
                          maxlimit: newMaxLimit,
                          productImage: productNotifier.value.productImage,
                          category: productNotifier.value.category,
                          price: productNotifier.value.price,
                          rate: productNotifier.value.rate
      
                        );

                        productNotifier.value = productNotifier.value.copyWith(
                          minlimit: newMinLimit,
                          maxlimit: newMaxLimit,
                        );

                        if (gridViewNotifier != null) {
                          final index = gridViewNotifier.value.indexWhere(
                              (p) => p.productId == productNotifier.value.productId);
                          if (index != -1) {
                            gridViewNotifier.value[index] = productNotifier.value;
                            // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                            gridViewNotifier.notifyListeners();
                          }
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Save",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
