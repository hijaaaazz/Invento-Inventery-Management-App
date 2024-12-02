 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';


buildTabBar(dynamic tabController){
  return  TabBar(
                            controller: tabController,
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
          
                          );
}
