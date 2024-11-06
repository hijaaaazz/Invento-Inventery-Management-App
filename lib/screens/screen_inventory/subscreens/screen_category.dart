import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/product/product_model.dart';

class ScreenProductList extends StatelessWidget {
  final String title;
  final List<Product> userProducts;

  const ScreenProductList({
    Key? key,
    required this.title,
    required this.userProducts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: userProducts.length,
        itemBuilder: (context, index) {
          final product = userProducts[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Price: ${product.price}'),
          );
        },
      ),
    );
  }
}
