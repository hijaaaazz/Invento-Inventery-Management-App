import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_register/screen_register.dart';
import 'package:invento2/screens/screen_sign_in/screen_sign_in.dart';
import 'package:lottie/lottie.dart';
import '../../helpers/media_query_helper/media_query_helper.dart';


class ScreenIntro extends StatelessWidget {
  const ScreenIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppStyle.backgroundWhite,
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
                  color: AppStyle.backgroundPurple,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(20)
                  )
              ),
              child: Padding(

                padding:  EdgeInsets.only(right: MediaQueryInfo.screenWidth * 0.08),
                child: Lottie.asset("assets/gifs/box.json"),
              )
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Inventory Management Made Easy",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.textBlack
              ),
            ),

            const SizedBox(height: 10,),
            Text("Manage your Inventory effortlessly with a simple and efficient system. Keep track of stock, streamline operations, and stay organised with ease",
              textAlign: TextAlign.center,
              style:GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: AppStyle.textBlack
              ),),
            const SizedBox(
              width: double.infinity,
              height: 40,
            
            ),
            Row(
              children: [
            
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                                 
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const ScreenRegister()));
                    },
                    child: Container(
                      width: MediaQueryInfo.screenWidth*0.43,
                      height: MediaQueryInfo.screenHeight*0.08,
                      decoration: BoxDecoration(
                          color: AppStyle.backgroundGrey,
                          borderRadius: BorderRadius.circular(
                              15
                          )
                      ),
                      child: Center(
                        child: Text("Get Sarted",
                          style:GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppStyle.textBlack
                          ),),
                      ),
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