// import 'package:flutter/material.dart';
// import 'package:invento2/screens/screen_inventory/subscreens/screen_search_and_filter/widgets/filter_drawer.dart';
// import 'package:invento2/screens/screen_inventory/subscreens/screen_search_and_filter/widgets/filter_drawer_og.dart';
// import 'package:invento2/screens/screen_inventory/subscreens/screen_search_and_filter/widgets/product_grid.dart';

// import 'package:invento2/database/inventory/product/product_model.dart';

// class SearchAndFilterSection extends StatefulWidget {
//   const SearchAndFilterSection({Key? key}) : super(key: key);

//   @override
//   State<SearchAndFilterSection> createState() => _SearchAndFilterSectionState();
// }

// class _SearchAndFilterSectionState extends State<SearchAndFilterSection> with TickerProviderStateMixin {
//   late TextEditingController searchController;
//   List<ProductModel> filteredProducts = [];
//   bool showFilterDrawer = false;
//   late AnimationController filterDrawerAnimationController;
//   late Animation<Offset> filterDrawerSlideAnimation;
//   List<String> selectedCategories = [];
//   List<String> categories = [];
//   double minPrice = 0.0;
//   double maxPrice = 1000.0;

//   @override
//   void initState() {
//     super.initState();
//     initializeState();
//   }

//   void initializeState() {
//     searchController = TextEditingController();
//     setupAnimationController();
//     loadCategoriesAndProducts();
//     setupSearchListener();
//   }

//   void setupAnimationController() {
//     filterDrawerAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );

//     filterDrawerSlideAnimation = Tween<Offset>(
//       begin: Offset(0.0, -1.0),
//       end: Offset(0.0, 0.0),
//     ).animate(CurvedAnimation(
//       parent: filterDrawerAnimationController,
//       curve: Curves.easeInOut,
//     ));
//   }

//   void loadCategoriesAndProducts() {
//     categories = loadCategories();
//     filteredProducts = loadInitialProducts();
//   }

//   void setupSearchListener() {
//     searchController.addListener(() {
//       filterProducts(searchController.text, selectedCategories, minPrice, maxPrice, (result) {
//         setState(() => filteredProducts = result);
//       });
//     });
//   }

//   void toggleFilterDrawer() {
//     setState(() {
//       showFilterDrawer = !showFilterDrawer;
//       if (showFilterDrawer) {
//         filterDrawerAnimationController.forward();
//       } else {
//         filterDrawerAnimationController.reverse();
//       }
//     });
//   }

//   void clearFilters() {
//     clearAllFilters(searchController, loadInitialProducts(), (result) {
//       setState(() {
//         selectedCategories.clear();
//         minPrice = 0.0;
//         maxPrice = getMaxProductPrice();
//         filteredProducts = result;
//       });
//     });
//   }

//   void applyFilters() {
//     applyFilterLogic(
//       searchController.text,
//       selectedCategories,
//       minPrice,
//       maxPrice,
//       (result) {
//         setState(() => filteredProducts = result);
//         toggleFilterDrawer();
//       },
//     );
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     filterDrawerAnimationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: ProductGrid(filteredProducts: filteredProducts),
//         ),
//         if (showFilterDrawer)
//           Positioned.fill(
//             top: 60,
//             child: GestureDetector(
//               onTap: toggleFilterDrawer,
//               child: Container(
//                 color: Colors.black.withOpacity(0.5),
//               ),
//             ),
//           ),
//         if (showFilterDrawer)
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: FilterDrawer(
//               animation: filterDrawerSlideAnimation,
//               categories: categories,
//               selectedCategories: selectedCategories,
//               minPrice: minPrice,
//               maxPrice: maxPrice,
//               onApply: applyFilters,
//               onClear: clearFilters,
//               onCategoryToggle: (category) {
//                 setState(() {
//                   selectedCategories.contains(category)
//                       ? selectedCategories.remove(category)
//                       : selectedCategories.add(category);
//                 });
//               },
//               onPriceChange: (values) {
//                 setState(() {
//                   minPrice = values.start;
//                   maxPrice = values.end;
//                 });
//               },
//             ),
//           ),
//         Positioned(
//           top: 0,
//           left: 0,
//           right: 0,
//           child: SearchBar1(
//             controller: searchController,
//             onFilterToggle: toggleFilterDrawer,
//           ),
//         ),
//       ],
//     );
//   }
// }