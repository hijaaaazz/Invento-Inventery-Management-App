import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/purchase/purchase_functions.dart';
import 'package:invento2/database/inventory/purchase/purchase_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class ScreenPurchases extends StatefulWidget {
  @override
  _ScreenPurchasesState createState() => _ScreenPurchasesState();
}

class _ScreenPurchasesState extends State<ScreenPurchases> {
  // Controller for the search input field
  final TextEditingController _searchController = TextEditingController();
  // List of all purchases
  // Filtered purchases list based on search query
  List<PurchaseModel> filteredPurchases = [];

  @override
  void initState() {
    super.initState();
    // Initially set filtered purchases to all purchases
    filteredPurchases = purchasesList.value;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Method to filter purchases by invoice number
  void _filterPurchases(String query) {
    final filtered = purchasesList.value.where((purchase) {
      return purchase.purchaseNumber.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredPurchases = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.BackgroundWhite,
      appBar:appBarHelper("Purchase History"),
      body: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            child: TextField(
                controller: _searchController,
                onChanged: _filterPurchases,
                decoration: InputDecoration(
                  hintText: "Search by invoice number...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
          ),
          Expanded(
              child: ValueListenableBuilder<List<PurchaseModel>>(
              valueListenable: purchasesList,
              builder: (context, purchases, child) {
                if (filteredPurchases.isEmpty) {
                  return Center(child: Text("No purchases found"));
                }
            
                return ListView.builder(
                  itemCount: filteredPurchases.length,
                  itemBuilder: (context, index) {
                    final purchase = filteredPurchases[index];
                    final totalRate = purchase.GrandTotal;
            
                    return PurchaseItemWidget(
                      purchase: purchase,
                      totalRate: totalRate,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PurchaseItemWidget extends StatelessWidget {
  final PurchaseModel purchase;
  final double totalRate;

  const PurchaseItemWidget({
    Key? key,
    required this.purchase,
    required this.totalRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text("Invoice: ${purchase.purchaseNumber}"),
        subtitle: Text("Total Rate: \$${totalRate.toStringAsFixed(2)}"),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            _navigateToPurchaseDetails(context, purchase);
          },
        ),
      ),
    );
  }

  void _navigateToPurchaseDetails(BuildContext context, PurchaseModel purchase) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseDetailsScreen(purchase: purchase),
      ),
    );
  }
}

class PurchaseDetailsScreen extends StatelessWidget {
  final PurchaseModel purchase;

  const PurchaseDetailsScreen({Key? key, required this.purchase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchase Details: ${purchase.purchaseNumber}"),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQueryInfo.screenHeight*0.8,
            child: ListView(
              padding: EdgeInsets.all(8),
              children: [
                Text("Invoice Number: ${purchase.purchaseNumber}"),
                SizedBox(height: 16),
                Text("Purchased Products:"),
                ...purchase.purchaseProducts.map((product) {
                  return ListTile(
                    title: Text("${product.product.name}"),
                    subtitle: Text("Quantity: ${product.quantity}"),
                    trailing: Text("\$${(product.product.rate * product.quantity).toStringAsFixed(2)}"),
                  );
                }).toList(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          
            Text("Total"),
            Text(purchase.getTotalPurchasePrice().toString())
          ],),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          
            Text("Discount"),
            Text((purchase.getTotalPurchasePrice()-purchase.GrandTotal).toString() )
          ],),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text("Grand Total"),
              Text(purchase.GrandTotal .toString()),
            ],
          )
        ],
      ),
    );
  }
}
