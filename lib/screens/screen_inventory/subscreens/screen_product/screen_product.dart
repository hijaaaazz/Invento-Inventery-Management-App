import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_product/widgets/app_bar.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_product/widgets/edit_product_details.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_product/widgets/edit_stock_managment.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_product/widgets/product_delete_diallog.dart';
class ScreenProductDetails extends StatefulWidget {
  final ProductModel product;
  // ignore: non_constant_identifier_names
  final ValueNotifier<List<ProductModel>>? Gridviewnotifier;
  final VoidCallback? getMaxPrice;
   final VoidCallback? clearfilter;


  // ignore: non_constant_identifier_names
  const ScreenProductDetails({super.key, required this.product,this.Gridviewnotifier,this.getMaxPrice,this.clearfilter});

  @override
  State<ScreenProductDetails> createState() => _ScreenProductDetailsState();
}

class _ScreenProductDetailsState extends State<ScreenProductDetails> {
  late ValueNotifier<ProductModel> productDetailsNotifier;

  @override
  void initState() {
    super.initState();
    productDetailsNotifier = ValueNotifier(widget.product);
  }

  @override
  void dispose() {
    productDetailsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStyle appStyle = AppStyle();

    return Scaffold(
      backgroundColor: AppStyle.backgroundWhite,
      appBar: build_product_page_appbar(
          () => showProductDeleteDialog(context, productDetailsNotifier.value, widget.Gridviewnotifier)
,
          context,
          appStyle),
      body: ValueListenableBuilder(
          valueListenable: productDetailsNotifier,
          builder: (context, updatedProduct, _) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQueryInfo.screenHeight * 0.4,
                    child: Stack(
                      children: [
                        Positioned(
                          right: MediaQueryInfo.screenWidth * 0.2,
                          bottom: MediaQueryInfo.screenHeight * 0.05,
                          child: Container(
                            width: MediaQueryInfo.screenWidth * 0.5,
                            height: MediaQueryInfo.screenHeight * 0.03,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(0, 33, 149, 243),
                              borderRadius: BorderRadius.circular(1000),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.7),
                                  spreadRadius: 10,
                                  blurRadius: 30,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: ClipRRect(
                            child: Image(
                              image: FileImage(File(updatedProduct.productImage)),
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQueryInfo.screenHeight * 0.03),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                updatedProduct.name,
                                maxLines: 10,
                                overflow: TextOverflow.clip,
                                style: GoogleFonts.outfit(
                                    fontSize: 24, fontWeight: FontWeight.w500),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EditProduct(productNotifier: productDetailsNotifier,
                                  gridViewNotifier: widget.Gridviewnotifier,
                                  getMaxPrice: widget.getMaxPrice,
                                  clearfilter: widget.clearfilter,
                                      )));
                                  
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.black45,
                                  size: 18,
                                ))
                          ],
                        ),
                        Row(
                              children: [
                                const Text("Category : "),
                                Text(
                                  updatedProduct.category,
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                        
                        Text(updatedProduct.description,
                            style: GoogleFonts.lato(
                                fontSize: 16, fontWeight: FontWeight.w300)),
                        SizedBox(height: MediaQueryInfo.screenHeight * 0.02),
                        Container(
                          height: MediaQueryInfo.screenHeight * 0.045,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 226, 60, 255),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQueryInfo.screenWidth * 0.04),
                            child: Center(
                              child: Text(
                                "Current Stock : ${updatedProduct.stock} ${updatedProduct.unit}",
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppStyle.backgroundWhite,
                                ),overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                              " Price ₹ ${updatedProduct.price.toString()}",
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        SizedBox(height: MediaQueryInfo.screenHeight * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text("Rate : ₹"),
                                Text(
                                  updatedProduct.rate.toString(),
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "STOCK MANAGMENT",
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showEditStockManagementDialog(
                                    context, productDetailsNotifier,widget.Gridviewnotifier);
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: Colors.black45,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                        const Divider(height: 0),
                        SizedBox(height: MediaQueryInfo.screenHeight * 0.02),
                        Row(
                          children: [
                            const Text("Reorder Level"),
                            const SizedBox(width: 30),
                            Text(updatedProduct.minlimit.toInt().toString())
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Max Limit"),
                            const SizedBox(width: 59),
                            Text(updatedProduct.maxlimit.toInt().toString())
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

