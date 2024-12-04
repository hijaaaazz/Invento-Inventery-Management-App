import 'dart:convert';
import 'dart:io';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_profile/sub_screens/screen_edit_profile/widgets/edit_fields.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

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

  void updateImage(String pickedPath) {
    setState(() {
      imagePath = pickedPath;
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
    return Scaffold(
      backgroundColor: AppStyle.backgroundWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: appBarHelper("",
              actions: [IconButton(onPressed: (){
                updateUser(
                  id: userDataNotifier.value.id,
                  email: emailController.text,
                  name: nameController.text,
                  phone: phoneController.text,
                  image: imagePath ?? userDataNotifier.value.profileImage ?? "",
                );
                Navigator.of(context).pop();
              }, icon: Icon(Icons.check) )
              ]),
            ),
            SizedBox(height: MediaQueryInfo.screenHeight * 0.07),
              GestureDetector(
                onTap: () {
                  _pickImage(updateImage);
                },
                child: CircleAvatar(
                  radius: 64,
                  backgroundImage: imagePath != null
                      ? (kIsWeb
                          ? NetworkImage(imagePath!) // Use a compatible URL or base64 on web
                          : FileImage(File(imagePath!)) as ImageProvider)
                      : null,
                  backgroundColor: Colors.grey[300],
                  child: imagePath == null
                      // ignore: prefer_const_constructors
                      ?  Center(
                          child:Icon(Icons.person,size: 50,)
                        )
                      : null,
                ),
              ),

            SizedBox(height: MediaQueryInfo.screenHeight * 0.07),
            _buildEditFields(),
          ],
        ),
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
            icon:  Icon(Icons.person, color: AppStyle.backgroundBlack),
          ),
          const Divider(height: 5),
          EditProfileFields(
            controller: emailController,
            label: 'Email ID',
            icon: Icon(Icons.email, color: AppStyle.backgroundBlack),
          ),
          const Divider(height: 5),
          EditProfileFields(
            controller: phoneController,
            label: 'Phone Number',
            icon:  Icon(Icons.phone, color:  AppStyle.backgroundBlack),
          ),
          const Divider(height: 5),
        ],
      ),
    );
  }
}

Future<void> convertBlobToBase64(String blobUrl, Function(String) onBase64Ready) async {
  html.HttpRequest.request(blobUrl, responseType: "arraybuffer").then((request) {
    final Uint8List bytes = Uint8List.view(request.response);
    final base64String = base64Encode(bytes);
    onBase64Ready(base64String);
  });
}
Future<void> _pickImage(Function updateImage) async {
  if (kIsWeb) {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        final reader = html.FileReader();
        reader.readAsDataUrl(files[0]);
        reader.onLoadEnd.listen((event) {
          updateImage(reader.result as String);
        });
      }
    });
  } else {
    // mobile
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      updateImage(pickedFile.path);
    }
  }
}
