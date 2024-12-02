import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'category_model.dart';

ValueNotifier<List<CategoryModel>> categoryListNotifier = ValueNotifier<List<CategoryModel>>([]);

Box<CategoryModel>? categoryBox;


Future<void> initCategoryDB() async {
  try {
    if (categoryBox == null) {
      categoryBox = await Hive.openBox<CategoryModel>('category_db');
    }
    // Filter and update the list
    categoryListNotifier.value = categoryBox!.values
        .where((category) => category.userId == userDataNotifier.value.id)
        .toList();
    
    // Notify listeners explicitly
    categoryListNotifier.notifyListeners();
  } catch (e) {
    log('Error initializing category DB: $e');
  }
}


Future<bool> addCategory({
  required String categoryId,
  required String categoryName,
  required String userId,
}) async {
  await initCategoryDB();

  final newCategory = CategoryModel(
    id: categoryId,
    name: categoryName,
    userId: userId,
  );

  try {
    await categoryBox!.put(categoryId, newCategory);
    log("Category added: $categoryName");

    categoryListNotifier.value = categoryBox!.values
        .where((category) => category.userId == userDataNotifier.value.id)
        .toList();
    
    // Notify listeners explicitly
    categoryListNotifier.notifyListeners();

    return true;
  } catch (e) {
    log("Error adding category: $e");
    return false;
  }
}




Future<List<CategoryModel>> getAllCategories() async {
  await initCategoryDB();
  return categoryBox!.values.toList();
}

Future<bool> categoryExists(String categoryId) async {
  await initCategoryDB();
  return categoryBox!.containsKey(categoryId);
}


Future<void> deleteCategory(
  String categoryId,
  BuildContext context,
) async {
  await initCategoryDB();

  if (categoryBox == null) {
    log("Category box is not initialized");
    return;
  }

  if (await categoryExists(categoryId)) {
    try {
      await categoryBox!.delete(categoryId);
      log("Category with ID $categoryId deleted successfully");

      categoryListNotifier.value = categoryBox!.values
          .where((category) => category.userId == userDataNotifier.value.id)
          .toList();
      
      // Notify listeners explicitly
      categoryListNotifier.notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category deleted successfully')),
      );
    } catch (e) {
      log("Error deleting category: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting category')),
      );
    }
  } else {
    log("Category with ID $categoryId not found.");
  }
}
