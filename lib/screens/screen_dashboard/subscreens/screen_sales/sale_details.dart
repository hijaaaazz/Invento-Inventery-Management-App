import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:invento2/database/inventory/sales/sales_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/phone_maker.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class SalesDetails extends StatelessWidget {
  final SalesModel sale;
  final String currencySymbol;

  const SalesDetails({super.key, required this.sale,required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundWhite,
      appBar: appBarHelper("sale details"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Invoice Number ",
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),),
                  Text(sale.saleNumber,
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  )),
                  
                ],
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sales Time",
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),),
                  Text(
                    DateFormat('kk:mm , y-M-d' ).format(DateTime.fromMicrosecondsSinceEpoch(int.parse(sale.id) )),
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  
                ],
              ),
              const SizedBox(height: 10,),
              Text("Customer Details",
               style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w400
                  )),
              const SizedBox(
                height: 5,
              ),
              Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow()],
            color: const Color.fromARGB(255, 248, 208, 255)
          ),
          height: MediaQueryInfo.screenHeight*0.1,
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppStyle.backgroundWhite,
                  child: const Icon(Icons.person)),
                  const SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(Icons.person,size: 15,),
                        const SizedBox(width: 10,),
                        Text(sale.customerName?.isEmpty == true ? 'Unknown' : sale.customerName!
                        ,style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                                          ),),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(Icons.phone,size: 15,),
                        const SizedBox(width: 10,),
                        Text("${sale.customerNumber}",
                        style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                                          )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: (){
                makePhoneCall(sale.customerNumber.toString());
              },
              icon: const Icon(Icons.phone))
             
          ],
          ),
        ),
        const SizedBox(height: 10,),
        Text("Products Information",
        style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 0,
                      maxHeight: MediaQueryInfo.screenHeight*0.53
                    ),
                    decoration: const BoxDecoration(
                    
                    ),
                    child: ListView.builder(
                      itemCount: sale.saleProducts.length,
                      itemBuilder: (context, index) {
                        SaleProduct product = sale.saleProducts[index];
                        return Padding(
                                       padding: const EdgeInsets.symmetric(vertical: 8.0),
                                       child: Card(
                                         color: const Color.fromARGB(255, 245, 245, 245),
                                         child: Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Row(
                                             crossAxisAlignment: CrossAxisAlignment.center,
                                             children: [
                                               SizedBox(
                                                 height: 70,
                                                 width: 70,
                                                 child:  ClipRRect(
                                                  borderRadius: BorderRadius.circular(8.0), 
                                                  child: product.product.productImage.isNotEmpty
                                                      ? (kIsWeb
                                                          ? Image.memory(
                                                              base64Decode(product.product.productImage),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.file(
                                                              File(product.product.productImage),
                                                              fit: BoxFit.cover, 
                                                            ))
                                                      : Image.asset(
                                                          'assets/images/box.jpg',
                                                          fit: BoxFit.cover, 
                                                        ),
                                                ),

                                               ),
                                               const SizedBox(width: 10),
                                               Expanded(
                                                 child: Column(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Text(
                                                       product.product.name,
                                                       style: const TextStyle(fontWeight: FontWeight.bold),
                                                     ),
                                                     Text("${product.quantity} x ${product.product.rate}"),
                                                   ],
                                                 ),
                                               ),
                                               Text(
                                                 "$currencySymbol${product.getTotalPrice().toStringAsFixed(2)}",
                                                 style: const TextStyle(fontWeight: FontWeight.bold),
                                               ),
                                               
                                             ],
                                           ),
                                         ),
                                       ),
                                     );
                      } ,
                      
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total",
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                                          ),),
                      Text(sale.getTotalSalePrice().toString(),
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                                          ),)
                    ],

                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Discount",
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                                          ),),
                      Text((sale.getTotalSalePrice()-sale.grandTotal).toString(),
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                                          ),)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Grand Total",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                                          ),),
                      Text("$currencySymbol  ${sale.grandTotal.toString()}",
                      style:  GoogleFonts.outfit(
                        fontSize: 18,
                        color: AppStyle.textPurple,
                        fontWeight: FontWeight.bold
                                          ),)
                    ],
                  )
            ]
          ),
        ),
      ),
    );
  }
}
