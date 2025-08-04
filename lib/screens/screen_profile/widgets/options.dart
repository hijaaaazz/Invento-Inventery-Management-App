import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_profile/sub_screens/screen_about.dart';
import 'package:invento2/screens/screen_profile/sub_screens/screen_settings.dart/screen_settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:invento2/screens/screen_intro/screen_intro.dart';
import 'package:invento2/screens/screen_profile/widgets/logout_dialog.dart';

class Option {
  final String title;
  final IconData icon;
  final Color? color;
  final Future Function()? onTap;

  Option({
    required this.title,
    required this.icon,
    this.color = Colors.black,
    this.onTap,
  });
}
class OptionsList extends StatelessWidget {
  const OptionsList({super.key});

  Future<void> sendFeedback() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'mhcnkd4@gmail.com',
      query: 'subject=Feedback for Inventory App&body=Hi Team,%0A%0AI would like to share the following feedback:%0A%0A',
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      debugPrint("Error sending feedback: $e");
    }
  }
Future<void> rateApp(BuildContext context) async {
  final Uri rateAppLink = Uri.parse("https://www.amazon.com/dp/B0DPNC87X6/ref=apps_sf_sta");

  try {
    await launchUrl(rateAppLink, mode: LaunchMode.externalApplication);
  // ignore: empty_catches
  } catch (e) {

  }
}



  navSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ScreenSettings()),
    );
  }

  navScreenAbout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ScreenAbout()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppStyle.isDarkThemeNotifier,
      builder: (context, isDark, _) {
        final List<Option> options = [
          Option(
            title: 'Settings',
            icon: Icons.settings,
            onTap: () async => navSettings(context),
          ),
          Option(
            title: 'Feedback',
            icon: Icons.chat_bubble_outline,
            onTap: sendFeedback,
          ),
          Option(
            title: 'Rate App',
            icon: Icons.star_border,
            onTap: () => rateApp(context),
          ),
          Option(
            title: 'About',
            icon: Icons.help_outline,
            onTap: () async => navScreenAbout(context),
          ),
         
        ];

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.2,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: options[index].onTap,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:AppStyle.backgroundWhite,
                          ),
                          child: Center(
                            child: Icon(
                              options[index].icon,
                              size: 20,
                              color: AppStyle.backgroundBlack
                            ),
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                        Text(
                          options[index].title,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppStyle.textBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
