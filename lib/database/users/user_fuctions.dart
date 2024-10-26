import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invento2/database/users/user_model.dart';

ValueNotifier<List<UserModel>> userListNotifier = ValueNotifier([]);
Box<UserModel>? userBox;

Future<void> initUserDB() async {
  if (userBox == null) {
    userBox = await Hive.openBox<UserModel>('user_db');
    log("user_db box opened");
  } else {
    log("user_db box is already open");
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

  try {
    final newUser = UserModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      username: username,
      password: pass,
   
    );

    await userBox!.put(id, newUser);
    await getAllUser(); // Update the user list notifier
    log("User added: $name");
    return true;
  } catch (e) {
    log("Error adding user: $e");
    return false;
  }
}

Future<bool> userExists(String username) async {
  await initUserDB();
  final existingUser = userBox!.values.firstWhere(
    (user) => user.username == username,
    orElse: () => UserModel(id: '', name: '', email: '', phone: '', username: '', password: ''),
  );
  return existingUser.username.isNotEmpty;
}

Future<void> getAllUser() async {
  await initUserDB();
  userListNotifier.value = userBox!.values.toList(); // Replace instead of clear and add
  userListNotifier.notifyListeners();
}

Future<void> deleteUser(String id) async {
  await initUserDB();
  await userBox!.delete(id);
  await getAllUser(); // Update the user list notifier
}

void printAllUsers() {
  for (var user in userListNotifier.value) {
    log('User: ${user.name}, Email: ${user.email}, Phone: ${user.phone}, Username: ${user.username}, Password: ${user.password}');
  }
}



// Optional: Method to log out the user
Future<void> logOutUser(String id) async {
  await initUserDB();
  UserModel? user = userBox!.get(id);
  if (user != null) {
    // Ensure you have this field in your UserModel
    await userBox!.put(id, user);
  }
}

