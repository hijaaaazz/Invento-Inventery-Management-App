import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/helpers/user_prefs.dart';

class TotalRevenueCard extends StatefulWidget {
  final dynamic totalRevenue;
  final dynamic tabController;
  final dynamic percentageChange;
  final bool isGain;

  const TotalRevenueCard({
    super.key,
    required this.totalRevenue,
    required this.tabController,
    required this.percentageChange,
    required this.isGain,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TotalRevenueCardState createState() => _TotalRevenueCardState();
}

class _TotalRevenueCardState extends State<TotalRevenueCard> {
  String currencySymbol = "";

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

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    visible: widget.tabController.index != 3,
                    child: Row(
                      children: [
                        Icon(
                          widget.isGain ? Icons.arrow_upward : Icons.arrow_downward,
                          color: widget.isGain ? AppStyle.textGreen : Colors.red,
                          size: 20,
                        ),
                        Text(
                          "${widget.percentageChange.toStringAsFixed(1)}%",
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
                    "$currencySymbol ${widget.totalRevenue.toStringAsFixed(2)}",
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
    );
  }
}
