import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invento2/database/inventory/inventory_model.dart';
import 'category_model.dart';

ValueNotifier<List<CategoryModel>> categoryListNotifier = ValueNotifier<List<CategoryModel>>([]);

const CATEGORY_DB_NAME = 'category_db';


Box<InventoryModel>? inventoryBox;
Future<void> initCategoryDB() async {
  try {
    // Open or initialize category database here
    inventoryBox = await Hive.openBox<InventoryModel>('inventoryBox');  // Make sure this box is properly opened
    var categoryBox = await Hive.openBox<CategoryModel>('categoryBox');  // Open category box
  } catch (e) {
    print("Error initializing category DB: $e");
  }
}


Future<void> addCategory({
  required String userId,
  required String categoryName,
}) async {
  try {
    await initCategoryDB();  // Ensure categoryDB is initialized

    if (inventoryBox == null) {
      print('Inventory box is not initialized');
      return;
    }

    // Check if an inventory already exists for the user, or create a new one
    final existingInventory = inventoryBox!.values.firstWhere(
      (inventory) => inventory.userId == userId, 
      orElse: () => InventoryModel(userId: userId, categories: []),
    );

    // Create a new CategoryModel with the required fields
    final newCategory = CategoryModel(name: categoryName, userId: userId);

    // Update the inventory with the new category
    existingInventory.categories?.add(newCategory);

    // Save the updated inventory back to the box
    await inventoryBox!.put(userId, existingInventory);
    
    // Optionally, update your ValueNotifier
    categoryListNotifier.value = existingInventory.categories!;
    categoryListNotifier.notifyListeners();  // Notify listeners to update the UI

    print('Category added successfully for user: $userId');
  } catch (e) {
    print('Error adding category: $e');
  }
}

