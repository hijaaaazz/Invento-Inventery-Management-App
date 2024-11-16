import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_profile/sub_screens/screen_edit_profile/widgets/edit_fields.dart';

class ScreenEditProfile extends StatefulWidget {
  final UserModel userdata;

  const ScreenEditProfile({super.key, required this.userdata});

  @override
  State<ScreenEditProfile> createState() => _ScreenEditProfileState();
}

class _ScreenEditProfileState extends State<ScreenEditProfile> { 
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late String? imagePath;

  @override
  void initState() {
    super.initState();
    
    emailController = TextEditingController(text: userDataNotifier.value.email);
    nameController = TextEditingController(text: userDataNotifier.value.name);
    phoneController = TextEditingController(text: userDataNotifier.value.phone);
    imagePath = userDataNotifier.value.profileImage;
  }

  void updateImage(pickedFile){
    setState(() {
      imagePath = pickedFile;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStyle appStyle = AppStyle();
    
    return Scaffold(
      backgroundColor: appStyle.BackgroundWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQueryInfo.screenHeight * 0.07),
            _buildAppBar(context),
            SizedBox(height: MediaQueryInfo.screenHeight * 0.07),
            GestureDetector(
              onTap: () {
                _pickImage(updateImage);
              },
              child: CircleAvatar(
                radius: 64, 
                backgroundImage: imagePath != null
                    ? FileImage(File(imagePath!)) 
                    : const AssetImage('assets/images/box.jpg') as ImageProvider, 
                backgroundColor: Colors.grey[300], 
                child: 
                    const Center(
                        child: Text(
                          '''Add\nImage''',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      )
              ),
            ),
            SizedBox(height: MediaQueryInfo.screenHeight * 0.07),
            _buildEditFields(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryInfo.screenWidth * 0.07),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, size: 18),
          ),
          GestureDetector(
            onTap: () {
              updateUser(
                id: userDataNotifier.value.id,
                email: emailController.text,
                name: nameController.text,
                phone: phoneController.text,
                image: imagePath ?? userDataNotifier.value.profileImage
                
               );


               Navigator.of(context).pop();
            },
            child: const Icon(Icons.check, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildEditFields() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQueryInfo.screenWidth * 0.1),
      child: Column(
        children: [
          EditProfileFields(
            controller: nameController,
            label: 'Name',
            icon: const Icon(Icons.person, color: Colors.black45),
          ),
          const Divider(height: 5),
          EditProfileFields(
            controller: emailController,
            label: 'Email ID',
            icon: const Icon(Icons.email, color: Colors.black45),
          ),
          const Divider(height: 5),
          EditProfileFields(
            controller: phoneController,
            label: 'Phone Number',
            icon: const Icon(Icons.phone, color: Colors.black45),
          ),
          const Divider(height: 5),
        ],
      ),
    );
  }
}


Future<void> _pickImage(Function updateImage) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    updateImage(pickedFile.path);
  } 
}
