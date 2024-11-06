import 'package:hive/hive.dart';
import 'package:invento2/database/inventory/inventory_model.dart'; // Ensure you have the correct import

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String username;

  @HiveField(5)
  final String password;

  @HiveField(6)
  final InventoryModel? inventories; // List of inventories for the user

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    this.inventories, // inventories is optional
  });
}
