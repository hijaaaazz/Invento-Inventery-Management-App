import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionsList extends StatelessWidget {
  final Function onLogout;
  final Function navSettings;

  OptionsList({super.key, required this.onLogout,required this.navSettings});

  final List<Map<String, dynamic>> options = [
    {'title': 'Settings', 'icon': Icons.settings, 'color': Colors.black},
    {'title': 'Feedback', 'icon': Icons.chat_bubble_outline, 'color': Colors.black},
    {'title': 'Rate App', 'icon': Icons.star_border, 'color': Colors.black},
    {'title': 'About', 'icon': Icons.help_outline, 'color': Colors.black},
    {'title': 'Logout', 'icon': Icons.logout, 'color': Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                if (options[index]['title'] == 'Logout') {
                  onLogout();
                }else if(options [index]['title']== 'Settings'){
                    navSettings();
                }
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
                        color: Color.fromARGB(255, 240, 240, 240),
                      ),
                      child: Center(
                        child: Icon(
                          options[index]['icon'],
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
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
    );
  }
}
