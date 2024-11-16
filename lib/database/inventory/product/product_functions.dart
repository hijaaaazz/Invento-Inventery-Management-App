import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invento2/database/inventory/product/product_model.dart';

// ignore: non_constant_identifier_names
ValueNotifier<List<ProductModel>> ProductListNotifier = ValueNotifier([]);
// ignore: non_constant_identifier_names
ValueNotifier<List<ProductModel>> FilteredProductListNotifier = ValueNotifier([]);
ValueNotifier<ProductModel> productDetailsNotifier= ValueNotifier(ProductModel(userId: '', productId: '', name: '', category: '', description: '', unit: '', price: 0, minlimit: 0, maxlimit: 0, rate: 0, productImage: '',));


// ignore: constant_identifier_names
const PRODUCT_DB_NAME = 'product_db';
Box<ProductModel>? productBox;

Future<void> initProductDB() async {
  try {
    if (productBox == null) {
      productBox = await Hive.openBox<ProductModel>(PRODUCT_DB_NAME);
      ProductListNotifier.value = productBox!.values.toList();
    }
  } catch (e) {
    log('Error initializing productDB: $e');
  }
}

Future<bool> addProduct({
  required String id,
  required String name,
  required String category,
  required String description,
  required String unit,
  required double price,
  required double minlimit,
  required double maxlimit,
  required String userId, 
  required String productImage,
  required double rate
}) async {
  
  await initProductDB();

  final newProduct = ProductModel(
    productId: id,
    name: name,
    category: category,
    description: description,
    unit: unit,
    price: price,
    minlimit: minlimit,
    maxlimit: maxlimit,
    userId: userId,
    productImage: productImage,
    rate: rate
  );

  try {
    await productBox!.put(id, newProduct); 
    log("Product added: $name");

    ProductListNotifier.value = productBox!.values.toList();
    return true;
  } catch (e) {
    log("Error adding product: $e");
    return false;
  }
}
Future<void> updateProduct({
  required String id,
  required String name,
  required String description,
  required double minlimit,
  required double maxlimit, 
  required String productImage,
  required String category,
  required double price,
  required double rate,
}) async {
  await initProductDB();

  if (productBox == null) {
    log("Product database is not initialized.");
    return;
  }

  final product = productBox?.get(id);
  if (product != null) {
    if (product.stock < 0) {
      log("Stock cannot be negative");
      return;
    }

    final updatedProduct = ProductModel(
      productId: id,
      name: name,
      category: category,
      description: description,
      unit: product.unit,
      price: price,
      rate: rate,
      minlimit: minlimit,
      maxlimit: maxlimit,
      stock: product.stock, 
      userId: product.userId,
      productImage: productImage,
    );

    try {
      await productBox?.put(id, updatedProduct);
      log("Product updated successfully: ${updatedProduct.name}");

      ProductListNotifier.value = [...productBox!.values];
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      ProductListNotifier.notifyListeners();

      productDetailsNotifier.value = updatedProduct;
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      productDetailsNotifier.notifyListeners();
    } catch (e) {
      log("Error updating product: $e");
    }
  } else {
    log("Product with ID $id not found.");
  }
}


Future<List<ProductModel>> getAllProducts() async {
  await initProductDB();
  return productBox!.values.toList();
}

Future<bool> productExists(String id) async {
  await initProductDB();
  return productBox!.containsKey(id);
}
Future<void> deleteProduct(String id) async {
  await initProductDB();
  
  if (productBox == null) {
    log("Product box is not initialized");
    return;
  }

  if (await productExists(id)) {
    try {
      await productBox!.delete(id);
      log("Product with ID $id deleted successfully");
      
      ProductListNotifier.value = productBox!.values.toList();
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      ProductListNotifier.notifyListeners();
      
    } catch (e) {
      log("Error deleting product: $e");
    }
  } else {
    log("Product with ID $id not found.");
  }
}
