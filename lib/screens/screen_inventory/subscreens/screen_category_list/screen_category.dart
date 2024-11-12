import 'dart:io'; // Import for File
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_product/screen_product.dart';

class ScreenProductList extends StatelessWidget {
  final String title;
  final List<ProductModel> userProducts;

  const ScreenProductList({
    super.key,
    required this.title,
    required this.userProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of items per row
          crossAxisSpacing: 10, // Spacing between columns
          mainAxisSpacing: 10, // Spacing between rows
          childAspectRatio: 0.75, // Adjust this to control the aspect ratio of each item
        ),
        itemCount: userProducts.length,
        itemBuilder: (context, index) {
          final product = userProducts[index];
          return GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ScreenProductDetails(product: product,)));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.file(
                    File(product.productImage), 
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
              
                  const SizedBox(height: 8), // Space between image and text
                  Text(
                    product.name,
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, 
                  ),
                  const SizedBox(height: 4), // Space between name and price
                  Text(
                    'Price: ${product.price}',
                    style: GoogleFonts.inter(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
