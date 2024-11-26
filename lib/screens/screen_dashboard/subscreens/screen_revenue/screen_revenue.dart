import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; 
import 'package:invento2/database/inventory/sales/sales_functions.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class ScreenRevenue extends StatefulWidget {
  const ScreenRevenue({Key? key}) : super(key: key);

  @override
  State<ScreenRevenue> createState() => _ScreenRevenueState();
}
class _ScreenRevenueState extends State<ScreenRevenue>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double totalRevenue = 0;
  double previousRevenue = 0;
  bool isGain = true; // For arrow direction and color
  DateTimeRange? customRange; // For custom range selection

 @override
void initState() {
  super.initState();
  _tabController = TabController(length: 4, vsync: this); // 4 tabs now
  _tabController.addListener(_updateRevenue);
  _updateRevenue(); // Initialize revenue for the first tab
}


  @override
  void dispose() {
    _tabController.removeListener(_updateRevenue);
    _tabController.dispose();
    super.dispose();
  }

  void _updateRevenue() {
  setState(() {
    final now = DateTime.now();
    totalRevenue = 0;
    previousRevenue = 0;

    // For custom range
    if (_tabController.index == 3) {
      if (customRange != null) {
        totalRevenue = salesList.value.fold(0, (a, b) {
          final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(b.id));
          return (date.isAfter(customRange!.start) && date.isBefore(customRange!.end))
              ? a + b.grandTotal
              : a;
        });
      }
    } else {
      // Logic for predefined tabs (Daily, Monthly, Annually)
      salesList.value.forEach((b) {
        if (b.userId != userDataNotifier.value.id) return;

        final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(b.id));
        if (_tabController.index == 0) {
          // Daily
          if (date.day == now.day && date.month == now.month && date.year == now.year) {
            totalRevenue += b.grandTotal;
          } else if (date.day == now.day - 1 && date.month == now.month && date.year == now.year) {
            previousRevenue += b.grandTotal;
          }
        } else if (_tabController.index == 1) {
          // Monthly
          if (date.month == now.month && date.year == now.year) {
            totalRevenue += b.grandTotal;
          } else if (date.month == now.month - 1 && date.year == now.year) {
            previousRevenue += b.grandTotal;
          }
        } else if (_tabController.index == 2) {
          if (date.year == now.year) {
            totalRevenue += b.grandTotal;
          } else if (date.year == now.year - 1) {
            previousRevenue += b.grandTotal;
          }
        }
      });
    }

    isGain = totalRevenue >= previousRevenue;
  });
}

void _showRangeOptions() async {
  final selectedOption = await showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
        decoration: BoxDecoration(
          color: AppStyle.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))
        ),
        child: Column(
          
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title:  Text("Update Range",
              style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),),
              onTap: () {
                Navigator.pop(context, "update");
              },
            ),
            Divider(),
            ListTile(
              title:  Text("Clear Range",
              style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),),
              onTap: () {
                Navigator.pop(context, "clear");
              },
            ),
          ],
        ),
      );
    },
  );

  if (selectedOption == "update") {
    // Trigger the date range picker to update the range
    _showCustomRangePicker();
  } else if (selectedOption == "clear") {
    // Clear the custom range
    setState(() {
      customRange = null;
    });
    _updateRevenue(); // Recalculate revenue after clearing the range
  }
}

// Method to show date range picker
void _showCustomRangePicker() async {
  final pickedRange = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    initialDateRange: customRange, // Use the existing custom range if available
  );

  if (pickedRange != null) {
    setState(() {
      customRange = pickedRange; // Update the custom range
    });
    _updateRevenue(); // Recalculate revenue after setting the range
  }
}





  @override
  Widget build(BuildContext context) {
    final percentageChange = previousRevenue == 0
        ? 0
        : ((totalRevenue - previousRevenue) / previousRevenue * 100);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppStyle.backgroundWhite,
        appBar: appBarHelper("Revenue"),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                height: MediaQueryInfo.screenHeight * 0.05,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          textScaler: const TextScaler.linear(0.9),
                          unselectedLabelStyle: GoogleFonts.inter(
                            fontSize: 12,
                          ),
                          labelStyle: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          labelColor: AppStyle.textWhite,
                          indicatorPadding: EdgeInsets.zero,
                          labelPadding: const EdgeInsets.symmetric(vertical: 5),
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          unselectedLabelColor: AppStyle.backgroundPurple,
                          splashBorderRadius: BorderRadius.circular(30),
                          indicator: BoxDecoration(
                            color: AppStyle.backgroundPurple,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          tabs: const [
                            Tab(child: Text('Daily')),
                            Tab(child: Text('Monthly')),
                            Tab(child: Text('Annually')),
                            Tab(child: Text('Custom')),
                          ],

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
         Visibility(
           visible: _tabController.index == 3, // Show this only when the index is 3 (Custom)
           child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
             padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
             decoration: BoxDecoration(
               color: AppStyle.backgroundGrey,
               borderRadius: BorderRadius.circular(30)
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("Custom Range",
                     style:  GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                     ),
                     Text(
                       customRange == null
                           ? "Select Range"
                           : "${DateFormat('yyyy-MM-dd').format(customRange!.start)} - ${DateFormat('yyyy-MM-dd').format(customRange!.end)}",
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                       style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                     ),
                   ],
                 ),
                 IconButton(
                   
                   icon: const Icon(Icons.more_vert),
                   onPressed: () {
                     _showRangeOptions();
                   },
                 ),
               ],
             ),
           ),
         ),




            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppStyle.backgroundPurple,
              ),
              height: MediaQueryInfo.screenHeight * 0.15,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Revenue :",
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppStyle.textWhite,
                            ),
                          ),
                          Visibility(
                            visible: _tabController.index != 3,
                            child: Row(
                              children: [
                                Icon(
                                  isGain ? Icons.arrow_upward : Icons.arrow_downward,
                                  color: isGain ? AppStyle.textGreen : Colors.red,
                                  size: 20,
                                ),
                                Text(
                                  "${percentageChange.toStringAsFixed(1)}%",
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppStyle.textWhite,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            "₹ ${totalRevenue.toStringAsFixed(2)}",
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
            ),
          ],
        ),
      ),
    );
  }
}
