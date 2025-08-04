// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'category_model.dart';

ValueNotifier<List<CategoryModel>> categoryListNotifier = ValueNotifier<List<CategoryModel>>([]);

Box<CategoryModel>? categoryBox;

Future<void> initCategoryDB() async {
  try {
    if (!Hive.isBoxOpen('category_db')) {
      categoryBox = await Hive.openBox<CategoryModel>('category_db');
    } else {
      categoryBox = Hive.box<CategoryModel>('category_db');
    }

    // Move notifier update into separate function
    _updateCategoryList();
  } catch (e) {
    log('Error initializing category DB: $e');
  }
}

void _updateCategoryList() {
  if (categoryBox != null) {
    final values = categoryBox!.values.toList();
    categoryListNotifier.value = [...values]; // force rebuild
    categoryListNotifier.notifyListeners();
  }
}


Future<void> refreshCategoryList() async {
  if (categoryBox == null || !Hive.isBoxOpen('category_db')) {
    categoryBox = await Hive.openBox<CategoryModel>('category_db');
  }

  categoryListNotifier.value = categoryBox!.values.toList();
  categoryListNotifier.notifyListeners();
}

Future<bool> addCategory({
  required String categoryId,
  required String categoryName,
}) async {
  await initCategoryDB();

  final newCategory = CategoryModel(
    id: categoryId,
    name: categoryName,
    userId: '', // optional or ignored for single user
  );

  try {
    await categoryBox!.put(categoryId, newCategory);
    log("Category added: $categoryName");

    categoryListNotifier.value = categoryBox!.values.toList();
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

      categoryListNotifier.value = categoryBox!.values.toList();
      categoryListNotifier.notifyListeners();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category deleted successfully')),
      );
    } catch (e) {
      log("Error deleting category: $e");

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting category')),
      );
    }
  } else {
    log("Category with ID $categoryId not found.");
  }
}
