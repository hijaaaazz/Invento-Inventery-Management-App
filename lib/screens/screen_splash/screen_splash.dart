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
    checkLoggedUser();
    
  }

  Future<void> checkLoggedUser() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      await Hive.openBox<UserModel>('user_db');
      var sessionBox = await Hive.openBox('sessionBox');


      var lastLoggedUser = sessionBox.get('lastLoggedUser');

      if (lastLoggedUser is UserModel) {
        userDataNotifier.value = lastLoggedUser;
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        userDataNotifier.notifyListeners();
      
        // ignore: use_build_context_synchronously
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

        getAllUser();
      } else {
        
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ScreenIntro(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    // ignore: empty_catches
    } catch (e) {
    
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
