import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_product/widgets/app_bar.dart';

class ScreenProductDetails extends StatelessWidget {
  final ProductModel product;

  const ScreenProductDetails({super.key, required this.product});
  addProduct(){}

  @override
  Widget build(BuildContext context) {
    AppStyle appStyle =AppStyle();
    return Scaffold(
      backgroundColor:appStyle.secondaryColor,
      appBar: build_product_page_appbar(context,appStyle),
      body: Column(
        children: [
          Stack(
            children: [
              Positioned(
                right: MediaQueryInfo.screenWidth *0.2,
                bottom: MediaQueryInfo.screenHeight*0.01,
                child: Container(
                          width: MediaQueryInfo.screenWidth*0.5,
                          height: MediaQueryInfo.screenHeight*0.03, 
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(0, 33, 149, 243), 
                            borderRadius: BorderRadius.circular(1000),
                            boxShadow: [
                              BoxShadow(
                color: Colors.black.withOpacity(0.7), 
                spreadRadius: 10,
                blurRadius: 30,
                offset: Offset(0, 4), 
                              ),
                            ],
                          ),
                        ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top:182),
                  child: Container(
                            width: MediaQueryInfo.screenWidth*0.22,
                            height: MediaQueryInfo.screenHeight*0.015, 
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(0, 33, 149, 243),
                              borderRadius: BorderRadius.circular(1000),
                              boxShadow: [
                                BoxShadow(
                  color: Colors.black.withOpacity(1), 
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 0), 
                                ),
                              ],
                            ),
                          ),
                ),
              ),
              Center(
                child: Padding(
                  padding:  EdgeInsets.only(top: 60),
                  child: CircleAvatar(
                      radius: 64, 
                      backgroundImage:FileImage(File(product.productImage)),
                      child: 
                           const Center(
                              child: Text(
                                '''Add\nImage''',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            )
                    ),
                ),
              ),
            ],
          ),
          SizedBox(height: 60,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.name),
                    Icon(Icons.edit_outlined)
                  ],
                ),
                Text(product.description),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      
                      height: MediaQueryInfo.screenHeight* 0.05,
                      
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: Text("Current Stock : ${product.stock}",style: TextStyle(
                            color: appStyle.secondaryColor
                          ),),
                        ),
                      ),
                    ),
                    Text(product.price.toString())
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Unit : ${product.unit}"),
                    Text("Rate : ₹${product.rate.toString()}")
                    ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text("STOCK MANAGMENT"),
                    Icon(Icons.edit_outlined)
                  ],
                ),
                Divider(
                  height: 0,
                ),
                Row(
                  children: [
                    Text("Reorder Level"),
                    SizedBox(width: 30,),
                    Text(product.minlimit.toInt().toString())
                  ],
                ),
                Row(
                  children: [
                    Text("Max Limit"),
                    SizedBox(width: 59,),
                    Text(product.maxlimit.toInt().toString())
                  ],
                ),
              ],
              
            ),
          )
        ],
      )
    );
  }
}
