import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/category/category_model.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/screens/screen_inventory/widgets/build_inventory_list.dart';
import 'package:invento2/screens/screen_inventory/widgets/build_search_section.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class ScreenInventory extends StatefulWidget {
  final UserModel userData;

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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppStyle.backgroundWhite,
      appBar: appBarHelper("inventory",actions:[ Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: isSearchClicked
                ? const Icon(Icons.close,)
                : const Icon(Icons.search,),
            onPressed: () {
              toggleSearch(); 
            },
          ),
        ),]
       
      ),
      body: Stack(
        children: [
         AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: isSearchClicked
              ? const SearchAndFilterSection(key: ValueKey('search'))
              : InventoryList(userData: widget.userData,),
          transitionBuilder: (child, animation) {
            const curve = Curves.easeInOut;

            const beginSearchIn = Offset(0, -1); 
            const beginSearchOut = Offset(0, 1);  

            const beginInventoryIn = Offset(0, 1); 
            const beginInventoryOut = Offset(0, -1); 

            var tween = Tween<Offset>(
              begin: child.key == const ValueKey('search') ? beginSearchIn : beginInventoryIn,
              end: Offset.zero,
            ).chain(CurveTween(curve: curve));

            if (animation.status == AnimationStatus.reverse) {
              tween = Tween<Offset>(
                begin: child.key == const ValueKey('search') ? beginSearchOut : beginInventoryOut,
                end: Offset.zero,
              ).chain(CurveTween(curve: curve));
            }

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
                    AppStyle.backgroundWhite.withOpacity(0.0),
                    AppStyle.backgroundWhite.withOpacity(1.0),
                    AppStyle.backgroundWhite.withOpacity(1.0),
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
