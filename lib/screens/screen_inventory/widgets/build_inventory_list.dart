import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/category/category_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_inventory/widgets/add_category_dialog.dart';
import 'package:invento2/screens/screen_inventory/widgets/all_build.dart';
import 'package:invento2/screens/screen_inventory/widgets/gategory_build.dart';

Widget build_inventory_list(BuildContext ctx, dynamic userData) {
  return Column(
    children: [
      const SizedBox(height: 15),
      buildAllSection(userData, ctx),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Categories",
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () {
                showAddCategoryDialog(ctx, userData.id);
              },
              child: const Icon(
                Icons.add_circle_outline_rounded,
                size: 16,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ValueListenableBuilder<List<CategoryModel>>(
                valueListenable: categoryListNotifier,
                builder: (ctx, updatedList, _) {
                  final userSpecificCategories = updatedList
                      .where((category) => category.userId == userData.id)
                      .toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userSpecificCategories.length,
                    itemBuilder: (context, index) {
                      final category = userSpecificCategories[index];
                      return buildCategorySection(
                          category, index, userData, ctx);
                    },
                  );
                },
              ),
              SizedBox(height: MediaQueryInfo.screenHeight * 0.2),
            ],
          ),
        ),
      ),
    ],
  );
}
