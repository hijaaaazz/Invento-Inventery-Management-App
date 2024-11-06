import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/database/users/user_model.dart';

class UserInfo extends StatefulWidget {
  final UserModel user;

  const UserInfo({required this.user});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel?>(
      valueListenable: userDataNotifier,
      builder: (context, userData, child) {
        // Handle the case where userData might be null
        if (userData == null) {
          return const Center(child: Text('No user data available'));
        }
        
        return Container(
          color: const Color(0xFFD9D9D9),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: double.infinity,
              ),
              const SizedBox(height: 10),
              Text(
                userData.name,  // Safely access userData
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                userData.email,  // Safely access userData
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userData.phone,  // Safely access userData
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
