
import 'package:hive/hive.dart';
import 'package:invento2/database/inventory/product/product_model.dart';

part 'purchase_model.g.dart';

@HiveType(typeId: 4)
class PurchaseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String purchaseNumber;

  @HiveField(2)
  final List<PurchaseProduct> purchaseProducts;

  @HiveField(3)
  final String userId;

  @HiveField(4)
  final double grandTotal ;

  @HiveField(5)
  final String? supplierName ;

  @HiveField(6)
  final int? supplierPhone ;

  PurchaseModel({
    required this.id,
    required this.purchaseNumber,
    required this.purchaseProducts,
    required this.userId,
    required this.grandTotal,
    this.supplierName,
    this.supplierPhone
  });

  double getTotalPurchasePrice() {
    double total = 0;
    for (var item in purchaseProducts) {
      total += item.getTotalPrice();
    }
    return total;
  }
}

@HiveType(typeId: 5)
class PurchaseProduct extends HiveObject {
  
  @HiveField(0)
  final ProductModel product;

  @HiveField(1)
  final double quantity;

  PurchaseProduct({
    required this.product,
    required this.quantity,
  });

  double getTotalPrice() {
    return product.rate * quantity;
  }
}
