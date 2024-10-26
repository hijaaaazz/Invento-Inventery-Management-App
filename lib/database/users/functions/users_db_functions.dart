import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:invento2/database/users/models/models_user.dart';

void addUser({
  required String name,
  required String email,
  required String phone,
  required String username,
  required String password,
  required String id,
}) async {
  final userDB = await Hive.openBox<User>("user_db");
  final newUser = User(
    name: name,
    email: email,
    phone: phone,
    username: username,
    password: password,
    id: id,
  );
  await userDB.put(id, newUser);
  log('User Added: ${newUser.username}');
}

void printAllUsers() async {
  final userDB = await Hive.openBox<User>("user_db");
  
  if (userDB.isNotEmpty) {
    // Loop through all the user entries
    userDB.toMap().forEach((key, user) {
      log("User ID: $key");
      log("Name: ${user.name}");
      log("Email: ${user.email}");
      log("Phone: ${user.phone}");
      log("Username: ${user.username}");
      log("Password: ${user.password}");
    });
  } else {
    log('No users found in the database.');
  }
}
