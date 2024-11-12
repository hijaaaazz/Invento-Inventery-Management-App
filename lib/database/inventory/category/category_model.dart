import 'package:hive_flutter/hive_flutter.dart';

part 'category_model.g.dart';  // Necessary for Hive to generate the adapter.

@HiveType(typeId: 2)
class CategoryModel {
  @HiveField(0)
  final String? id;  

  @HiveField(1)
  final String? name;  

  @HiveField(2)
  final String? userId;  // Make this field nullable

  // Constructor
  CategoryModel({this.id,this.name, this.userId});
}
