import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/category/category_model.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/database/users/user_model.dart';

class ScreenDashboard extends StatelessWidget {
  final dynamic userData;

  const ScreenDashboard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ValueListenableBuilder<UserModel?>(
              valueListenable: userDataNotifier,
              builder: (context, user, child) {
                if (user == null) {
                  return const CircularProgressIndicator();
                } else {
                  return Text('Welcome ${user.name}');
                }
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ValueListenableBuilder<List<CategoryModel>>(
                valueListenable: categoryListNotifier,
                builder: (context, categories, child) {
                  if (categories.isEmpty) {
                    return const Text('No Categories Available');
                  } else {
                    return ListView.builder(
                      itemCount: categories.length,
                     itemBuilder: (context, index) {
  return ListTile(
    title: Text(categories[index].name ?? 'Unnamed Category'), 
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
