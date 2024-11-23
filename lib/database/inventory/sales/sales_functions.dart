import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/sales/sales_model.dart';  // Assume SalesModel is used instead of ProductModel
import 'package:invento2/database/inventory/purchase/purchase_model.dart'; // Assuming PurchaseModel still used
import 'package:invento2/database/users/user_fuctions.dart';  // Assuming you have some user functions to manage user data

// Value notifiers to update UI
ValueNotifier<List<SaleProduct>> salesAddedProductsList = ValueNotifier([]);
ValueNotifier<List<SalesModel>> salesList = ValueNotifier([]);

late Box<SalesModel> salesBox;
late Box<int> counterBox;

int SalesinvoiceCounter = 1; 

// Initialize Sales Database
Future<void> initSalesDatabase() async {
  try {
    if (!Hive.isBoxOpen('salesBox')) {
      salesBox = await Hive.openBox<SalesModel>('salesBox');
    }
    if (!Hive.isBoxOpen('salescounterBox')) {
      counterBox = await Hive.openBox<int>('salescounterBox');
    }

    SalesinvoiceCounter = counterBox.get('invoiceCounter') ?? 1;

  salesList.value = salesBox.values.toList();
    salesList.notifyListeners();

    log("Sales Database initialized with ${salesList.value.length} sales");
    log("Current invoice counter: $SalesinvoiceCounter");
  } catch (e) {
    log("Error initializing sales database: $e");
  }
}

Future<void> addSale(
  BuildContext ctx,
  double grandTotal ,
  customerName,
  customerNumber) async {
  try {
    if (!Hive.isBoxOpen('salesBox')) {
      await initSalesDatabase();
    }

    if (salesAddedProductsList.value.isEmpty) {
      showErrorSnackbar("No products added to sale", ctx);
      return;
    }
    updateProductStocks(List.from(salesAddedProductsList.value)); 


    final newSale = SalesModel(
      id: "${DateTime.now().microsecondsSinceEpoch}",
      saleNumber: "SINV-$SalesinvoiceCounter",
      saleProducts: List.from(salesAddedProductsList.value),
      userId: userDataNotifier.value.id,
      customerName: customerName,
      grandTotal: grandTotal,
      customerNumber: customerNumber

    );

    updateProductStocks(List.from(salesAddedProductsList.value)); 
    salesAddedProductsList.value.clear();

    await salesBox.put(newSale.id, newSale);

    SalesinvoiceCounter++;
    await counterBox.put('invoiceCounter', SalesinvoiceCounter);

    salesList.value = salesBox.values.toList();
    salesList.notifyListeners();

    showSuccessSnackbar("Sale added successfully!", ctx);
    Navigator.of(ctx).pop(); // Close the screen after success
  } catch (e) {
    log("Error in addSale: $e");
    showErrorSnackbar("Error occurred: $e", ctx);
  }
}

// Update Sales Product Stocks after sal
Future<void> updateProductStocks(List<SaleProduct> soldProducts) async {
  // Assuming SalesProduct is a class similar to PurchaseProduct but related to sales
  await initSalesDatabase();

  for (final soldProduct in soldProducts) {
    final productId = soldProduct.product.productId;
    final quantityToSubtract = soldProduct.quantity;

    final existingProduct = productBox?.get(productId);

    if (existingProduct != null) {
      double updatedStock = existingProduct.stock - quantityToSubtract;

      if (updatedStock < 0) {
        log("Stock cannot be negative for product $productId");
        continue;
      }

      // Update the product stock after the sale
      await updateProduct(
        id: existingProduct.productId,
        name: existingProduct.name,
        description: existingProduct.description,
        minlimit: existingProduct.minlimit,
        maxlimit: existingProduct.maxlimit,
        productImage: existingProduct.productImage,
        category: existingProduct.category,
        price: existingProduct.price,  // We use price here instead of rate for sales
        stock: updatedStock,
        rate: existingProduct.rate
      );
    }
  }

  log("All stocks updated successfully after sale.");
}

// Show error snackbar
void showErrorSnackbar(String message, BuildContext ctx) {
  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(message)));
}

// Show success snackbar
void showSuccessSnackbar(String message, BuildContext ctx) {
  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(message)));
}
