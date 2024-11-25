
import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/purchase/purchase_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_purchases/screen_purchase_detail.dart';

class PurchaseItemWidget extends StatelessWidget {
  final PurchaseModel purchase;

  const PurchaseItemWidget({
    super.key,
    required this.purchase,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseDetailsScreen(purchase: purchase),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [AppStyle.lightShadow],
            color: AppStyle.backgroundWhite,
          ),
          height: MediaQueryInfo.screenHeight * 0.1,
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppStyle.backgroundWhite,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        purchase.supplierName?.isEmpty == true
                            ? 'Unknown'
                            : purchase.supplierName ?? 'Unknown',
                      ),
                      Text("Invoice: ${purchase.purchaseNumber}"),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: MediaQueryInfo.screenWidth * 0.3,
                child: Text(
                  "Total: \$${(purchase.grandTotal).toStringAsFixed(2)}",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
