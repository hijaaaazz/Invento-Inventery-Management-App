import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/database/inventory/purchase/purchase_model.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/screens/widgets/snackbar.dart';
import 'package:lottie/lottie.dart';

ValueNotifier<List<PurchaseProduct>> puchasesAddedProductsList = ValueNotifier([]);
ValueNotifier<List<PurchaseModel>> purchasesList = ValueNotifier([]);

late Box<PurchaseModel> purchaseBox;
late Box<int> counterBox;

int invoiceCounter = 1; 
Future<void> initPurchaseDatabase() async {
  try {
    if (!Hive.isBoxOpen('purchaseBox')) {
      purchaseBox = await Hive.openBox<PurchaseModel>('purchaseBox');
    }
        if (!Hive.isBoxOpen('counterBox')) {
      counterBox = await Hive.openBox<int>('counterBox');
    }

    invoiceCounter = counterBox.get('invoiceCounter') ?? 1;

    purchasesList.value = purchaseBox.values.toList();
    purchasesList.notifyListeners();

    log("Database initialized with ${purchasesList.value.length} purchases");
    log("Current invoice counter: $invoiceCounter");
  } catch (e) {
    log("Error initializing purchase database: $e");
  }
}



Future<void> addPurchase(BuildContext ctx,double grandTotal) async {
  try {
    if (!Hive.isBoxOpen('purchaseBox')) {
      await initPurchaseDatabase();
    }
    if (puchasesAddedProductsList.value.isEmpty) {
      showCustomSnackbar("No products added to purchase", ctx,Colors.red,lottie:  Lottie.asset("assets/gifs/error.json"));
      return;
    }

    final newPurchase = PurchaseModel(
      id: "${DateTime.now().microsecondsSinceEpoch}",
      purchaseNumber: "INV-$invoiceCounter",
      purchaseProducts: List.from(puchasesAddedProductsList.value),
      userId: userDataNotifier.value.id,
      GrandTotal: grandTotal
    );
    updateProductStocks(List.from(puchasesAddedProductsList.value));
    puchasesAddedProductsList.value.clear();
    
    await purchaseBox.put(newPurchase.id, newPurchase);

    invoiceCounter++;
    await counterBox.put('invoiceCounter', invoiceCounter);
    
    purchasesList.value = purchaseBox.values.toList();
    purchasesList.notifyListeners();
    
    showCustomSnackbar("Purchase added successfully!", ctx,Colors.green ,lottie:Lottie.asset("assets/gifs/truck.json") );
    Navigator.of(ctx).pop(); // Close screen after success
  } catch (e) {
    log("Error in addPurchase: $e");
    showCustomSnackbar("Error occurred: $e", ctx,Colors.red,);
    
  }
}


