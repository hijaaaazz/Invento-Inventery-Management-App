import 'package:flutter/material.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_purchases/screen_purchases.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_sales/screen_sales.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_stock/screen_stock.dart';
import 'package:invento2/screens/screen_dashboard/widgets/dashboard_container.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class ScreenDashboard extends StatelessWidget {
  final dynamic userData;

  const ScreenDashboard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      backgroundColor: AppStyle.backgroundWhite,
      appBar: appBarHelper("dashbord"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children:[
              Row(
                children: [
                  Expanded(child: 
                  buildDashboardContainer(context,
                   title: "Sales",
                    gradientColors: [const Color.fromARGB(255, 66, 0, 116), const Color.fromARGB(255, 131, 15, 255)],
                     screen: const ScreenSales(),
                      description: "INCOME INSGHITS")),
                  const SizedBox(width: 15,),
                  Expanded(child: 
                  buildDashboardContainer(context,
                   title: "Purchases",
                    gradientColors: [const Color.fromARGB(255, 22, 119, 0), const Color.fromARGB(255, 26, 255, 49)],
                     screen: const ScreenPurchases(),
                      description: "SUPPLY SUMMARY")),
                ],
              ),
              const SizedBox(height: 25,),
              buildDashboardContainer(context,
                   title: "Stock",
                    gradientColors: [const Color.fromARGB(255, 88, 0, 75), const Color.fromARGB(255, 255, 26, 244)],
                    screen: const ScreenStock(),
                    description: "SUPPLY STATUS: LOW, FULL, ZERO"),
                    const SizedBox(height: 25,),
              buildDashboardContainer(context,
                   title: "Revenue",
                    gradientColors: [const Color.fromARGB(255, 15, 0, 112), const Color.fromARGB(255, 45, 26, 255)],
                    screen: const ScreenPurchases(),
                    description: "PROFIT TRACKER: MONITORING YOUR GAINS"),
            
            ]
          ),
        ),
      ),
    );
  }
}
