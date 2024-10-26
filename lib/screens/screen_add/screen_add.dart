import 'package:flutter/material.dart';

class ScreenAddOrder extends StatelessWidget {
  final dynamic userData;
  const ScreenAddOrder({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Center(child: Text("Add order ${userData.username}")),
    );
  }
}
