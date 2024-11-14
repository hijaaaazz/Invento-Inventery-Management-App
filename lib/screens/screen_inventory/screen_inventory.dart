import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/category/category_model.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_search_and_filter/screen_search_and_filter_main.dart';
import 'package:invento2/screens/screen_inventory/widgets/build_inventory_list.dart';
import 'package:invento2/screens/screen_inventory/widgets/build_search_section.dart';
import 'package:invento2/screens/screen_inventory/widgets/build_appbar.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

class ScreenInventory extends StatefulWidget {
  final dynamic userData;

  const ScreenInventory({super.key, required this.userData});

  @override
  State<ScreenInventory> createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends State<ScreenInventory> {
  late List<ProductModel> products;
  late List<CategoryModel> categoryList;
  bool isSearchClicked = false;

  @override
  void initState() {
    super.initState();
    products = [];
  }

  void toggleSearch() {
    setState(() {
      isSearchClicked = !isSearchClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appStyle = AppStyle();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: InventoryAppBar(
        isSearchClicked: isSearchClicked,
        toggleSearch: toggleSearch,
        appStyle: appStyle,
      ),
      body: Stack(
        children: [
          // Apply the animated transition between Search and Inventory sections
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: isSearchClicked
                ? SearchAndFilterSection(key: ValueKey('search')) 
                : build_inventory_list(context, widget.userData), 
            transitionBuilder: (child, animation) {
              const curve = Curves.easeInOut;

              const beginSearch = Offset(0, -1);
              const endSearch = Offset.zero;

              
              const beginInventory = Offset(0, 1); 
              const endInventory = Offset.zero;

              var tween = Tween(
                begin: isSearchClicked ? beginSearch : beginInventory,
                end: isSearchClicked ? endSearch : endInventory,
              ).chain(CurveTween(curve: curve));

              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.0),
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(1.0),
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(1.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
