import 'package:hive/hive.dart';
import 'package:invento2/database/inventory/product/product_model.dart';

part 'sales_model.g.dart';

@HiveType(typeId: 6)
class SalesModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String saleNumber;

  @HiveField(2)
  final List<SaleProduct> saleProducts;

  @HiveField(3)
  final String? customerName; 
  
  @HiveField(4)
  final double grandTotal;

   @HiveField(5)
  final int? customerNumber; 

  SalesModel({
    required this.id,
    required this.saleNumber,
    required this.saleProducts,
    this.customerName, 
    this.customerNumber,
    required this.grandTotal,
  });

  double getTotalSalePrice() {
    double total = 0;
    for (var item in saleProducts) {
      total += item.getTotalPrice();
    }
    return total;
  }
}

@HiveType(typeId: 7)
class SaleProduct extends HiveObject {
  
  @HiveField(0)
  final ProductModel product;

  @HiveField(1)
  final double quantity;

  SaleProduct({
    required this.product,
    required this.quantity,
  });

  double getTotalPrice() {
    return product.price * quantity;
  }
}
