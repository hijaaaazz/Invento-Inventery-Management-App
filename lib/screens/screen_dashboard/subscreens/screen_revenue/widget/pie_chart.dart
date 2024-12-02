import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

buildPieChart(dynamic pieChartSections, dynamic productData,finalEntries){
  return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: MediaQueryInfo.screenHeight*0.32,
            decoration: BoxDecoration(
              color: AppStyle.backgroundGrey,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
          "Top Seller ",
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppStyle.textBlack,
          ),
                ),
                SizedBox(height: 10),
                Row(
          children: [
            Expanded(
              flex: 2,
              child: productData.isEmpty?
              Center(child: Text("No Sale",
               style: GoogleFonts.lacquer(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppStyle.textBlack,
          ),
              ),)
              :ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: finalEntries.length,
                itemBuilder: (context, index) {
                  final entry = finalEntries.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: AppStyle.purpleShades[index],
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 10),
                        // Product name and value
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${entry.value.toStringAsFixed(0)} units',
                                style: GoogleFonts.outfit(
                                  fontSize: 8,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            Expanded(
              flex: 3,
              child: Container(
                height: MediaQueryInfo.screenHeight * 0.2,
                child: PieChart(
                  PieChartData(
                    sections: pieChartSections,
                    centerSpaceRadius: 50,
                    sectionsSpace: 2,
                  ),
                ),
              ),
            ),
            
          ],
                ),
              ],
            ),
          );
}