import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/product/product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category: ${product.category}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Description: ${product.description}"),
            const SizedBox(height: 10),
            Text("Unit: ${product.unit}"),
            const SizedBox(height: 10),
            Text("Rate: ${product.rate.toStringAsFixed(2)}"),
            const SizedBox(height: 10),
            Text("Price: ${product.price.toStringAsFixed(2)}"),
            const SizedBox(height: 10),
            Text("Min Limit: ${product.minlimit}"),
            const SizedBox(height: 10),
            Text("Max Limit: ${product.maxlimit}"),
            const SizedBox(height: 10),
            Text("Stock: ${product.stock}"),
            const SizedBox(height: 10),
            Text("User ID: ${product.userId}"),
          ],
        ),
      ),
    );
  }
}
