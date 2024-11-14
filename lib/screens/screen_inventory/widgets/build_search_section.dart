// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:invento2/database/inventory/category/category_functions.dart';
// import 'package:invento2/database/inventory/product/product_functions.dart';
// import 'package:invento2/database/inventory/product/product_model.dart';
// import 'package:invento2/database/users/user_fuctions.dart';
// import 'package:invento2/screens/screen_inventory/widgets/filtered_grid_view.dart';

// class SearchAndFilterSection extends StatefulWidget {
//   const SearchAndFilterSection({super.key});

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

//     filteredProducts = ProductListNotifier.value
//         .where((product) => product.userId == userDataNotifier.value.id)
//         .toList();

//     searchController = TextEditingController();
//     searchController.addListener(() {
//       filterProducts(searchController.text);
//     });

//     filterDrawerAnimationController = AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 300),
//   )..addStatusListener((status) {
//       if (status == AnimationStatus.dismissed) {
//         setState(() {
//           showFilterDrawer = false; // Hide drawer when the animation ends
//         });
//       }
//     });

//     filterDrawerSlideAnimation = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0)).animate(
//     CurvedAnimation(
//       parent: filterDrawerAnimationController,
//       curve: Curves.easeInOut,
//     ),
//   );

//     categories = categoryListNotifier.value
//         .where((category) => category.name != null)
//         .map((category) => category.name!) 
//         .toList();
//     print("Categories: $categories");
//   }

//   void filterProducts(String query) {
//   setState(() {
//     filteredProducts = ProductListNotifier.value
//         .where((product) =>
//             product.userId == userDataNotifier.value.id &&
//             product.name.toLowerCase().contains(query.toLowerCase())) 
//         .toList();
        
//     filteredProducts = filteredProducts
//         .where((product) =>
//             (selectedCategories.isEmpty || selectedCategories.contains(product.category)) &&
//             product.price >= minPrice &&
//             product.price <= maxPrice)
//         .toList();
//   });
// }

// double getMaxPrice() {
//   double maxPrice = 0.0;
//   for (var product in ProductListNotifier.value) {
//     if (product.price > maxPrice) {
//       maxPrice = product.price;
//     }
//   }
//   return maxPrice;
// }


//   void toggleFilterDrawer() {
//   setState(() {
//     if (showFilterDrawer) {
//       filterDrawerAnimationController.reverse(); // Reverse animation to hide
//     } else {
//       showFilterDrawer = true;
//       filterDrawerAnimationController.forward(); // Forward animation to show
//     }
//   });
// }
//   void _clearFilters() {
//   setState(() {
//     selectedCategories.clear(); 
//     minPrice = 0.0;             
//     maxPrice = getMaxPrice(); 
//     searchController.clear();  
//     filteredProducts = ProductListNotifier.value
//         .where((product) =>
//             product.userId == userDataNotifier.value.id)
//         .toList();
//   });
// }


//   void _onCategorySelected(String category) {
//     setState(() {
//       if (selectedCategories.contains(category)) {
//         selectedCategories.remove(category);
//       } else {
//         selectedCategories.add(category);
//       }
//     });
//   }

//   void _applyFilters() {
//   setState(() {
//     filteredProducts = ProductListNotifier.value
//         .where((product) =>
//             product.userId == userDataNotifier.value.id &&
//             product.price >= minPrice &&
//             product.price <= maxPrice &&
//             (selectedCategories.isEmpty || selectedCategories.contains(product.category)))
//         .toList();
//   });
//   searchController.clear();
//   toggleFilterDrawer();
// }
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
//           child: ListView(
//           padding: const EdgeInsets.only(top: 100),
//           children: [
//             if (filteredProducts.isEmpty) 
//               Center(child: Text("No products found.")),
//             if (filteredProducts.isNotEmpty) 
//               showGridView(filteredProducts)
//           ],
//         ),
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
//             child: SlideTransition(
//               position: filterDrawerSlideAnimation,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 height: 400,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                   borderRadius: const BorderRadius.vertical(
//                     bottom: Radius.circular(15),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 60),
//                     Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'Filters',
//                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.close),
//                             onPressed: toggleFilterDrawer,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                       child: Wrap(
//                         spacing: 8.0,
//                         runSpacing: 4.0,
//                         children: categories.map((category) {
//                           return FilterChip(
//                             label: Text(category),
//                             selected: selectedCategories.contains(category),
//                             onSelected: (_) => _onCategorySelected(category),
//                           );
//                         }).toList(),
//                       ),
//                     ), 
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                       child: Column(
//                         children: [
//                           const Text("Price Range"),
//                           RangeSlider(
//                             values: RangeValues(minPrice, maxPrice),
//                             min: 0.0,
//                             max: getMaxPrice(),
//                             divisions: 20,
//                             labels: RangeLabels(
//                               minPrice.toStringAsFixed(2),
//                               maxPrice.toStringAsFixed(2),
//                             ),
//                             onChanged: (values) {
//                               setState(() {
//                                 minPrice = values.start;
//                                 maxPrice = values.end;
//                               });
//                             },
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 10),
//                             child: Text(
//                               'Selected Price Range: \₹${minPrice.toStringAsFixed(2)} - \₹${maxPrice.toStringAsFixed(2)}',
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           ElevatedButton(
//                             onPressed: _applyFilters,
//                             child: const Text('Apply Filters'),
//                           ),
//                           ElevatedButton(
//                             onPressed: _clearFilters,
//                             child: const Text('Clear Filters'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         Positioned(
//           top: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             color: Colors.white,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   width: MediaQuery.of(context).size.width * 0.7831,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             controller: searchController,
//                             decoration: const InputDecoration(
//                               hintText: "Search...",
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.all(10),
//                             ),
//                           ),
//                         ),
//                         const Icon(Icons.search),
//                       ],
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.filter_list_outlined),
//                   onPressed: toggleFilterDrawer,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// } 