import 'package:flutter/material.dart';

class ScreenInventory extends StatelessWidget {
  final dynamic userData;

  const ScreenInventory({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Dashboard for ${userData.username}")),
    );
  }
}
