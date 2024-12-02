import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/purchase/purchase_functions.dart';
import 'package:invento2/database/inventory/sales/sales_functions.dart';
import 'package:invento2/database/users/user_model.dart';

ValueNotifier<UserModel> userDataNotifier = ValueNotifier(
  UserModel(id: '', name: '', email: '', phone: '', username: '', password: '',profileImage: '')
);

// ignore: constant_identifier_names
const USER_DB_NAME = 'user_db';

Box<UserModel>? userBox;

Future<void> initUserDB() async {
  try {
    userBox= await Hive.openBox<UserModel>(USER_DB_NAME);
  } catch (e) {
    log('Error initializing userDB: $e');
  }
}

Future<bool> addUser({
  required String id,
  required String name,
  required String email,
  required String phone,
  required String username,
  required String pass,
  
}) async {
  await initUserDB();

  if (await userExists(username)) {
    log("Username already exists: $username");
    return false;
  }

  final newUser = UserModel(
    id: id,
    name: name,
    email: email,
    phone: phone,
    username: username,
    password: pass,
  );

  try {
    await userBox!.put(id, newUser); 
    await getAllUser(); 
    log("User added: $name");
    return true;
  } catch (e) {
    log("Error adding user: $e");
    return false;
  }
}

Future<void> updateUser({
  required String id,
  required String name,
  required String email,
  required String phone,
   String? image,
}) async {
  await initUserDB();

  final user = userBox?.get(id); 
  if (user != null) {
    final updatedUser = UserModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      username: user.username, 
      password: user.password,
      profileImage: image, 
    );

    try {
      await userBox!.put(id, updatedUser);
      userDataNotifier.value = updatedUser; 
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      userDataNotifier.notifyListeners(); 
      var sessionBox = await Hive.openBox('sessionBox'); 
      await sessionBox.put('lastLoggedUser', updatedUser);

      

      log("User updated: ${updatedUser.name}");

    } catch (e) {
      log("Error updating user: $e");
    }
  } else {
    log("User with ID $id not found.");
  }
  }
   


Future<bool> userExists(String username) async {
  await initUserDB();
  final matchingUsers = userBox!.values.where((user) => user.username == username);
  return matchingUsers.isNotEmpty;
}

Future<void> getAllUser() async {
  await initUserDB();

  final allUsers = userBox!.values.toList();
  log("All users in box: ${allUsers.map((user) => user.name).toList()}");
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  userDataNotifier.notifyListeners();
}

Future<void> logOutUser(String id) async {
  await initUserDB();

  UserModel? user = userBox!.get(id);
  if (user != null) {
    log("User logged out: ${user.name}");
  } else {
    log("User with ID $id not found for logout.");
  }
}
Future<bool> deleteUser(String id) async {
  await initUserDB();

  final user = userBox?.get(id);
  if (user != null) {
    try {
      // Helper function to delete user-related data if the box is not empty
      Future<void> deleteUserRelatedData(Box box, String userId) async {
        if (box.isNotEmpty) { // Check if the box is not empty
          final keysToDelete = box.keys.where((key) {
            final item = box.get(key);
            return item != null && item == userId; // Update this condition if schema differs
          }).toList();

          for (var key in keysToDelete) {
            await box.delete(key);
          }
        }
      }

      if (salesBox != null) await deleteUserRelatedData(salesBox, id);
      if (categoryBox != null) await deleteUserRelatedData(categoryBox!, id);
      if (productBox != null) await deleteUserRelatedData(productBox!, id);
      if (purchaseBox != null) await deleteUserRelatedData(purchaseBox, id);

      

       var sessionBox = await Hive.openBox('sessionBox');
    await sessionBox.delete('lastLoggedUser');
      await userBox!.delete(id);

      await getAllUser(); 

      log("User and associated data deleted: ${user.name}");
      return true;
    } catch (e) {
      log("Error deleting user and associated data: $e");
      return false;
    }
  } else {
    log("User with ID $id not found.");
    return false;
  }
}
