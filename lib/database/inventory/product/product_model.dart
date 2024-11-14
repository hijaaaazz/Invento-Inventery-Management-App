import 'package:hive_flutter/hive_flutter.dart';

part 'product_model.g.dart';

@HiveType(typeId: 3)
class ProductModel extends HiveObject {
  @HiveField(0)
  late final String name;

  @HiveField(1)
  final String category;

  @HiveField(2)
  late final String description;

  @HiveField(3)
  final String unit;

  @HiveField(4)
  final double price;

  @HiveField(5)
  late final double minlimit;

  @HiveField(6)
  late final double maxlimit;

  @HiveField(7)
  final double stock;

  @HiveField(8)
  final String userId;

  @HiveField(9)
  final String productId;

  @HiveField(10)
  final String productImage;

  @HiveField(11)
  final double rate;

  ProductModel({
    required this.productId,
    required this.name,
    required this.category,
    required this.description,
    required this.unit,
    required this.price,
    required this.minlimit,
    required this.maxlimit,
    required this.rate,
    this.stock = 0,
    required this.userId,
    required this.productImage
  });


  ProductModel copyWith({
    String? userId,
    String? productId,
    String? name,
    String? category,
    String? description,
    String? unit,
    double? price,
    double? minlimit,
    double? maxlimit,
    double? rate,
    String? productImage,
    double? stock,
  }) {
    return ProductModel(
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      minlimit: minlimit ?? this.minlimit,
      maxlimit: maxlimit ?? this.maxlimit,
      rate: rate ?? this.rate,
      productImage: productImage ?? this.productImage,
      stock: stock ?? this.stock,
    );
  }
}
