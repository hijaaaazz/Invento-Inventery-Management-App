import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

buildTotalSales(dynamic totalSales){
  return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppStyle.backgroundGrey,
              ),
              width: double.infinity,
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total Sales:",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppStyle.textBlack,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "${totalSales.length}",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.outfit(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppStyle.textPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
}