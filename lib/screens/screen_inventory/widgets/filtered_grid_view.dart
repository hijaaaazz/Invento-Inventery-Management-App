import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_product/screen_product.dart';

class ProductGridView extends StatelessWidget {
final ValueNotifier<List<ProductModel>> filteredProductsNotifier;
  final VoidCallback? getMaxPrice;
  final VoidCallback? clearfilter;

  const ProductGridView({super.key, required this.filteredProductsNotifier,this.getMaxPrice,this.clearfilter});

  @override
  Widget build(BuildContext context) {
   

    return ValueListenableBuilder<List<ProductModel>>(
      valueListenable: filteredProductsNotifier,
      builder: (context, filteredProducts, _) {

        if (filteredProducts.isEmpty) {
          return Center(
            child: Text(
              "No products available",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return ListView(
          children:[ Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8, right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(product.productImage),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '₹${product.price}',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) {
                                    return ScreenProductDetails(
                                      product: product,
                                      Gridviewnotifier: filteredProductsNotifier,
                                      getMaxPrice: getMaxPrice,
                                      clearfilter: clearfilter, 
                                    );
                                  },
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          ]
        );
      },
    );
  }
}
