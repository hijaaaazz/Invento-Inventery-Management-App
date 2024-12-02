import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/purchase/purchase_functions.dart';
import 'package:invento2/database/inventory/purchase/purchase_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/helpers/user_prefs.dart';
import 'package:invento2/screens/screen_add/subscreens/screen_add_purchses/widgets/add_item_dialog.dart';
import 'package:invento2/screens/screen_add/subscreens/screen_add_purchses/widgets/add_supplier_dialog.dart';
import 'package:invento2/screens/widgets/app_bar.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class ScreenAddPurchases extends StatefulWidget {
  const ScreenAddPurchases({super.key});

  @override
  State<ScreenAddPurchases> createState() => _ScreenAddPurchasesState();
}

class _ScreenAddPurchasesState extends State<ScreenAddPurchases> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
   String? supplierName;
  late int supplierPhone;
  TextEditingController discountController = TextEditingController();
  int discountType = 0;
  bool isFinished = false;
  String  _currencySymbol ="";

  ValueNotifier<double> grandTotalNotifier = ValueNotifier<double>(0.0);
@override
  void initState() {
    super.initState();
_loadCurrencySymbol();  // Load the currency symbol when the widget is initialized
  }

  // Asynchronous function to load the currency symbol
  _loadCurrencySymbol() async {
    String symbol = await AppPreferences.symbol; // Fetch symbol asynchronously
    setState(() {
      _currencySymbol = symbol;  // Update the state with the fetched symbol
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppStyle.backgroundWhite,
    
      body: SingleChildScrollView(
        child: Column(
          children: [
             appBarHelper('Add Purchase'),
            ValueListenableBuilder<List<PurchaseProduct>>(
              valueListenable: puchasesAddedProductsList,
              builder: (context, purchasedProducts, _) {
                double totalAmount = purchasedProducts.fold(0.0, (sum, item) => sum + item.getTotalPrice());
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
                                          const Text("Supplier Details",overflow: TextOverflow.ellipsis,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: MediaQueryInfo.screenWidth*0.2,
                                                child: Text(supplierName ?? "Add", 
                                                style: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis),
                                              ),
                                              IconButton(
                                                icon: Icon(supplierName?.isEmpty ?? true ? Icons.add : Icons.edit),
                                                onPressed: () {
                                                  // Show the dialog with appropriate action
                                                  showAddSupplierDialog(context, (String name, int contact) {
                                                    setState(() {
                                                      supplierName = name;
                                                      supplierPhone = contact;
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
                                         'Invoice Number: INV-$invoiceCounter',maxLines: 2,overflow: TextOverflow.ellipsis,
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
                                color: AppStyle.textBlack,
                                fontSize: 18
                               ),),
                               IconButton(onPressed:(){
                                Navigator.of(context).push(
                                 MaterialPageRoute(builder: (ctx) => const ScreenAddPurchaseItem()),
                               );
                               } , icon: Icon(Icons.add,color: AppStyle.textBlack,))
                             ],
                           ),
                           const Divider(height: 0),
                          
                           SizedBox(
                             height: MediaQuery.of(context).size.height * 0.535,
                             child: 
                             purchasedProducts.isEmpty?
                                   const Center(child: Text(
                                     "No Products Selected!!\nAdd Products",
                                    textAlign: TextAlign.center,))
                                 :
                             ListView.builder(
                               padding: EdgeInsets.zero,
                               physics: const AlwaysScrollableScrollPhysics(),
                               shrinkWrap: true,
                               itemCount: purchasedProducts.length,
                               itemBuilder: (context, index) {
                                 final purchaseProduct = purchasedProducts[index];
                                 if(purchasedProducts.isEmpty){
                                  return const Center(child: Text("NO Products Selected\nAdd Products"));
                                 }
                                 return Padding(
                                   padding: const EdgeInsets.symmetric(vertical: 8.0),
                                   child: Card(
                                     color: AppStyle.backgroundPurple,
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
                                                 puchasesAddedProductsList.value.removeAt(index);
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
                           const Divider(height: 5),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                                Text("Total",style: GoogleFonts.lato(color: AppStyle.textBlack),),
                               ValueListenableBuilder<double>(
                                 valueListenable: grandTotalNotifier,
                                 builder: (context, grandTotal, _) {
                                   return Text("$_currencySymbol ${purchasedProducts.fold(0.0, (sum, item) => sum + item.getTotalPrice()).toStringAsFixed(2)}",style: GoogleFonts.lato(color: AppStyle.textBlack));
                                 },
                               ),
                             ],
                           ),
                           const SizedBox(height: 10),
                           // Discount Input and Slider
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                                Text("Discount",style: GoogleFonts.lato(color: AppStyle.textBlack)),
                               Row(
                                 children: [
                                   Radio<int>(
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
                                     value: 1,
                                     groupValue: discountType,
                                     onChanged: (value) {
                                       setState(() {
                                         discountType = value!;
                                         grandTotalNotifier.value = newGrandTotal;
                                       });
                                     },
                                   ),
                                    Text(_currencySymbol),
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
                                              buttonColor: AppStyle.backgroundWhite,
                                               buttonText: "${totalAmount-discountAmount}",
                                               buttonWidget: Icon(
                           Icons.arrow_forward_ios_rounded,
                           color: AppStyle.backgroundPurple,
                                               ),
                                               activeColor: AppStyle.backgroundPurple,
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
                           await addPurchase(context, totalAmount,supplierName?? "",supplierPhone);
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
}
