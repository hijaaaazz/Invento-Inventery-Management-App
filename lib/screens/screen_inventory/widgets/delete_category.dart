
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/category/category_model.dart';
import 'package:invento2/database/users/user_fuctions.dart';

void longPressEmptyCategory(BuildContext context, CategoryModel category) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text("Delete Category"),
        content: const Text("Are you sure you want to delete this category?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); 
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
            deleteCategory(category.id!,userDataNotifier.value.id, context,);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}