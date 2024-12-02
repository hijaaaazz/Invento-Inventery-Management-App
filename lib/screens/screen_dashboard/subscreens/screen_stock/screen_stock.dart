import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/helpers/user_prefs.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_stock/screen_stock_details.dart';
import 'package:invento2/screens/widgets/app_bar.dart';



class ScreenStock extends StatefulWidget {
  const ScreenStock({super.key});

  @override
  State<ScreenStock> createState() => _ScreenStockState();
}

class _ScreenStockState extends State<ScreenStock> {
  String _currencySymbol="";
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCurrencySymbol();  // Load the currency symbol when the widget is initialized
  }

  // Asynchronous function to load the currency symbol
  _loadCurrencySymbol() async {
    String symbol = await AppPreferences.symbol; // Fetch symbol asynchronously
    setState(() {
      _currencySymbol = symbol;  // Update the state with the fetched symbol
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundWhite,
      body: Column(
        children: [
          appBarHelper("stocks"),
          ValueListenableBuilder(
              valueListenable: ProductListNotifier,
              builder: (context, products, _) {
                double totalStockValue = products.fold(
                  0,
                  (total, product) => product.userId==userDataNotifier.value.id
                      ? total + (product.stock * product.price)
                      : total,
                );

                int noOfProducts = products
                .where((product) => product.userId == userDataNotifier.value.id)
                .length.toInt();

                List<ProductModel> fullStockCount =
                    products.where((product) => product.stock >= product.maxlimit && product.userId== userDataNotifier.value.id).toList();
                List<ProductModel> lowStockCount = products
                    .where((product) => product.stock < product.maxlimit && product.stock > 0&& product.userId== userDataNotifier.value.id).toList();
                List<ProductModel> zeroStockCount =
                    products.where((product) => product.stock == 0&& product.userId== userDataNotifier.value.id).toList();

                

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal:0, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppStyle.backgroundPurple,
                        ),
                        height: MediaQueryInfo.screenHeight * 0.15,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Stocks Value:",
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppStyle.textWhite,
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    "$_currencySymbol ${totalStockValue.toString()}",
                                    style: GoogleFonts.outfit(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: AppStyle.textWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Products",
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              noOfProducts.toString(),
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQueryInfo.screenHeight * 0.625,
                        child: Column(
                          children: [
                            stockCategoryCard("Full Stock Products", fullStockCount,
                                AppStyle.gradientGreen,context),
                            stockCategoryCard("Low Stock Products", lowStockCount,
                                AppStyle.gradientOrange,context),
                            stockCategoryCard("Zero Stock Products", zeroStockCount,
                                AppStyle.gradientRed,context),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget stockCategoryCard(String title, List<ProductModel> stockType, List<Color> gradientColors,BuildContext context,) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ScreenStockDetails(products: stockType,title: title,currencySymbol:  _currencySymbol) ));
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradientColors),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 7),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$title:",
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppStyle.textWhite,
                                ),
                              ),
                              Container(
                                height: MediaQueryInfo.screenHeight * 0.09,
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  stockType.length.toInt().toString(),
                                  style: GoogleFonts.outfit(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: AppStyle.textWhite,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
}
