import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/product/product_model.dart';

class FilterDrawer extends StatefulWidget {
  final Function(List<String> selectedCategories, double minPrice, double maxPrice)
      onFiltersApplied;

  const FilterDrawer({super.key, required this.onFiltersApplied});

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  late List<String> selectedCategories;
  late double minPrice;
  late double maxPrice;
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    selectedCategories = [];
    minPrice = 0.0;
    maxPrice = getMaxPrice();
    categories = categoryListNotifier.value
        .where((category) => category.name != null)
        .map((category) => category.name!)
        .toList();
  }

  double getMaxPrice() {
    double maxPrice = 0.0;
    for (var product in ProductListNotifier.value) {
      if (product.price > maxPrice) {
        maxPrice = product.price;
      }
    }
    return maxPrice;
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(selectedCategories, minPrice, maxPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: 60,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }
}
