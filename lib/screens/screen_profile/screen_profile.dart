import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_intro/screen_intro.dart';

class ScreenProfile extends StatelessWidget {
  // Create a list of strings, icons, and colors to be used dynamically
  final List<Map<String, dynamic>> options = [
    {'title': 'Settings', 'icon': Icons.settings, 'color': Colors.black},
    {'title': 'Feedback', 'icon': Icons.chat_bubble_outline, 'color': Colors.black},
    {'title': 'Rate App', 'icon': Icons.star_border, 'color': Colors.black},
    {'title': 'About', 'icon': Icons.help_outline, 'color': Colors.black},
    {'title': 'Logout', 'icon': Icons.logout, 'color': Colors.red}, // Logout with red color
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
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
               Text("Name",style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.bold, // Text color from the list
                          ),),
                          SizedBox(height: 20,),
                Text("Email ID",style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.bold, // Text color from the list
                          ),),
                Text("Phone Number",style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.bold, // Text color from the list
                          ),),
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
                            // Navigate to Edit Profile page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(),
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
              height: MediaQueryInfo.screenHeight * 0.4, // Adjust this height if needed
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle navigation based on the selected option
                      if (options[index]['title'] == 'Settings') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      } else if (options[index]['title'] == 'About') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutScreen(),
                          ),
                        );
                      }
                      else if (options[index]['title'] == 'Logout') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScreenIntro(),
                          ),
                        );
                      } // Add more conditions for other options as needed
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFD9D9D9),
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
                              color: options[index]['color'], // Text color from the list
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
            child: Text("v-1.0",style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey // Text color from the list
                          ),),
          )
        ],
      ),
    );
  }
}

// Dummy Screens for demonstration purposes
class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Text('Edit Profile Page'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Text('Settings Page'),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Text('About Page'),
      ),
    );
  }
}
