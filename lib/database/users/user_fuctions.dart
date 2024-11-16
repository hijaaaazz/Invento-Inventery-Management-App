import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
    profileImage: "assets/images/box.jpg"
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
  required String image,
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
