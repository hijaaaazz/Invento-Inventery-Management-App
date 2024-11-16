

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:lottie/lottie.dart';

Future<void> showProductDeleteDialog(
    BuildContext context, ProductModel product, ValueNotifier<List<ProductModel>>? gridviewNotifier) async {
  if (product.stock == 0) {
    showDialog(
      context: context,
      builder: (context) { 
        return Dialog(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                children: [
              
                Text(
                    "Are You Sure",
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MediaQueryInfo.screenHeight*0.05,),
                  SizedBox(
                    height: MediaQueryInfo.screenHeight*0.2,
                    child: ClipRRect(
                      child: Lottie.asset("assets/gifs/delete.json")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Are you sure you want to delete this product? This action cannot be undone.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500
                    ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(onPressed: ()=>  Navigator.of(context).pop(),
                       child: 
                          Text(
                        "Cancel",
                        style: GoogleFonts.outfit(
                          color: Colors.black
                        ),
                      ),),
                      TextButton(
                      onPressed: () async {
                          await deleteProduct(product.productId);
                          if (gridviewNotifier != null) {
                            gridviewNotifier.value = gridviewNotifier.value
                                .where((p) => p.productId != product.productId)
                                .toList();

                            // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                            gridviewNotifier.notifyListeners();
                          }

                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        },
                      child: Text(
                      "Delete",
                      style: GoogleFonts.outfit(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    )
                      ),
                    ),
                    ],
                  ),
                ],
              ),
            ),
            ),
          ),
      );
      }
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cannot Delete"),
        content: const Text("Product cannot be deleted as it still has stock."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
