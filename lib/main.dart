import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/category/category_model.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/database/inventory/purchase/purchase_functions.dart';
import 'package:invento2/database/inventory/purchase/purchase_model.dart';
import 'package:invento2/database/inventory/sales/sales_functions.dart';
import 'package:invento2/database/inventory/sales/sales_model.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_splash/screen_splash.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PurchaseModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(PurchaseProductAdapter());
  Hive.registerAdapter(SaleProductAdapter());
  Hive.registerAdapter(SalesModelAdapter());

  try {
    await initUserDB();
    await initCategoryDB();
    await initProductDB();
    await initPurchaseDatabase();
    await initSalesDatabase();
  // ignore: empty_catches
  } catch (e) {
    log(e.toString());
  }
  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryInfo.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.black,
            displayColor: Colors.black,
          ),
        ),
      ),
      home: const ScreenSplash(),
    );
  }
}