import 'package:flutter/material.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_profile/sub_screens/screen_edit_profile/widgets/edit_fields.dart';

class ScreenEditProfile extends StatefulWidget {
  final UserModel userdata;

  const ScreenEditProfile({Key? key, required this.userdata}) : super(key: key);

  @override
  State<ScreenEditProfile> createState() => _ScreenEditProfileState();
}

class _ScreenEditProfileState extends State<ScreenEditProfile> { // Declare the ValueNotifier
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    
    emailController = TextEditingController(text: userDataNotifier.value.email);
    nameController = TextEditingController(text: userDataNotifier.value.name);
    phoneController = TextEditingController(text: userDataNotifier.value.phone);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQueryInfo.screenHeight * 0.07),
            _buildAppBar(context),
            SizedBox(height: MediaQueryInfo.screenHeight * 0.07),
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
                id: widget.userdata.id,
                email: emailController.text,
                name: nameController.text,
                phone: phoneController.text
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
            icon: Icon(Icons.person, color: Colors.black45),
          ),
          Divider(height: 5),
          EditProfileFields(
            controller: emailController,
            label: 'Email ID',
            icon: Icon(Icons.email, color: Colors.black45),
          ),
          Divider(height: 5),
          EditProfileFields(
            controller: phoneController,
            label: 'Phone Number',
            icon: Icon(Icons.phone, color: Colors.black45),
          ),
          Divider(height: 5),
        ],
      ),
    );
  }
}
