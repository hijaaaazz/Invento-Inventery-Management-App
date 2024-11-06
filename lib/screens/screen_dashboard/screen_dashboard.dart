import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/category/category_model.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/database/users/user_model.dart';

class ScreenDashboard extends StatelessWidget {
  final dynamic userData;

  const ScreenDashboard({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // User Data
            ValueListenableBuilder<UserModel?>(
              valueListenable: userDataNotifier,
              builder: (context, user, child) {
                if (user == null) {
                  return CircularProgressIndicator();
                } else {
                  return Text('Welcome ${user.name}');
                }
              },
            ),

            // Spacer to add some space between widgets
            SizedBox(height: 20),

            // Category Data
            Expanded(
              child: ValueListenableBuilder<List<CategoryModel>>(
                valueListenable: categoryListNotifier,
                builder: (context, categories, child) {
                  if (categories.isEmpty) {
                    return Text('No Categories Available');
                  } else {
                    // Using ListView.builder wrapped in Expanded
                    return ListView.builder(
                      itemCount: categories.length,
                     itemBuilder: (context, index) {
  return ListTile(
    title: Text(categories[index].name ?? 'Unnamed Category'), // Provide a default value
  );
},

                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
