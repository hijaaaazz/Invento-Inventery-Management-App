import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_intro/screen_intro.dart';
import 'package:invento2/screens/screen_profile/sub_screens/screen_settings.dart/screen_settings.dart';
import 'package:invento2/screens/screen_profile/widgets/edit_profile_button.dart';
import 'package:invento2/screens/screen_profile/widgets/options.dart';
import 'package:invento2/screens/screen_profile/widgets/logout_dialog.dart';
import 'package:invento2/screens/screen_profile/widgets/user.info.dart'; // Import the dialog

class ScreenProfile extends StatelessWidget {
  final UserModel user;

  const ScreenProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    AppStyle appStyle=AppStyle();
    return Scaffold(
      backgroundColor:AppStyle.BackgroundWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfo(user: user),
            EditProfileButton(user: user),
            OptionsList(onLogout: () => showLogoutDialog(context),navSettings:(){
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> const ScreenSettings()));
            },),
            Center(
              child: Text(
                "v-1.0",
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => LogoutDialog(
        onConfirm: () => logout(context), 
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    var sessionBox = await Hive.openBox('sessionBox');
    await sessionBox.delete('lastLoggedUser');
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ScreenIntro(),
      ),
    );
  }
}
