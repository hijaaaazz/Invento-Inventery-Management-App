import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:invento2/database/users/user_fuctions.dart';

class ScreenAddOrder extends StatefulWidget {
  final dynamic userData;
  const ScreenAddOrder({Key? key, required this.userData}) : super(key: key);

  @override
  State<ScreenAddOrder> createState() => _ScreenAddOrderState();
}

class _ScreenAddOrderState extends State<ScreenAddOrder> {
  late String name;

  @override
  void initState() {
    super.initState(); 
    name = widget.userData.username; // Initialize name with userData
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Add order for $name")), // Use name here
    );
  }
}
