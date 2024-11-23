
  import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';

Widget buildDashboardContainer(BuildContext context,
      {required String title,
      required List<Color> gradientColors,
      required Widget screen,
      required String description,
      }) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> screen));
      },
      child: Container(
        height: MediaQueryInfo.screenHeight * 0.15,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child:
            
            Align(
              alignment: Alignment.topLeft,
              
              child: Container(
             
                padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(description,style:GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),),
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ),
        ),
      );

  }
  
