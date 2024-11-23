import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/sales/sales_functions.dart';
import 'package:invento2/database/inventory/sales/sales_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_add/subscreens/screen_add_sales/widgets/add_customer_dialog.dart';
import 'package:invento2/screens/screen_add/subscreens/screen_add_sales/widgets/screen_add_sales_item.dart';
import 'package:invento2/screens/widgets/app_bar.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class ScreenAddSales extends StatefulWidget {
  const ScreenAddSales({super.key});

  @override
  State<ScreenAddSales> createState() => _ScreenAddSalesState();
}

class _ScreenAddSalesState extends State<ScreenAddSales> {
  TextEditingController discountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  int discountType = 0; // 0 for Percentage, 1 for Specific Amount
  double grandTotal = 0;
  bool isFinished = false;
   String? customerName;
  late int customerNumber;
  ValueNotifier<double> grandTotalNotifier = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.BackgroundWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            appBarHelper('Add Sale'),
            ValueListenableBuilder<List<SaleProduct>>(
                  valueListenable: salesAddedProductsList,
                  builder: (context, soldProducts, _) {
                    double totalAmount = soldProducts.fold(0.0, (sum, item) => sum + item.getTotalPrice());
                    double discount = double.tryParse(discountController.text) ?? 0.0;
                
                    double discountAmount = discountType == 0
                        ? totalAmount * (discount / 100)
                        : discount;
                
                    double newGrandTotal = totalAmount - discountAmount;
                    grandTotalNotifier.value = newGrandTotal;
                
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Column(
                          children: [
                          
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                  SizedBox(
                                    width: MediaQueryInfo.screenWidth*0.4,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Customer Details",overflow: TextOverflow.ellipsis,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: MediaQueryInfo.screenWidth*0.2,
                                              child: Text(customerName ?? "Add", 
                                              style: GoogleFonts.outfit(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                            ),
                                            IconButton(
                                              icon: Icon(customerName?.isEmpty ?? true ? Icons.add : Icons.edit),
                                              onPressed: () {
                                                // Show the dialog with appropriate action
                                                showAddCustomerDialog(context, (String name, int contact) {
                                                  setState(() {
                                                    customerName = name;
                                                    customerNumber = contact;
                                                  });
                                                  log('Contact: $contact');
                                                }, nameController: nameController, contactController: contactController);
                                              },
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                   SizedBox(
                                    width: MediaQueryInfo.screenWidth*0.4,
                                     child: Text(
                                       'Invoice Number: INV-$SalesinvoiceCounter',maxLines: 2,overflow: TextOverflow.ellipsis,
                                       style: const TextStyle(fontWeight: FontWeight.bold),
                                     ),
                                   ),
                                 ],
                               ),
                                Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text("Items",style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    color: AppStyle.TextBlack,
                                    fontSize: 18
                                   ),),
                                   IconButton(onPressed:(){
                                    Navigator.of(context).push(
                                     MaterialPageRoute(builder: (ctx) => const ScreenAddSalesItem()),
                                   );
                                   } , icon: const Icon(Icons.add,color: AppStyle.TextBlack,))
                                 ],
                               ),
                               const Divider(height: 0),
                              
                               SizedBox(
                                 height: MediaQuery.of(context).size.height * 0.535,
                                 child: 
                                 soldProducts.isEmpty?
                                       const Center(child: Text(
                                         "No Products Selected!!\nAdd Products",
                                        textAlign: TextAlign.center,))
                                     :
                                 ListView.builder(
                                   padding: EdgeInsets.zero,
                                   physics: const AlwaysScrollableScrollPhysics(),
                                   shrinkWrap: true,
                                   itemCount: soldProducts.length,
                                   itemBuilder: (context, index) {
                                     final purchaseProduct = soldProducts[index];
                                     if(soldProducts.isEmpty){
                                      return const Center(child: Text("NO Products Selected\nAdd Products"));
                                     }
                                     return Padding(
                                       padding: const EdgeInsets.symmetric(vertical: 8.0),
                                       child: Card(
                                         color: const Color.fromARGB(255, 249, 218, 255),
                                         child: Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Row(
                                             crossAxisAlignment: CrossAxisAlignment.center,
                                             children: [
                                               SizedBox(
                                                 height: 70,
                                                 width: 70,
                                                 child: ClipRRect(
                                                   borderRadius: BorderRadius.circular(8.0),
                                                   child: Image(
                                                     image: FileImage(File(purchaseProduct.product.productImage)),
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
                                                       purchaseProduct.product.name,
                                                       style: const TextStyle(fontWeight: FontWeight.bold),
                                                     ),
                                                     Text("${purchaseProduct.quantity} x ${purchaseProduct.product.rate}"),
                                                   ],
                                                 ),
                                               ),
                                               Text(
                                                 "\$${purchaseProduct.getTotalPrice().toStringAsFixed(2)}",
                                                 style: const TextStyle(fontWeight: FontWeight.bold),
                                               ),
                                               IconButton(
                                                 onPressed: () {
                                                   setState(() {
                                                     // Remove item from the list
                                                     salesAddedProductsList.value.removeAt(index);
                                                   });
                                                 },
                                                 icon: const Icon(Icons.close),
                                               ),
                                             ],
                                           ),
                                         ),
                                       ),
                                     );
                                   },
                                 ),
                               ),
                               const Divider(height: 0),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   const Text("Total"),
                                   ValueListenableBuilder<double>(
                                     valueListenable: grandTotalNotifier,
                                     builder: (context, grandTotal, _) {
                                       return Text("₹${soldProducts.fold(0.0, (sum, item) => sum + item.getTotalPrice()).toStringAsFixed(2)}");
                                     },
                                   ),
                                 ],
                               ),
                               const SizedBox(height: 10),
                               // Discount Input and Slider
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   const Text("Discount"),
                                   Row(
                                     children: [
                                       Radio<int>(
                                        activeColor: AppStyle.BackgroundPurple,
                                         value: 0,
                                         groupValue: discountType,
                                         onChanged: (value) {
                                           setState(() {
                                             discountType = value!;
                                             grandTotalNotifier.value = newGrandTotal;
                                           });
                                         },
                                       ),
                                       const Text("%"),
                                       Radio<int>(
                                        activeColor: AppStyle.BackgroundPurple,
                                         value: 1,
                                         groupValue: discountType,
                                         onChanged: (value) {
                                           setState(() {
                                             discountType = value!;
                                             grandTotalNotifier.value = newGrandTotal;
                                           });
                                         },
                                       ),
                                       const Text("₹"),
                                     ],
                                   ),
                                   SizedBox(
                                     width: 100,
                                     child: TextFormField(
                                       controller: discountController,
                                       textAlign: TextAlign.right,
                                       style: const TextStyle(fontSize: 15),
                                       keyboardType: TextInputType.number,
                                       decoration: const InputDecoration(
                                         border: InputBorder.none,
                                         hintText: '0.0',
                                       ),
                                       onChanged: (value) {
                                         setState(() {
                                           double updatedDiscount = double.tryParse(value) ?? 0.0;
                                           grandTotalNotifier.value = totalAmount - (discountType == 0
                                                   ? totalAmount * (updatedDiscount / 100)
                                                   : updatedDiscount);
                                         });
                                       },
                                     ),
                                   ),
                                 ],
                               ),
                               Center(
                                                 child: SwipeableButtonView(
                                                   buttonText: "${totalAmount-discountAmount}",
                                                   buttonWidget: const Icon(
                               Icons.arrow_forward_ios_rounded,
                               color: AppStyle.BackgroundPurple,
                                                   ),
                                                   activeColor: AppStyle.BackgroundPurple,
                                                   isFinished: isFinished,
                                                   onWaitingProcess: () {
                               Future.delayed(const Duration(microseconds: 200), () {
                                 setState(() {
                                   isFinished = true;
                                 });
                               });
                                                   },
                                                   onFinish: () async {
                               setState(() {
                                 isFinished = false;
                               });
                               await 
        
                               addSale(context, newGrandTotal,customerName,customerNumber);
                                                   },
                                                 ),
                                               ),
                                                  ],
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    
    );
  }

  Widget _buildProductImage(String imagePath) {
    return SizedBox(
      height: 50,
      width: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image(
          image: FileImage(File(imagePath)),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductInfo(SaleProduct purchaseProduct) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            purchaseProduct.product.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text("${purchaseProduct.quantity} x ₹${purchaseProduct.product.rate}"),
        ],
      ),
    );
  }

  Widget _buildProductTotal(SaleProduct purchaseProduct) {
    return Text(
      "₹${purchaseProduct.getTotalPrice().toStringAsFixed(2)}",
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRemoveButton(int index) {
    return IconButton(
      onPressed: () {
        setState(() {
          salesAddedProductsList.value.removeAt(index);
          salesAddedProductsList.notifyListeners();
        });
      },
      icon: const Icon(Icons.close),
    );
  }
}
