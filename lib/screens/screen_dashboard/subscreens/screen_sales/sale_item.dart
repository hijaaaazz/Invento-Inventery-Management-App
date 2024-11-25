
import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/sales/sales_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_sales/sale_details.dart';

class SaleItem extends StatelessWidget {
  final SalesModel sale;

  const SaleItem({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesDetails(sale: sale),
            ),
          );
        },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [AppStyle.lightShadow],
            color: AppStyle.backgroundWhite
          ),
          height: MediaQueryInfo.screenHeight*0.1,
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppStyle.backgroundWhite,
                  child: Icon(Icons.person)),
                  const SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sale.customerName?.isEmpty == true ? 'Unknown' : sale.customerName!),
                    Text("Invoice: ${sale.saleNumber}"),
                  ],
                ),
              ],
            ),
             SizedBox(
              width: MediaQueryInfo.screenWidth*0.3,
               child: Text("Total: \$${sale.grandTotal.toStringAsFixed(2)}",
               overflow: TextOverflow.ellipsis,
               textAlign: TextAlign.right,
               maxLines: 1,),
             ),
          ],
          ),
        ),
      ),
    );
  }
}
