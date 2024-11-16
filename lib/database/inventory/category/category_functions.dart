import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'category_model.dart';

ValueNotifier<List<CategoryModel>> categoryListNotifier = ValueNotifier<List<CategoryModel>>([]);

Box<CategoryModel>? categoryBox;

Future<void> initCategoryDB() async {
  try {
    if (categoryBox == null) {
      categoryBox = await Hive.openBox<CategoryModel>('category_db');
      categoryListNotifier.value = categoryBox!.values.toList();
    }
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

    categoryListNotifier.value = categoryBox!.values.toList();
    return true;
  } catch (e) {
    log("Error adding category: $e");
    return false;
  }
}

Future<void> updateCategory({
  required String categoryId,
  required String categoryName,
  required String userId,
}) async {
  await initCategoryDB();

  if (categoryBox == null) {
    log("Category database is not initialized.");
    return;
  }

  final category = categoryBox?.get(categoryId);
  if (category != null) {
    final updatedCategory = CategoryModel(
      id: categoryId,
      name: categoryName,
      userId: userId,
    );

    try {
      await categoryBox?.put(categoryId, updatedCategory);
      log("Category updated successfully: ${updatedCategory.name}");

      categoryListNotifier.value = [...categoryBox!.values];
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      categoryListNotifier.notifyListeners();
    } catch (e) {
      log("Error updating category: $e");
    }
  } else {
    log("Category with ID $categoryId not found.");
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
  String userId,
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
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
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
