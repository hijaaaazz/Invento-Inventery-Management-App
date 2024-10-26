import 'package:flutter/material.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';

class ScreenEditProfile extends StatelessWidget {
  const ScreenEditProfile({super.key});

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: MediaQueryInfo.screenHeight * 0.07,),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: MediaQueryInfo.screenWidth * 0.07), 
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back_ios, size: 18,),
                Icon(Icons.check, size: 20,)
              ],
            ),
          ),
          SizedBox(width: double.infinity,height: MediaQueryInfo.screenHeight* 0.07,),
          CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
              ),
            SizedBox(width: double.infinity,height: MediaQueryInfo.screenHeight* 0.07,),
            Row(
              children: [
                Container(
                  width: MediaQueryInfo.screenHeight*0.08,
                  height: MediaQueryInfo.screenHeight*0.08,

                  decoration: BoxDecoration(
                    color: Colors.red
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("name",style: TextStyle(color: Colors.purple),),
                  Flexible(child: TextFormField())
                  ],
                ),
                
              ],
            )
        ],
      ),
    );
  }
}