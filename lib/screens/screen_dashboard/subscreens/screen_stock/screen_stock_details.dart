import 'dart:io';
import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_product/screen_product.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class ScreenStockDetails extends StatelessWidget {
  final List<ProductModel> products;
  final String title; 
  final String currencySymbol;
  const ScreenStockDetails({super.key, required this.products,required this.title,required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundWhite,
      appBar: appBarHelper(title),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
        child: 
        products.isEmpty
            ? Center(
                child: Text(
                  "No $title available.",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
          
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ScreenProductDetails(product: product),
                  ),
                );
              },
              child: Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                shadowColor: Colors.black,
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.height * 0.1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: product.productImage.isNotEmpty
                                    ? Image.file(
                                        File(product.productImage),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset('assets/images/box.jpg', fit: BoxFit.cover),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Product Details Text
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(),
                            ),
                            Text(
                              "$currencySymbol${product.price.toInt()}",
                              style: const TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Arrow Icon Button
                      IconButton(
                        iconSize: 15,
                        onPressed: () {
                          // Navigate to Product Details Screen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ScreenProductDetails(product: product),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

