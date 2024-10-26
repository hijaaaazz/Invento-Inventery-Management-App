import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_intro/screen_intro.dart';
import 'package:invento2/screens/screen_profile/sub_screens/screen_edit_profile/screen_edit_profile.dart';

class ScreenProfile extends StatelessWidget {
  final UserModel user; 

  ScreenProfile({required this.user});

  final List<Map<String, dynamic>> options = [
    {'title': 'Settings', 'icon': Icons.settings, 'color': Colors.black},
    {'title': 'Feedback', 'icon': Icons.chat_bubble_outline, 'color': Colors.black},
    {'title': 'Rate App', 'icon': Icons.star_border, 'color': Colors.black},
    {'title': 'About', 'icon': Icons.help_outline, 'color': Colors.black},
    {'title': 'Logout', 'icon': Icons.logout, 'color': Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xFFD9D9D9),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQueryInfo.screenHeight * 0.1,
                  width: double.infinity,
                ),
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              
                Text(
                  user.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
               
                Text(
                  user.email,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            
                Text(
                  user.phone,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 80,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: Container(
                              color: const Color(0xFFD9D9D9),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.white,
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
                                builder: (context) => const ScreenEditProfile(),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQueryInfo.screenWidth * 0.4,
                            height: MediaQueryInfo.screenHeight * 0.055,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xFFEC00DD),
                            ),
                            child: Center(
                              child: Text(
                                'Edit Profile',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQueryInfo.screenWidth * 0.2),
            child: Container(
              height: MediaQueryInfo.screenHeight * 0.4,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      if (options[index]['title'] == 'Logout') {
                        await logout(context); // Call the new logout method
                      }
                      // Handle other options as needed
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFD9D9D9),
                            ),
                            child: Center(
                              child: Icon(
                                options[index]['icon'],
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(width: MediaQueryInfo.screenWidth * 0.1),
                          Text(
                            options[index]['title'],
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: options[index]['color'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Center(
            child: Text(
              "v-1.0",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    var sessionBox = await Hive.openBox('sessionBox');
    await sessionBox.delete('lastLoggedUser'); // Clear the last logged user on logout
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ScreenIntro(),
      ),
    );
  }
}


