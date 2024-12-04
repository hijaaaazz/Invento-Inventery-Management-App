import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

class UserInfo extends StatefulWidget {
  final UserModel user;

  const UserInfo({super.key, required this.user});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel?>(
      valueListenable: userDataNotifier,
      builder: (context, userData, child) {
        if (userData == null) {
          return const Center(child: Text('No user data available'));
        }

        return Container(
          color: AppStyle.backgroundGrey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: double.infinity,
              ),
              _buildProfileImage(userData.profileImage),
              const SizedBox(height: 10),
              Text(
                userData.name,
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.textBlack,
                ),
              ),
              const SizedBox(height: 20),
              if (userData.email.isNotEmpty)
                Text(
                  userData.email,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.textBlack,
                  ),
                ),
              if (userData.phone.isNotEmpty)
                Text(
                  userData.phone,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.textBlack,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const CircleAvatar(
        radius: 64,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, size: 64, color: Colors.white),
      );
    }

    if (kIsWeb) {
      // For Web
      return CircleAvatar(
        radius: 64,
        backgroundImage: NetworkImage(imagePath), // Ensure this URL is web-compatible
        backgroundColor: Colors.grey[500],
      );
    } else {
      // For Mobile
      return CircleAvatar(
        radius: 64,
        backgroundImage: FileImage(File(imagePath)),
        backgroundColor: Colors.grey[500],
      );
    }
  }
}
