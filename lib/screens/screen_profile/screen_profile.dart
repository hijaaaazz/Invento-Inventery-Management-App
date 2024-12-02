import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_profile/widgets/edit_profile_button.dart';
import 'package:invento2/screens/screen_profile/widgets/options.dart';
import 'package:invento2/screens/screen_profile/widgets/user.info.dart';
class ScreenProfile extends StatelessWidget {
  final UserModel user;

  const ScreenProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppStyle.isDarkThemeNotifier,
      builder: (context, isDark, _) {
        return Scaffold(
          backgroundColor: AppStyle.backgroundWhite,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfo(user: user),
                EditProfileButton(user: user),
                const OptionsList(),
                Center(
                  child: Text(
                    "v-1.0",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: AppStyle.textWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
