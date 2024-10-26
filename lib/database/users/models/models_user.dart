import 'package:hive/hive.dart';

// This part directive is necessary for the Hive code generator to create the adapter
part 'models_user.g.dart'; // Ensure this matches the filename for the generated file

@HiveType(typeId: 0) // Unique identifier for the User type
class User {
  @HiveField(0)
  final String name; // User's name

  @HiveField(1)
  final String email; // User's email

  @HiveField(2)
  final String phone; // User's phone number

  @HiveField(3)
  final String username; // User's username

  @HiveField(4)
  final String password; // User's password

  @HiveField(5)
  final String id; // Unique identifier for the user

  // Constructor for the User class
  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.id,
  });
}


