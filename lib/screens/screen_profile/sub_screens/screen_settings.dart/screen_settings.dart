import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_profile/sub_screens/screen_settings.dart/widgets/settings_options_tile.dart';
import 'package:invento2/screens/screen_profile/sub_screens/screen_settings.dart/widgets/settins_tiles.dart';
import 'package:invento2/screens/screen_profile/sub_screens/screen_settings.dart/widgets/widget_appbar.dart';


class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: settingsAppBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQueryInfo.screenWidth * 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(),
            const SettingsSectionTitle(title: "General Settings"),
            const Divider(height: 5),
            SizedBox(height: MediaQueryInfo.screenHeight * 0.03),
            SettingsOptionTile(
              icon: Icons.notifications_none_outlined,
              title: "Notification",
              trailing: Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(value: false, onChanged: (_) {}),
              ),
            ),
            SizedBox(height: MediaQueryInfo.screenHeight * 0.015),
            SettingsOptionTile(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
            ),
            SizedBox(height: MediaQueryInfo.screenHeight * 0.015),
            SettingsOptionTile(
              icon: Icons.file_copy_outlined,
              title: "Terms & Conditions",
            ),
          ],
        ),
      ),
    );
  }
}
