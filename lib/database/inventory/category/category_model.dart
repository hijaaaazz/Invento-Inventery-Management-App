import 'package:hive/hive.dart';

part 'category_model.g.dart';  // Necessary for Hive to generate the adapter.

@HiveType(typeId: 2)
class CategoryModel {
  @HiveField(0)
  final String? name;  // Make this field nullable

  @HiveField(1)
  final String? userId;  // Make this field nullable

  // Constructor
  CategoryModel({this.name, this.userId});
}
