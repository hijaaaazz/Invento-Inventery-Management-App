import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
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
  Uint8List? webImage;

  @override
  void initState() {
    super.initState();
    // Handle web image decoding
    if (kIsWeb && userDataNotifier.value.profileImage != null) {
      try {
        webImage = base64Decode(userDataNotifier.value.profileImage!);
      } catch (e) {
        webImage = null;
      }
    }
  }

  Widget _placeholderImage() {
    return CircleAvatar(
      radius: 64,
      backgroundColor: Colors.grey[300],
      child: const Icon(
        Icons.person,
        size: 64,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildProfileImage(UserModel userData) {
    try {
      if (kIsWeb) {
        // Web image handling (base64)
        return userData.profileImage != null && userData.profileImage!.isNotEmpty
            ? CircleAvatar(
                radius: 64,
                backgroundImage: MemoryImage(base64Decode(userData.profileImage!)),
              )
            : _placeholderImage();
      } else {
        // Mobile image handling (file path)
        return userData.profileImage != null && userData.profileImage!.isNotEmpty
            ? CircleAvatar(
                radius: 64,
                backgroundImage: FileImage(File(userData.profileImage!)),
              )
            : _placeholderImage();
      }
    } catch (e) {
      return _placeholderImage();
    }
  }

  Widget _buildInfoText(String text) {
    return Text(
      text,
      style: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppStyle.textBlack,
      ),
    );
  }

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
              _buildProfileImage(userData),
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
                _buildInfoText(userData.email),
              if (userData.phone.isNotEmpty)
                _buildInfoText(userData.phone),
            ],
          ),
        );
      },
    );
  }
}