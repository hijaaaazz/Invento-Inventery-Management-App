import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_product/screen_product.dart';

class ScreenProductList extends StatelessWidget {
  final String title;

  const ScreenProductList({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
        automaticallyImplyLeading: true,
        leading: Padding(
          padding: EdgeInsets.only(left: MediaQueryInfo.screenWidth * 0.04),
          child: IconButton(
            iconSize: 16,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQueryInfo.screenWidth * 0.04),
        child: ValueListenableBuilder(
          valueListenable: ProductListNotifier,
          builder: (context, List<ProductModel> productList, _) {
            final userProducts = productList.where((product) => product.userId == userDataNotifier.value.id).toList();

            if (userProducts.isEmpty) {
              return Center(
                child: Text(
                  "No products available.",
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              );
            }

            return ListView.builder(
              itemCount: userProducts.length,
              itemBuilder: (context, index) {
                final product = userProducts[index];
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
                    margin: EdgeInsets.symmetric(vertical: MediaQueryInfo.screenHeight * 0.01),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 222, 253, 255).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            height: MediaQueryInfo.screenHeight * 0.1,
                            width: MediaQueryInfo.screenHeight * 0.1,
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
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(),
                                ),
                                Text(
                                  "₹${product.price.toInt()}",
                                  style: GoogleFonts.outfit(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            iconSize: 15,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => ScreenProductDetails(product: product),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward_ios),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
