import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_intro/screen_intro.dart';
import 'package:invento2/screens/screen_main_scaffold/screen_main_scaffold.dart';
import 'package:lottie/lottie.dart';
class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  ScreenSplashState createState() => ScreenSplashState();
}

class ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    super.initState();
    checkIfUserExists();
  }

  Future<void> checkIfUserExists() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      Box<UserModel> userBox;
      if (!Hive.isBoxOpen('user_db')) {
        userBox = await Hive.openBox<UserModel>('user_db');
      } else {
        userBox = Hive.box<UserModel>('user_db');
      }

      if (userBox.isNotEmpty) {
        // Get the first user
        final user = userBox.values.first;
        userDataNotifier.value = user;
        userDataNotifier.notifyListeners();

        // Navigate to home
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ScreenMain(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        );
      } else {
        // No user found, go to intro
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ScreenIntro(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        );
      }
    } catch (e) {
      // On error, navigate to intro
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ScreenIntro()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundWhite,
      body: Center(
        child: SizedBox(
          width: MediaQueryInfo.screenWidth * 0.5,
          height: MediaQueryInfo.screenWidth * 0.5,
          child: Lottie.asset("assets/gifs/truck.json"),
        ),
      ),
    );
  }
}
