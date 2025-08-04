import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:invento2/database/inventory/sales/sales_functions.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/helpers/user_prefs.dart';
import 'package:pinch_to_zoom_scrollable/pinch_to_zoom_scrollable.dart';

class RevenueLineChart extends StatefulWidget {
  final int tabIndex;

  const RevenueLineChart({super.key, required this.tabIndex});

  @override
  // ignore: library_private_types_in_public_api
  _RevenueLineChartState createState() => _RevenueLineChartState();
}

class _RevenueLineChartState extends State<RevenueLineChart> {

  String currencySymbol="";
  @override
  void initState() {
    super.initState();
    _loadCurrencySymbol();
  }

  // Load the currency symbol asynchronously
  Future<void> _loadCurrencySymbol() async {
    String symbol = await AppPreferences.symbol;
    setState(() {
      currencySymbol = symbol;
    });
  }
      var isEmptyChecker=[];



  List<FlSpot> _generateLineChartSpots() {
    final List<FlSpot> spots = [];
    final now = DateTime.now();

    switch (widget.tabIndex) {
      case 0:
        for (int i = 4; i >= 0; i--) {
          final targetDate = now.subtract(Duration(days: i));
          final dailyRevenue = salesList.value
              .where((sale) {
                final saleDate = DateTime.fromMicrosecondsSinceEpoch(int.parse(sale.id));
                return saleDate.day == targetDate.day &&
                       saleDate.month == targetDate.month &&
                       saleDate.year == targetDate.year;
              })
              .fold(0.0, (sum, sale) => sum + sale.grandTotal);
          
          spots.add(FlSpot(4 - i.toDouble(), dailyRevenue));
        }
        break;

      case 1: 
        for (int i = 4; i >= 0; i--) {
          final targetDate = DateTime(now.year, now.month - i, 1);
          final monthlyRevenue = salesList.value
              .where((sale) {
                final saleDate = DateTime.fromMicrosecondsSinceEpoch(int.parse(sale.id));
                return saleDate.month == targetDate.month &&
                       saleDate.year == targetDate.year ;
              })
              .fold(0.0, (sum, sale) => sum + sale.grandTotal);
          
          spots.add(FlSpot(4 - i.toDouble(), monthlyRevenue));
        }
        break;

      case 2: 
        for (int i = 4; i >= 0; i--) {
          final targetYear = now.year - i;
          final yearlyRevenue = salesList.value
              .where((sale) {
                final saleDate = DateTime.fromMicrosecondsSinceEpoch(int.parse(sale.id));
                return saleDate.year == targetYear ;
              })
              .fold(0.0, (sum, sale) => sum + sale.grandTotal);
          
          spots.add(FlSpot(4 - i.toDouble(), yearlyRevenue));
        }
        break;

      default:
        spots.add(const FlSpot(0, 0));
    }
    isEmptyChecker = spots;
    return spots;
  }
double _calculateYInterval() {
  final spots = _generateLineChartSpots();
  if (spots.isEmpty) return 1.0;

  final minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
  final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
  return (maxY - minY) / 4;
}

  LineChartData _buildLineChartData() {
    
    return LineChartData(
      
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
       
  
        show: true,
        
        leftTitles: AxisTitles(
  sideTitles: SideTitles(
    reservedSize: 35,
    showTitles: true,
    interval: (_calculateYInterval()), 
    getTitlesWidget: (value, meta) {
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Text(
          NumberFormat.compactCurrency(symbol: currencySymbol,decimalDigits:0).format(value),
          textAlign: TextAlign.right,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color:  AppStyle.textBlack
          ),
        ),
      );
    },
  ),
),

        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),  
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),  
        ),
        bottomTitles: AxisTitles(
          drawBelowEverything: false,
          sideTitles: SideTitles(
            interval: 1,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              String title;
              final now = DateTime.now();
              
              switch (widget.tabIndex) {
                case 0: 
                  final targetDate = now.subtract(Duration(days: 4 - value.toInt()));
                  if (targetDate.day == now.day && targetDate.month == now.month && targetDate.year == now.year) {
                    title = "Today";
                  } else {
                    title = DateFormat('dd/MM').format(targetDate); // Otherwise, show date
                  }
                  break;
                case 1: // Monthly
                  final targetDate = DateTime(now.year, now.month - (4 - value.toInt()), 1);
                  title = DateFormat('MMM').format(targetDate); // Show month abbreviation
                  break;
                case 2: // Yearly
                  final targetYear = now.year - (4 - value.toInt());
                  title = targetYear.toString(); // Show year
                  break;
                default:
                  title = '';
              }
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: AppStyle.textBlack,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          barWidth: 3,
          spots: _generateLineChartSpots(),
          color: AppStyle.backgroundPurple, 
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppStyle.backgroundPurple.withOpacity(0.6),AppStyle.backgroundPurple.withOpacity(0.0),]),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        
      touchTooltipData: LineTouchTooltipData(
        showOnTopOfTheChartBoxArea: true,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((touchedSpot) {
            final spot = touchedSpot; // You can get data like x and y from the spot
            return LineTooltipItem(
              "$currencySymbol${spot.y}", // Display the X and Y values in the tooltip
              const TextStyle(color: Colors.white), // Tooltip text style
            );
          }).toList();
        },
      ),
      handleBuiltInTouches: true, // Enable built-in touch gestures
    ),
  
    );
  }

  @override
  Widget build(BuildContext context) {
    return PinchToZoomScrollableWidget(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: MediaQueryInfo.screenWidth,
        decoration: BoxDecoration(
          color: AppStyle.backgroundGrey,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            Text(
              "Sales Comparison ",
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppStyle.textBlack,
              ),
            ),
      
            const SizedBox(height:  30),
            
            SizedBox(
              height: MediaQueryInfo.screenHeight*0.3,
              width: MediaQueryInfo.screenWidth*0.8,
              child:
              LineChart(_buildLineChartData())
            )
          ],
        ),
      ),
    );
  }
}

