import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invento2/database/users/user_model.dart';

// ValueNotifier to manage the current user data for UI updates
ValueNotifier<UserModel> userDataNotifier = ValueNotifier(
  UserModel(id: '', name: '', email: '', phone: '', username: '', password: '')
);

const USER_DB_NAME = 'user_db';

// Hive Box for storing UserModel objects
Box<UserModel>? userBox;

// Initialize the Hive database
Future<void> initUserDB() async {
  try {
    if (userBox == null) {
      userBox = await Hive.openBox<UserModel>(USER_DB_NAME);
    }
  } catch (e) {
    log('Error initializing userDB: $e');
  }
}

// Function to add a new user to the Hive database
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
    await userBox!.put(id, newUser); // Save the new user to Hive
    await getAllUser(); // Refresh the user list
    log("User added: $name");
    return true;
  } catch (e) {
    log("Error adding user: $e");
    return false;
  }
}

// Function to update an existing user in the Hive database
Future<void> updateUser({
  required String id,
  required String name,
  required String email,
  required String phone,
}) async {
  await initUserDB();

  final user = userBox?.get(id);
  if (user != null) {
    final updatedUser = UserModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      username: user.username, // Keep the existing username
      password: user.password, // Keep the existing password
    );

    try {
      await userBox!.put(id, updatedUser); // Save the updated user to Hive

  
        userDataNotifier.value = updatedUser;
        userDataNotifier.notifyListeners();
      

      log("User updated: ${updatedUser.name}");

      // Log the updated user from Hive to verify
      final retrievedUser = userBox!.get(id);
      log("Retrieved User After Update: ${retrievedUser?.name}");
    } catch (e) {
      log("Error updating user: $e");
    }
  } else {
    log("User with ID $id not found.");
  }
}

// Function to check if a user with the given username already exists
Future<bool> userExists(String username) async {
  await initUserDB();
  final matchingUsers = userBox!.values.where((user) => user.username == username);
  return matchingUsers.isNotEmpty;
}

// Function to get all users from the Hive database
Future<void> getAllUser() async {
  await initUserDB();

  // Retrieve all users and log them for debugging
  final allUsers = userBox!.values.toList();
  log("All users in box: ${allUsers.map((user) => user.username).toList()}");

  // Notify listeners to update the UI
  userDataNotifier.notifyListeners();
}

// Function to handle user logout (you may want to adjust this logic)
Future<void> logOutUser(String id) async {
  await initUserDB();

  // Log out logic (currently, it only retrieves the user without modifying anything)
  UserModel? user = userBox!.get(id);
  if (user != null) {
    log("User logged out: ${user.name}");
  } else {
    log("User with ID $id not found for logout.");
  }
}
