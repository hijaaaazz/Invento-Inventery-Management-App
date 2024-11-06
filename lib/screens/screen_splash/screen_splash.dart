import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/inventory_model.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_intro/screen_intro.dart';
import 'package:invento2/screens/screen_main_scaffold/screen_main_scaffold.dart';
import 'package:lottie/lottie.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  ScreenSplashState createState() => ScreenSplashState();
}

class ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    super.initState();
    checkLoggedUser();
  }

  Future<void> checkLoggedUser() async {
    try {
      await Future.delayed(Duration(seconds: 2));

      // Open the required Hive boxes
      await Hive.openBox<UserModel>('user_db');
      var sessionBox = await Hive.openBox('sessionBox');

      // Retrieve the last logged user from the session box
      var lastLoggedUser = sessionBox.get('lastLoggedUser');

      if (lastLoggedUser is UserModel) {
        // Update the user data notifier
        userDataNotifier.value = lastLoggedUser;
        userDataNotifier.notifyListeners();

       final existingInventory = inventoryBox!.values.firstWhere(
      (inventory) => inventory.userId == lastLoggedUser.id, 
      orElse: () => InventoryModel(userId: lastLoggedUser.id, categories: []),
    );
    categoryListNotifier.value = existingInventory.categories!;
    categoryListNotifier.notifyListeners();


        
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ScreenMain(userdetails: lastLoggedUser),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );

        // Load all user data
        getAllUser();
      } else {
        // Navigate to the intro screen if no logged-in user is found
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ScreenIntro(),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    } catch (e) {
      // Handle any errors that occur during database operations
      print('Error during user check or database access: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: MediaQueryInfo.screenWidth * 0.5,
          height: MediaQueryInfo.screenWidth * 0.5,
          child: Lottie.asset("assets/gifs/truck.json"),
        ),
      ),
    );
  }
}
