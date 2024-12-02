
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/category/category_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:lottie/lottie.dart';

void longPressEmptyCategory(BuildContext context, CategoryModel category) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        
        child:SingleChildScrollView(
          child: Container(
           
            decoration: BoxDecoration(
              color:AppStyle.backgroundWhite,
              borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                children: [
              
                Text(
                    "Are You Sure",
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MediaQueryInfo.screenHeight*0.05,),
                  SizedBox(
                    height: MediaQueryInfo.screenHeight*0.2,
                    child: ClipRRect(
                      child: Lottie.asset("assets/gifs/delete.json")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Are you sure you want to delete this category? This action cannot be undone.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500
                    ),),
                    
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.of(ctx).pop();
                      }, child: 
                          Text(
                        "Cancel",
                        style: GoogleFonts.outfit(
                          color: Colors.black
                        ),
                      ),),
                      TextButton(
                      onPressed: () async {
                      deleteCategory(category.id, context,);
                      Navigator.of(context).pop();
                      },
                      child: Text(
                      "Delete",
                      style: GoogleFonts.outfit(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    )
                      ),
                    ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
        
      );
    },
  );
}