import 'dart:async';
import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/database/users/user_fuctions.dart';
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

  List<ProductModel> filteredProducts = [];
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

    filterDrawerSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: filterDrawerAnimationController,
      curve: Curves.easeInOut,
    ));

    categories = categoryListNotifier.value
        .where((category) => category.name != null)
        .map((category) => category.name!)
        .toList();

    filteredProducts = ProductListNotifier.value
        .where((product) => product.userId == userDataNotifier.value.id)
        .toList();
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = ProductListNotifier.value.where((product) {
        return product.userId == userDataNotifier.value.id &&
            product.name.toLowerCase().contains(query.toLowerCase()) &&
            (selectedCategories.isEmpty || selectedCategories.contains(product.category)) &&
            product.price >= minPrice &&
            product.price <= maxPrice;
      }).toList();
    });
  }

  double getMaxPrice() {
    return ProductListNotifier.value.fold(0.0, (max, product) => product.price > max ? product.price : max);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ListView(
            padding: const EdgeInsets.only(top: 100),
            children: filteredProducts.isEmpty
                ? [const Center(child: Text("No products found."))]
                : [showGridView(filteredProducts)],
          ),
        ),

        if (showFilterDrawer)
          Positioned.fill(
            top: 60,
            child: GestureDetector(
              onTap: toggleFilterDrawer,
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),

        if (showFilterDrawer)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: filterDrawerSlideAnimation,
              child: _buildFilterDrawer(),
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
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
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

  Widget _buildFilterDrawer() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 60),
          _buildFilterHeader(),
          _buildCategoryFilter(),
          _buildPriceFilter(),
          _buildFilterButtons(),
        ],
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Filters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          IconButton(icon: const Icon(Icons.close), onPressed: toggleFilterDrawer),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: categories.map((category) {
          return FilterChip(
            label: Text(category),
            selected: selectedCategories.contains(category),
            onSelected: (_) => _onCategorySelected(category),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPriceFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          const Text("Price Range"),
          RangeSlider(
            values: RangeValues(minPrice, maxPrice),
            min: 0.0,
            max: getMaxPrice(),
            divisions: 20,
            onChanged: (values) => setState(() {
              minPrice = values.start;
              maxPrice = values.end;
            }),
          ),
          Text('Selected Price Range: ₹${minPrice.toStringAsFixed(2)} - ₹${maxPrice.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(onPressed: _applyFilters, child: const Text('Apply Filters')),
          ElevatedButton(onPressed: _clearFilters, child: const Text('Clear Filters')),
        ],
      ),
    );
  }
}
