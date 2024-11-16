import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:lottie/lottie.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    AppStyle appStyle =AppStyle();
    return Dialog(
      child: Container(
      
        decoration: BoxDecoration(
          color: appStyle.BackgroundWhite,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: MediaQueryInfo.screenHeight * 0.02,),
            Text("Are you sure?", style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold
            )),
            SizedBox(
              height: MediaQueryInfo.screenHeight * 0.3,
              
              child: Lottie.asset('assets/gifs/logout.json'),
            ),
             SizedBox(height:MediaQueryInfo.screenHeight * 0.02,),
             GestureDetector(
              onTap: (){
                Navigator.of(context).pop(); 
                onConfirm();
              },
               child: Text("Logout", style: GoogleFonts.outfit(
                color: Colors.red,
                fontWeight: FontWeight.bold
                
                           )),
             ),
            const Divider(
              height: 25,
              color: Color.fromARGB(255, 231, 231, 231),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: GoogleFonts.outfit(
                    
              ),),
            ),
            
            
            SizedBox(height:MediaQueryInfo.screenHeight * 0.02,)
          ],
        ),
      ),
    );
  }
}
