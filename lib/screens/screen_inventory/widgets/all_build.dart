import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_add/subscreens/screen_add_product/screen_add_product.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_category_list/screen_category.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_product/screen_product.dart';
import 'package:lottie/lottie.dart';

Widget buildAllSection(UserModel userData, BuildContext ctx) {
  return ValueListenableBuilder(
    valueListenable: ProductListNotifier,
    builder: (context, productList, _) {
      final userSpecificProducts = productList
          .where((product) => product.userId == userData.id)
          .toList();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 221, 251, 255),
        ),
        child: userSpecificProducts.isEmpty
            ? Column(
                children: [
                  Text(
                    "No Stocks in Inventory, Add Now!",
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(ctx).push(MaterialPageRoute(
                        builder: (_) => const ScreenAddProduct(),
                      ));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Lottie.asset(
                        "assets/gifs/add_purchases.json",
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(ctx).push(MaterialPageRoute(
                        builder: (context) => ScreenProductList(
                          title: "All Products",
                          
                        ),
                      ));
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "All Products",
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  CarouselSlider(
                    items: userSpecificProducts.map((product) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(ctx).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ScreenProductDetails(product: product),
                            ),
                          );
                        },
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
                                    : Image.asset(
                                        'assets/images/box.jpg',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.black.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQueryInfo.screenWidth * 0.05,
                                  vertical:
                                      MediaQueryInfo.screenHeight * 0.01,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(0, 1),
                                            blurRadius: 6.0,
                                            color: Colors.black.withOpacity(0.6),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "Stock: ${product.stock} ${product.unit}",
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(0, 1),
                                            blurRadius: 6.0,
                                            color: Colors.black.withOpacity(0.6),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 120,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.7,
                    ),
                  ),
                ],
              ),
      );
    },
  );
}
