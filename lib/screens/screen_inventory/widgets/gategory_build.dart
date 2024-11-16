import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/category/category_model.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_category_list/screen_category.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_product/screen_product.dart';
import 'package:invento2/screens/screen_inventory/widgets/delete_category.dart';

Widget buildCategorySection(
    CategoryModel category, int index, UserModel userData, BuildContext ctx) {
  if (category.name == null || category.name!.isEmpty) return Container();

  ValueNotifier<List<ProductModel>> productsInCategoryNotifier = ValueNotifier(
    ProductListNotifier.value
        .where((product) =>
            product.category == category.name && product.userId == userData.id)
        .toList(),
  );

  void updateCategoryNotifier() {
    productsInCategoryNotifier.value = ProductListNotifier.value
        .where((product) =>
            product.category == category.name && product.userId == userData.id)
        .toList();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    productsInCategoryNotifier.notifyListeners();
  }

  ProductListNotifier.addListener(updateCategoryNotifier);

  return ValueListenableBuilder<List<ProductModel>>(
    valueListenable: productsInCategoryNotifier,
    builder: (context, productsInCategory, _) {
      AppStyle appStyle = AppStyle();
      if (productsInCategory.isEmpty) {
        return GestureDetector(
          onLongPress: () {
            longPressEmptyCategory(ctx, category);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name ?? '',
                  style: GoogleFonts.outfit(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                const Text(
                  'No products available in this category',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category.name ?? '',
                  style: GoogleFonts.outfit(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                IconButton(
                  onPressed: (){
                    Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) {
                return ScreenProductList(
                  title: category.name!,
                  
                );
              }));
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          CarouselSlider(
            items: productsInCategory.map((product) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(ctx).push(MaterialPageRoute(
                    builder: (context) =>
                        ScreenProductDetails(product: product),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: (product.productImage.isNotEmpty)
                              ? Image.file(
                                  File(product.productImage),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/placeholder.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                appStyle.BackgroundBlack.withOpacity(0.8),
                                appStyle.BackgroundBlack.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQueryInfo.screenWidth * 0.03,
                                bottom: MediaQueryInfo.screenHeight * 0.01),
                            child: Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 20,
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 120,
              autoPlay: false,
              enlargeCenterPage: false,
              viewportFraction: 0.5,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayInterval: const Duration(seconds: 2),
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    },
  );
}
