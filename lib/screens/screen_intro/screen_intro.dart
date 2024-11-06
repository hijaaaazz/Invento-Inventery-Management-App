import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/screens/screen_register/screen_register.dart';
import 'package:invento2/screens/screen_sign_in/screen_sign_in.dart';
import 'package:lottie/lottie.dart';

import '../../helpers/media_query_helper/media_query_helper.dart';


class ScreenIntro extends StatelessWidget {
  const ScreenIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQueryInfo.screenWidth*0.07),
        child: Column(
          children: [
            SizedBox(
              height: MediaQueryInfo.screenHeight * 0.1,
              width: double.infinity,

            ),
            Container(

              height: MediaQueryInfo.screenHeight*0.5,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color(0xFFE500D6),
                  borderRadius: BorderRadius.all(
                      Radius.circular(20)
                  )
              ),
              child: Padding(

                padding:  EdgeInsets.only(right: MediaQueryInfo.screenWidth * 0.08),
                child: Lottie.asset("assets/gifs/box.json"),
              )
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "Inventory Management Made Easy",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 70, 68, 68)
              ),
            ),

            SizedBox(height: 10,),
            Text("Manage your Inventory effortlessly with a simple and efficient system. Keep track of stock, streamline operations, and stay organised with ease",
              textAlign: TextAlign.center,
              style:GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),),
            SizedBox(
              width: double.infinity,
              height: 40,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ScreenSignIn(), ));
                  },
                  child: Container(
                    width: MediaQueryInfo.screenWidth*0.43,
                    height: MediaQueryInfo.screenHeight*0.08,
                    decoration: BoxDecoration(
                        color: Color(0xFFE500D6),
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(15)
                        )
                    ),
                    child: Center(
                      child: Text("Sign in",
                        style:GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
               
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ScreenRegister()));
                  },
                  child: Container(
                    width: MediaQueryInfo.screenWidth*0.43,
                    height: MediaQueryInfo.screenHeight*0.08,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(15)
                        )
                    ),
                    child: Center(
                      child: Text("Register",
                        style:GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 84, 81, 81)
                        ),),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}