import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invento2/database/inventory/product/product_model.dart';

ValueNotifier<List<ProductModel>> ProductListNotifier = ValueNotifier([
  ProductModel(productId: 'uhu', name: '.', category: 'n', description: 'h', unit: 'kg' , rate: 2, price: 1, minlimit: 2, maxlimit: 1, userId: '1730980661608', productImage: '')
]);

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
  required double rate,
  required double price,
  required double minlimit,
  required double maxlimit,
  required String userId, 
  required String productImage
}) async {
  await initProductDB();

  final newProduct = ProductModel(
    productId: id,
    name: name,
    category: category,
    description: description,
    unit: unit,
    rate: rate,
    price: price,
    minlimit: minlimit,
    maxlimit: maxlimit,
    userId: userId,
    productImage: productImage
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
  required String category,
  required String description,
  required String unit,
  required double rate,
  required double price,
  required double minlimit,
  required double maxlimit,
  required String productImage,
  double? stock,

}) async {
  await initProductDB();

  final product = productBox?.get(id);
  if (product != null) {
    final updatedProduct = ProductModel(
      productId: id,
      name: name,
      category: category,
      description: description,
      unit: unit,
      rate: rate,
      price: price,
      minlimit: minlimit,
      maxlimit: maxlimit,
      stock: stock ?? product.stock,
      userId: product.userId,
      productImage: productImage,
    );

    try {
      await productBox!.put(id, updatedProduct); 
      log("Product updated: ${updatedProduct.name}");

      ProductListNotifier.value = productBox!.values.toList();
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
  try {
    await productBox!.delete(id);
    log("Product with ID $id deleted");

    ProductListNotifier.value = productBox!.values.toList();
  } catch (e) {
    log("Error deleting product: $e");
  }
}
