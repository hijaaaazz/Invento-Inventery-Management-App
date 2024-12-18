import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_add/subscreens/screen_add_product/screen_add_product.dart';
import 'package:invento2/screens/screen_add/subscreens/screen_add_purchses/screen_add_purchses.dart';
import 'package:invento2/screens/screen_add/subscreens/screen_add_sales/screen_add_sales.dart';
import 'package:invento2/screens/widgets/app_bar.dart';
import 'package:lottie/lottie.dart';

class ScreenAddOrder extends StatefulWidget {
  final dynamic userData;
  const ScreenAddOrder({super.key, required this.userData});

  @override
  State<ScreenAddOrder> createState() => _ScreenAddOrderState();
}

class _ScreenAddOrderState extends State<ScreenAddOrder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundWhite,
      appBar: appBarHelper("add items"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            buildCustomContainer(
              context,
              title: "Add Sales",
              gradientColors: AppStyle.gradientGreen,
              lottieFile: "assets/gifs/add_sales.json",
               right: 10,
              bottom: 20,
              lottieSize: MediaQueryInfo.screenWidth*0.3,
              screen: const ScreenAddSales()

            ),
            const SizedBox(height: 20),
            buildCustomContainer(
              context,
              title: "Add Purchases",
              gradientColors: AppStyle.gradientBlue,
              lottieFile: "assets/gifs/add_purchases.json",
               right: -10,
              bottom: -70,
              lottieSize: MediaQueryInfo.screenWidth*0.4,
              screen: const ScreenAddPurchases()
            ),
            const SizedBox(height: 20),
            buildCustomContainer(
              context,
              title: "Add Product",
              gradientColors: AppStyle.gradientOrange,
              lottieFile: "assets/gifs/box.json",
              right: 0,
              bottom: 0,
              lottieSize: MediaQueryInfo.screenWidth*0.4,
              screen: const ScreenAddProduct()
             
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomContainer(BuildContext context,
      {required String title,
      required List<Color> gradientColors,
      required String lottieFile,
      required double right,
      required double bottom,
      required double lottieSize,
      required Widget screen
      }) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> screen));
      },
      child: Container(
        height: MediaQueryInfo.screenHeight * 0.23,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              
              child: Container(
                width: MediaQueryInfo.screenWidth * 0.4,
                padding: const EdgeInsets.only(left: 25, top: 25),
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.textWhite,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: MediaQueryInfo.screenHeight*0.2,
                width: MediaQueryInfo.screenWidth*0.2,
                child: ClipRRect(
                  
                  borderRadius: BorderRadius.circular(10),
                  child: Lottie.asset(
                    fit: BoxFit.contain,
                    lottieFile,
                    width: lottieSize,
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

}
