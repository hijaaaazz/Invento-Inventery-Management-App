import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/database/inventory/purchase/purchase_functions.dart';
import 'package:invento2/database/inventory/purchase/purchase_model.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_register/widgets/widget_forms/widget_form.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class ScreenAddPurchaseItem extends StatefulWidget {
  const ScreenAddPurchaseItem({super.key,});

  @override
  State<ScreenAddPurchaseItem> createState() => _ScreenAddPurchaseItemState();
}

class _ScreenAddPurchaseItemState extends State<ScreenAddPurchaseItem> {
  TextEditingController searchController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  ProductModel? selectedProduct;
  List<ProductModel> filteredProducts = [];

  // ValueNotifier for quantity
  ValueNotifier<double> quantityNotifier = ValueNotifier<double>(1);

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    filteredProducts = ProductListNotifier.value
        .where((a) => a.userId == userDataNotifier.value.id)
        .toList();

    quantityController.text = quantityNotifier.value.toString();
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = ProductListNotifier.value
          .where((product) =>
              product.userId == userDataNotifier.value.id &&
              product.name.toLowerCase().contains(query))
          .toList()
        ..sort((a, b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    quantityController.dispose();
    quantityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.BackgroundWhite,
      appBar: appBarHelper("Add Purchase Item"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search Field
            CustomTextField(
              controller: searchController,
              hintText: "Search Product....",
              icon: Icons.search,
            ),
            const SizedBox(height: 10),

            // Product Suggestions List
            ValueListenableBuilder(
              valueListenable: ProductListNotifier,
              builder: (context, List<ProductModel> productList, _) {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: FileImage(File(product.productImage)),
                        ),
                        title: Text(product.name),
                        subtitle: Text("\$${product.rate}"),
                        onTap: () {
                          setState(() {
                            searchController.text = product.name;
                            selectedProduct = product;
                          });
                        },
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Quantity Section with ValueNotifier
            ValueListenableBuilder<double>(
  valueListenable: quantityNotifier,
  builder: (context, quantity, _) {
    return Container(
      padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Stock Availability
          SizedBox(
            width: MediaQueryInfo.screenWidth*0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Stock:',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${selectedProduct?.stock ?? 0} units',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
            Row(
              children: [
                IconButton(
                  onPressed:
                    () {
                          quantityNotifier.value--;
                          quantityController.text = quantityNotifier.value.toString();
                        }
  ,                icon: const Icon(Icons.remove, color: Colors.red),
                  splashRadius: 24,
                  color: Colors.grey[200],
                ),
                Container(
                  width: 80,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[100],
                  ),
                  child: Center(
                    child: TextField(
                      controller: quantityController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 16),
                      onChanged: (value) {
                        double newQuantity = double.tryParse(value) ?? 1;
                        if (newQuantity < 1) newQuantity = 1;
                        quantityNotifier.value = newQuantity;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                  
                      quantityNotifier.value++;
                      quantityController.text = quantityNotifier.value.toString();

                  },
                  icon: const Icon(Icons.add, color: Colors.green),
                  splashRadius: 24,
                ),
              ],
            ),
          ],
        ),
      );
    },
  ),
           GestureDetector(
            onTap: (){
               if (selectedProduct != null) {
                  puchasesAddedProductsList.value.add(
                    PurchaseProduct(
                      product: selectedProduct!,
                      quantity: quantityNotifier.value,
                    ),
                  );
                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                  puchasesAddedProductsList.notifyListeners();

                  selectedProduct = null;
                  searchController.clear();
                  Navigator.pop(context);
                }

            },
             child: Padding(
               padding: const EdgeInsets.symmetric(vertical: 10),
               child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                 color: AppStyle.BackgroundPurple,
             
                ),
                height: MediaQueryInfo.screenHeight*0.08,
                child: Center(
                  child: Text("Add Item",style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppStyle.TextWhite
                  ),),
                ),
               ),
             ),
           )
          ],
        ),
      ),
    );
  }
}
