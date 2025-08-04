import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/purchase/purchase_functions.dart';
import 'package:invento2/database/inventory/sales/sales_functions.dart';
import 'package:invento2/database/users/user_model.dart';

ValueNotifier<UserModel> userDataNotifier = ValueNotifier(
  UserModel(id: '', name: ''),
);

const USER_DB_NAME = 'user_db';
Box<UserModel>? userBox;

/// ✅ Initialize User Box
Future<void> initUserDB() async {
  try {
    if (!Hive.isBoxOpen(USER_DB_NAME)) {
      userBox = await Hive.openBox<UserModel>(USER_DB_NAME);
    } else {
      userBox = Hive.box<UserModel>(USER_DB_NAME);
    }
  } catch (e) {
    log('Error initializing userDB: $e');
    // Try to delete corrupted box and re-open
    await Hive.deleteBoxFromDisk(USER_DB_NAME);
    userBox = await Hive.openBox<UserModel>(USER_DB_NAME);
  }
}

/// ✅ Get Current User (Only One Allowed)
Future<UserModel?> getCurrentUser() async {
  await initUserDB();

  try {
    if (userBox != null && userBox!.isNotEmpty) {
      final user = userBox!.values.first;
      log("User fetched: ${user.name}");
      return user;
    } else {
      log("No user found.");
      return null;
    }
  } catch (e) {
    log("Error fetching current user: $e");
    return null;
  }
}

/// ✅ Add User (Overrides previous if exists)
Future<bool> addUser({
  required String id,
  required String name,
}) async {
  await initUserDB();

  final newUser = UserModel(id: id, name: name);

  try {
    // Clear any existing user and save new one
    await userBox!.clear();
    await userBox!.put(id, newUser);

    log("User added: $name");
    return true;
  } catch (e) {
    log("Error adding user: $e");
    return false;
  }
}

/// ✅ Delete User and Related Data
Future<bool> deleteUser(String id) async {
  await initUserDB();

  final user = userBox?.get(id);
  if (user != null) {
    try {
      Future<void> deleteUserRelatedData(Box box, String userId) async {
        if (box.isNotEmpty) {
          final keysToDelete = box.keys.where((key) {
            final item = box.get(key);
            return item != null && item == userId;
          }).toList();

          for (var key in keysToDelete) {
            await box.delete(key);
          }
        }
      }

      await deleteUserRelatedData(salesBox, id);
      if (categoryBox != null) await deleteUserRelatedData(categoryBox!, id);
      if (productBox != null) await deleteUserRelatedData(productBox!, id);
      await deleteUserRelatedData(purchaseBox, id);

      await userBox!.delete(id);

      log("User and related data deleted: ${user.name}");
      return true;
    } catch (e) {
      log("Error deleting user: $e");
      return false;
    }
  } else {
    log("User not found: $id");
    return false;
  }




  
}


/// ✅ Update Existing User (Only id and name)
Future<bool> updateUser({
  required String id,
  required String name,
}) async {
  await initUserDB();

  try {
    final existingUser = userBox?.get(id);
    if (existingUser == null) {
      log("User not found for update: $id");
      return false;
    }

    final updatedUser = UserModel(
      id: id,
      name: name,
  
    );

    await userBox!.put(id, updatedUser);
    userDataNotifier.value = updatedUser;

    log("User updated: ${updatedUser.name}");
    return true;
  } catch (e) {
    log("Error updating user: $e");
    return false;
  }
}
