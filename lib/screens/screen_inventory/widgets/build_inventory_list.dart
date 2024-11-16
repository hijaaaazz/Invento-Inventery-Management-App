import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/category/category_model.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_inventory/widgets/add_category_dialog.dart';
import 'package:invento2/screens/screen_inventory/widgets/all_build.dart';
import 'package:invento2/screens/screen_inventory/widgets/gategory_build.dart';

class InventoryList extends StatefulWidget {
  final UserModel userData;

  const InventoryList({super.key, required this.userData});

  @override
  // ignore: library_private_types_in_public_api
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  late List<CategoryModel> categoryList;

  @override
  void initState() {
    super.initState();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    categoryListNotifier.notifyListeners;
    
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        buildAllSection(widget.userData, context),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Categories",
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              IconButton(
                onPressed: () {
                  showAddCategoryDialog(context, widget.userData.id);
                },
                icon: const Icon(
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

                        if(updatedList.isEmpty){
                          return
                            Center(
                              child: Text(
                              "No Category in Inventory, Add Now!!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            );
    
                        }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: updatedList.length,
                        itemBuilder: (context, index) {
                          final category = updatedList[index];
                          return buildCategorySection(category, index, widget.userData, context);
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
}
