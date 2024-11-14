import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invento2/database/inventory/inventory_model.dart';
import 'category_model.dart';

ValueNotifier<List<CategoryModel>> categoryListNotifier = ValueNotifier<List<CategoryModel>>([]);


const CATEGORY_DB_NAME = 'categoryBox';
Box<InventoryModel>? inventoryBox;

Future<void> initCategoryDB() async {
  try {
    inventoryBox = await Hive.openBox<InventoryModel>('inventoryBox');
    await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
  } catch (e) {
    log("Error initializing category DB: $e");
  }
}

Future<void> addCategory({
  required String userId,
  required String categoryName,
  required String categoryId,
}) async {
  try {
    await initCategoryDB();
    if (inventoryBox == null) {
     
      return;
    }

    final existingInventory = inventoryBox!.values.firstWhere(
      (inventory) => inventory.userId == userId,
      orElse: () => InventoryModel(userId: userId, categories: []),
    );

    final newCategory = CategoryModel(name: categoryName, userId: userId, id: categoryId);
    existingInventory.categories?.add(newCategory);
    await inventoryBox!.put(userId, existingInventory);

    categoryListNotifier.value = existingInventory.categories!;
    categoryListNotifier.notifyListeners();


  } catch (e) {
    
  }
}
Future<void> deleteCategory(
  String categoryId,
  String userId,
  BuildContext context,
) async {
  try {
    await initCategoryDB();
    if (inventoryBox == null) return;
    final existingInventory = inventoryBox!.get(userId);

    if (existingInventory != null) {
      existingInventory.categories?.removeWhere((category) => category.id == categoryId);

      await inventoryBox!.put(userId, existingInventory);

      categoryListNotifier.value = existingInventory.categories!;
      categoryListNotifier.notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category deleted successfully')),
      );
    }
  } catch (e) {
    log("Error deleting category: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error deleting category')),
    );
  }
}
