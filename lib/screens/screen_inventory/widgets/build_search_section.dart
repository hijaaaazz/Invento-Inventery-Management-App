import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/screens/screen_inventory/widgets/filter_drawer.dart';
import 'package:invento2/screens/screen_inventory/widgets/filtered_grid_view.dart';

class SearchAndFilterSection extends StatefulWidget {
  const SearchAndFilterSection({super.key});

  @override
  State<SearchAndFilterSection> createState() => _SearchAndFilterSectionState();
}

class _SearchAndFilterSectionState extends State<SearchAndFilterSection> with TickerProviderStateMixin {
  late TextEditingController searchController;
  late AnimationController filterDrawerAnimationController;
  late Animation<Offset> filterDrawerSlideAnimation;

  late ValueNotifier<List<ProductModel>> filteredProductsNotifier;
  List<String> selectedCategories = [];
  List<String> categories = [];
  bool showFilterDrawer = false;
  double minPrice = 0.0;
  double maxPrice = 1000.0;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(() => filterProducts(searchController.text));

    filterDrawerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() => showFilterDrawer = false);
        }
      });

    filterDrawerSlideAnimation = Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: filterDrawerAnimationController, curve: Curves.easeInOut));

    categories = categoryListNotifier.value
        .map((category) => category.name!)
        .toList();

    filteredProductsNotifier = ValueNotifier(
      ProductListNotifier.value
      .where((product) => product.userId == userDataNotifier.value.id)  
      .toList(),);  

      _clearFilters();
  }

  void filterProducts(String query) {
  filteredProductsNotifier.value = ProductListNotifier.value
      .where((product) {
        return product.userId == userDataNotifier.value.id &&
            product.name.toLowerCase().contains(query.toLowerCase()) &&
            (selectedCategories.isEmpty || selectedCategories.contains(product.category)) &&
            product.price >= minPrice &&
            product.price <= maxPrice;
      })
      .toList()
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
}


  double getMaxPrice() {
  double maxPrice = ProductListNotifier.value.fold(
      0.0, (max, product) => product.price > max ? product.price : max);
  return maxPrice;
}



  void toggleFilterDrawer() {
    setState(() {
      if (showFilterDrawer) {
        filterDrawerAnimationController.reverse();
      } else {
        showFilterDrawer = true;
        filterDrawerAnimationController.forward();
      }
    });
  }

  void _clearFilters() {
    setState(() {
      selectedCategories.clear();
      minPrice = 0.0;
      maxPrice = getMaxPrice();
      searchController.clear();
      filterProducts('');
    });
  }

  void _applyFilters() {
    filterProducts(searchController.text);
    toggleFilterDrawer();
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategories.contains(category)
          ? selectedCategories.remove(category)
          : selectedCategories.add(category);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    filterDrawerAnimationController.dispose();
    filteredProductsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: ProductGridView(filteredProductsNotifier: filteredProductsNotifier,getMaxPrice: getMaxPrice,clearfilter: _clearFilters,),
          ),
        ),

        if (showFilterDrawer)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: filterDrawerSlideAnimation,
              child: FilterDrawer(
                categories: categories,
                selectedCategories: selectedCategories,
                minPrice: minPrice,
                maxPrice: maxPrice,
                getMaxPrice: getMaxPrice,
                onPriceChanged: (start, end) {
                  setState(() {
                    minPrice = start;
                    maxPrice = end;
                  });
                },
                onCategorySelected: _onCategorySelected,
                onApplyFilters: _applyFilters,
                onClearFilters: _clearFilters,
                onCloseDrawer: toggleFilterDrawer,
              ),
            ),
          ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _buildSearchBar(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              
              cursorHeight: 15,
              cursorColor: Colors.black,
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Products...",
                hintStyle: GoogleFonts.inter(
                  fontSize: 15
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: toggleFilterDrawer,
          ),
        ],
      ),
    );
  }

  

}

