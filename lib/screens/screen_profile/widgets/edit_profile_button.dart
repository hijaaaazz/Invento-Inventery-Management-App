import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_profile/sub_screens/screen_edit_profile/screen_edit_profile.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';

class EditProfileButton extends StatelessWidget {
  final UserModel user;

  const EditProfileButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: AppStyle.backgroundGrey,
                ),
              ),
              Expanded(
                child: Container(
                  color: AppStyle.backgroundWhite,
                ),
              )
            ],
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScreenEditProfile(userdata: user),
                  ),
                );
              },
              child: Container(
                width: MediaQueryInfo.screenWidth * 0.4,
                height: MediaQueryInfo.screenHeight * 0.055,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppStyle.backgroundPurple,
                ),
                child: Center(
                  child: Text(
                    'Edit Profile',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppStyle.textWhite,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
