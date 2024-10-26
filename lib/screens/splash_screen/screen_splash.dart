import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/screens/screen_intro/screen_intro.dart';
import 'package:invento2/screens/screen_main_scaffold/screen_main_scaffold.dart';


class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

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
    var sessionBox = await Hive.openBox('sessionBox');

    // Check if there is a last logged-in user
    final lastLoggedUser = sessionBox.get('lastLoggedUser') as UserModel?;
    
    // If user exists, navigate to ScreenMain with user details
    if (lastLoggedUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ScreenMain(userdetails: lastLoggedUser),
        ),
      );
    } else {
      // No user found, go to intro screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ScreenIntro(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
