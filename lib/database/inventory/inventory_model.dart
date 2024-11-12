import 'package:hive_flutter/hive_flutter.dart';
import 'package:invento2/database/inventory/category/category_model.dart';
import 'package:invento2/database/inventory/product/product_model.dart';

part 'inventory_model.g.dart';

@HiveType(typeId: 1)
class InventoryModel {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final List<CategoryModel>? categories;

  @HiveField(2)
  final List<ProductModel>? products;

  InventoryModel({
    required this.userId,
    this.categories,
    this.products,
  });
}
