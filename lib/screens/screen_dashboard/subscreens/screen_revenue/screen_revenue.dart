import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:invento2/database/inventory/sales/sales_functions.dart';
import 'package:invento2/database/inventory/sales/sales_model.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_revenue/widget/pie_chart.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_revenue/widget/range_bottom_sheet.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_revenue/widget/revenue_line_chart.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_revenue/widget/tab_bar.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_revenue/widget/total_revenue_card.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_revenue/widget/total_sales_card.dart';
import 'package:invento2/screens/widgets/app_bar.dart';
import 'package:pinch_to_zoom_scrollable/pinch_to_zoom_scrollable.dart';

class ScreenRevenue extends StatefulWidget {
  const ScreenRevenue({super.key});

  @override
  State<ScreenRevenue> createState() => _ScreenRevenueState();
}



class _ScreenRevenueState extends State<ScreenRevenue>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double totalRevenue = 0;
  double previousRevenue = 0;
  bool isGain = true;
  DateTimeRange? customRange;
  List<SalesModel> totalSales = [];
  List allproducts = [];
  Map<String, double> productData = {};
  List<MapEntry<String, double>> finalEntries =[];

  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(updateRevenue);
    updateRevenue();
  }

  @override
  void dispose() {
    _tabController.removeListener(updateRevenue);
    _tabController.dispose();
    super.dispose();
  }

  void updateRevenue() {
    setState(() {
      final now = DateTime.now();
      totalRevenue = 0;
      previousRevenue = 0;
      totalSales = [];
      allproducts = [];
      productData.clear(); 

      if (_tabController.index == 3) {
        if (customRange != null) {
          _filterSalesByCustomRange(now);
        }
      } else {
        _filterSalesByPredefinedPeriod(now);
      }

      _updateProductData(); 
    });
  }


void _filterSalesByCustomRange(DateTime now) {
  totalSales = salesList.value.where((b) {
    final saleDate = DateTime.fromMicrosecondsSinceEpoch(int.parse(b.id));
    
    return b.userId == userDataNotifier.value.id && 
           (saleDate.isAtSameMomentAs(customRange!.start) || saleDate.isAfter(customRange!.start)) &&
           (saleDate.isAtSameMomentAs(customRange!.end) || saleDate.isBefore(customRange!.end));
  }).toList();

  totalRevenue = totalSales.fold(0, (a, b) => a + b.grandTotal);
  allproducts = extractSaleProducts(totalSales);
}

void _filterSalesByPredefinedPeriod(DateTime now) {
  totalSales = salesList.value.where((b) {
    if (b.userId != userDataNotifier.value.id) return false;

    final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(b.id));
    return _matchesPeriod(date, now, _tabController.index);
  }).toList();

  totalRevenue = totalSales.fold(0, (a, b) => a + b.grandTotal);
  allproducts = extractSaleProducts(totalSales);

  previousRevenue = salesList.value
      .where((sale) {
        final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(sale.id));
        return sale.userId == userDataNotifier.value.id &&
               _matchesPreviousPeriod(date, now, _tabController.index);
      })
      .fold<double>(0, (total, sale) => total + sale.grandTotal);

  isGain = totalRevenue >= previousRevenue;
}


  bool _matchesPeriod(DateTime date, DateTime now, int tabIndex) {
    switch (tabIndex) {
      case 0: 
        return date.day == now.day && 
               date.month == now.month && 
               date.year == now.year;
      case 1: 
        return date.month == now.month && 
               date.year == now.year;
      case 2: 
        return date.year == now.year;
      default:
        return false;
    }
  }

  bool _matchesPreviousPeriod(DateTime date, DateTime now, int tabIndex) {
    switch (tabIndex) {
      case 0: 
        return date.day == now.day - 1 && 
               date.month == now.month && 
               date.year == now.year;
      case 1: 
        return date.month == now.month - 1 && 
               date.year == now.year;
      case 2: 
        return date.year == now.year - 1;
      default:
        return false;
    }
  }

  List<SaleProduct> extractSaleProducts(List<SalesModel> sales) {
    return sales
        .expand((sale) => sale.saleProducts)
        .toList();
  }

  void _updateProductData() {
    productData.clear();

    for (var item in allproducts) {
      final productName = item.product.name;
      final quantity = item.quantity;

      productData[productName] = (productData[productName] ?? 0) + quantity;
    }
  }

void showCustomRangePicker() async {
  final pickedRange = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    initialDateRange: customRange,
  );

  if (pickedRange != null) {
    setState(() {
      customRange = pickedRange;
    });
    updateRevenue(); 
  }
}

void updateFldots(){
  
}



updateRange(){
  setState(() {
    customRange==null;
    updateRevenue();
  });
}


@override
  Widget build(BuildContext context) {
    final percentageChange = previousRevenue == 0
        ? 0
        : ((totalRevenue - previousRevenue) / previousRevenue * 100);
        
        List<PieChartSectionData> pieChartSections;



if (productData.isNotEmpty) {

  final sortedEntries = productData.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  // Determine top 4 products and sum of others
  
  if (sortedEntries.length > 4) {
    final topFour = sortedEntries.take(4).toList();
    final othersSum = sortedEntries.skip(4)
        .fold(0.0, (sum, entry) => sum + entry.value);
    
    topFour.add(MapEntry('Others', othersSum));
    finalEntries = topFour;
  } else {
    finalEntries = sortedEntries;
  }
  pieChartSections = finalEntries.map((entry) {
    final index = finalEntries.indexOf(entry);
    return PieChartSectionData(
      color: AppStyle.purpleShades[index],
      value: entry.value,
      showTitle: false,
      title: '${entry.key}: ${entry.value.toStringAsFixed(0)}',
      radius: 20, 
      titlePositionPercentageOffset: 1.5, // Adjust title position
      titleStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }).toList();
} else {
  pieChartSections = [
    PieChartSectionData(
      color: AppStyle.backgroundWhite,
      value: 100,
      title: 'Empty',
      radius: 20,
      showTitle: false,
      titleStyle: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppStyle.textBlack,
      ),
    )
  ];
}
return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppStyle.backgroundWhite,
        appBar: appBarHelper("Revenue"),
        body: 
        salesList.value.where((sale)=>sale.userId==userDataNotifier.value.id).isEmpty?
        Center(
          child: Text("No Sales Recorded Yet",style:TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
        ):
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: AppStyle.backgroundGrey,
                            borderRadius: BorderRadius.circular(30),
                          ),
                           child: buildTabBar(_tabController),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
           Visibility(
             visible: _tabController.index == 3, // Show this only when the index is 3 (Custom)
             child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
               padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
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
                       showRangeOptions(context,showCustomRangePicker,updateRange);
                     },
                   ),
                 ],
               ),
             ),
           ),
           TotalRevenueCard(totalRevenue:  totalRevenue,tabController:  _tabController,percentageChange:  percentageChange,isGain:  isGain),
           buildTotalSales(totalSales),
           buildPieChart(pieChartSections,productData,finalEntries),
           if (_tabController.index != 3) 
            RevenueLineChart(tabIndex: _tabController.index)
            ],
          ),
        ),
      ),
    );
  }
}
