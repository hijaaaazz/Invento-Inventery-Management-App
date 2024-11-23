import 'package:flutter/material.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_purchases.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_sales.dart';
import 'package:invento2/screens/screen_dashboard/widgets/dashboard_container.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class ScreenDashboard extends StatelessWidget {
  final dynamic userData;

  const ScreenDashboard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
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
                     screen: ScreenSales(),
                      description: "INCOME INSGHITS")),
                  SizedBox(width: 15,),
                  Expanded(child: 
                  buildDashboardContainer(context,
                   title: "Purchases",
                    gradientColors: [const Color.fromARGB(255, 22, 119, 0), const Color.fromARGB(255, 26, 255, 49)],
                     screen: ScreenPurchases(),
                      description: "SUPPLY SUMMARY")),
                ],
              ),
              SizedBox(height: 25,),
              buildDashboardContainer(context,
                   title: "Stock",
                    gradientColors: [const Color.fromARGB(255, 88, 0, 75), const Color.fromARGB(255, 255, 26, 244)],
                    screen: ScreenPurchases(),
                    description: "SUPPLY STATUS: LOW, FULL, ZERO"),
                    SizedBox(height: 25,),
              buildDashboardContainer(context,
                   title: "Revenue",
                    gradientColors: [const Color.fromARGB(255, 15, 0, 112), const Color.fromARGB(255, 45, 26, 255)],
                    screen: ScreenPurchases(),
                    description: "PROFIT TRACKER: MONITORING YOUR GAINS"),
            
            ]
          ),
        ),
      ),
    );
  }
}
