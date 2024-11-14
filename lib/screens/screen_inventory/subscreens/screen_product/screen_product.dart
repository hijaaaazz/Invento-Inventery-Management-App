import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_product/widgets/app_bar.dart';

class ScreenProductDetails extends StatefulWidget {
  final ProductModel product;

  const ScreenProductDetails({super.key, required this.product});

  @override
  State<ScreenProductDetails> createState() => _ScreenProductDetailsState();
}

class _ScreenProductDetailsState extends State<ScreenProductDetails> {
  late ValueNotifier<ProductModel> productDetailsNotifier;

  @override
  void initState() {
    super.initState();
    productDetailsNotifier = ValueNotifier(widget.product);
  }

  @override
  void dispose() {
    productDetailsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStyle appStyle = AppStyle();

    return Scaffold(
      backgroundColor: appStyle.secondaryColor,
      appBar: build_product_page_appbar(
          () => showProductDeleteDialog(context, productDetailsNotifier.value),
          context,
          appStyle),
      body: ValueListenableBuilder(
          valueListenable: productDetailsNotifier,
          builder: (context, updatedProduct, _) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQueryInfo.screenHeight * 0.4,
                    child: Stack(
                      children: [
                        Positioned(
                          right: MediaQueryInfo.screenWidth * 0.2,
                          bottom: MediaQueryInfo.screenHeight * 0.05,
                          child: Container(
                            width: MediaQueryInfo.screenWidth * 0.5,
                            height: MediaQueryInfo.screenHeight * 0.03,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(0, 33, 149, 243),
                              borderRadius: BorderRadius.circular(1000),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.7),
                                  spreadRadius: 10,
                                  blurRadius: 30,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: ClipRRect(
                            child: Image(
                              image: FileImage(File(updatedProduct.productImage)),
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQueryInfo.screenHeight * 0.03),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                updatedProduct.name,
                                maxLines: 10,
                                overflow: TextOverflow.clip,
                                style: GoogleFonts.outfit(
                                    fontSize: 24, fontWeight: FontWeight.w500),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showEditProductDetailsDialog(
                                      context, productDetailsNotifier);
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.black45,
                                  size: 18,
                                ))
                          ],
                        ),
                        Text(updatedProduct.description,
                            style: GoogleFonts.lato(
                                fontSize: 16, fontWeight: FontWeight.w300)),
                        SizedBox(height: MediaQueryInfo.screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQueryInfo.screenHeight * 0.045,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 226, 60, 255),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQueryInfo.screenWidth * 0.04),
                                child: Center(
                                  child: Text(
                                    "Current Stock : ${updatedProduct.stock}",
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: appStyle.secondaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "₹ ${updatedProduct.price.toString()}",
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: MediaQueryInfo.screenHeight * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text("Unit :"),
                                Text(
                                  updatedProduct.unit.toUpperCase(),
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Rate : ₹"),
                                Text(
                                  updatedProduct.rate.toString(),
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "STOCK MANAGMENT",
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showEditStockManagementDialog(
                                    context, productDetailsNotifier);
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: Colors.black45,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                        const Divider(height: 0),
                        SizedBox(height: MediaQueryInfo.screenHeight * 0.02),
                        Row(
                          children: [
                            const Text("Reorder Level"),
                            const SizedBox(width: 30),
                            Text(updatedProduct.minlimit.toInt().toString())
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Max Limit"),
                            const SizedBox(width: 59),
                            Text(updatedProduct.maxlimit.toInt().toString())
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

void showEditProductDetailsDialog(
    BuildContext context, ValueNotifier<ProductModel> productNotifier) {
  final nameController = TextEditingController(text: productNotifier.value.name);
  final descriptionController =
      TextEditingController(text: productNotifier.value.description);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Edit Product Details",
          style: GoogleFonts.lato(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Product Name"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Product Description"),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel", style: GoogleFonts.lato()),
          ),
          ElevatedButton(
            onPressed: () async {
              // Update product in database
              await updateProduct(
                id: productNotifier.value.productId,
                name: nameController.text,
                description: descriptionController.text,
                minlimit: productNotifier.value.minlimit,
                maxlimit: productNotifier.value.maxlimit,
              );

              productNotifier.value = productNotifier.value.copyWith(
                name: nameController.text,
                description: descriptionController.text,
              );
              Navigator.of(context).pop(); // Close dialog
            },
            child: Text("Save", style: GoogleFonts.lato()),
          ),
        ],
      );
    },
  );
}

void showEditStockManagementDialog(
    BuildContext context, ValueNotifier<ProductModel> productNotifier) {
  final reorderLevelController =
      TextEditingController(text: productNotifier.value.minlimit.toInt().toString());
  final maxLimitController =
      TextEditingController(text: productNotifier.value.maxlimit.toInt().toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Edit Stock Management",
          style: GoogleFonts.lato(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: reorderLevelController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Reorder Level"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: maxLimitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Max Limit"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cancel",
              style: GoogleFonts.lato(),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final newMinLimit = double.tryParse(reorderLevelController.text) ?? 0;
              final newMaxLimit = double.tryParse(maxLimitController.text) ?? 0;
              
              await updateProduct(
                id: productNotifier.value.productId,
                name: productNotifier.value.name,
                description: productNotifier.value.description,
                minlimit: newMinLimit,
                maxlimit: newMaxLimit,
              );

              // Update the UI
              productNotifier.value = productNotifier.value.copyWith(
                minlimit: newMinLimit,
                maxlimit: newMaxLimit,
              );

              Navigator.of(context).pop();
            },
            child: Text("Save", style: GoogleFonts.lato()),
          ),
        ],
      );
    },
  );
}

Future<void> showProductDeleteDialog(
    BuildContext context, ProductModel product) async {
  if (product.stock == 0) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await deleteProduct(product.productId);
              ProductListNotifier.value
                  .removeWhere((p) => p.productId == product.productId);
              ProductListNotifier.notifyListeners();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
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