import 'package:hive_flutter/hive_flutter.dart';

part 'product_model.g.dart';

@HiveType(typeId: 3)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String unit;

  @HiveField(4)
  final double rate;

  @HiveField(5)
  final double price;

  @HiveField(6)
  final double minlimit;

  @HiveField(7)
  final double maxlimit;

  @HiveField(8)
  final double stock;

  @HiveField(9)
  final String userId;

  @HiveField(10)
  final String productId;

  @HiveField(11)
  final String productImage;

  ProductModel({
    required this.productId,
    required this.name,
    required this.category,
    required this.description,
    required this.unit,
    required this.rate,
    required this.price,
    required this.minlimit,
    required this.maxlimit,
    this.stock = 0,
    required this.userId,
    required this.productImage
  });
}
