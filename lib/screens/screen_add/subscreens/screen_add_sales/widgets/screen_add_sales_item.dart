import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/database/inventory/sales/sales_functions.dart';
import 'package:invento2/database/inventory/sales/sales_model.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_register/widgets/widget_forms/widget_form.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class ScreenAddSalesItem extends StatefulWidget {  
  const ScreenAddSalesItem({super.key});  

  @override
  State<ScreenAddSalesItem> createState() => _ScreenAddSalesItemState(); 
}
class _ScreenAddSalesItemState extends State<ScreenAddSalesItem> {
  TextEditingController searchController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  ProductModel? selectedProduct;
  List<ProductModel> filteredProducts = [];
  Map<String, double> temporaryStock = {}; 
  ValueNotifier<double> quantityNotifier = ValueNotifier<double>(1);

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    filteredProducts = ProductListNotifier.value.where((a) => a.userId == userDataNotifier.value.id).toList();

    quantityController.text = quantityNotifier.value.toString();
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = ProductListNotifier.value
          .where((product) => product.userId == userDataNotifier.value.id && product.name.toLowerCase().contains(query))
          .toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    });
  }

  double getAvailableStock(ProductModel product) {
    return temporaryStock[product.productId] ?? product.stock;
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
      appBar: appBarHelper("Add Sale Item"),
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
                            quantityNotifier.value = 1; // Reset quantity
                            quantityController.text = "1";
                          });
                        },
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

        
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
          Container(
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

          // Quantity Control
          Row(
            children: [
              IconButton(
                onPressed: quantity > 1
                    ? () {
                        quantityNotifier.value--;
                        quantityController.text = quantityNotifier.value.toString();
                      }
                    : null,
                icon: const Icon(Icons.remove, color: Colors.red),
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
                  final stock = selectedProduct?.stock ?? 0;
                  if (quantity < stock) {
                    quantityNotifier.value++;
                    quantityController.text = quantityNotifier.value.toString();
                  }
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

              const SizedBox(height: 20),
          
            ElevatedButton(
              onPressed: () {
                if (selectedProduct != null) {
                  final availableStock = getAvailableStock(selectedProduct!);
                  if (quantityNotifier.value > availableStock) {
                    // Show Error Message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Insufficient stock!')),
                    );
                    return;
                  }

                  temporaryStock[selectedProduct!.productId] =
                      availableStock - quantityNotifier.value;

                  salesAddedProductsList.value.add(
                    SaleProduct(
                      product: selectedProduct!,
                      quantity: quantityNotifier.value,
                    ),
                  );
                  salesAddedProductsList.notifyListeners();

                  selectedProduct = null;
                  searchController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Sale Item'),
            ),
          ]
        ),
      ),
    );
  }
}
