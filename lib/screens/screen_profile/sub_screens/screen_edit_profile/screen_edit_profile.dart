import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';

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

  ValueNotifier<XFile?> imageFile = ValueNotifier<XFile?>(null);
  Uint8List? webImage;

  final ImagePicker picker = ImagePicker();
@override
void initState() {
  super.initState();
  emailController = TextEditingController(text: widget.userdata.email);
  nameController = TextEditingController(text: widget.userdata.name);
  phoneController = TextEditingController(text: widget.userdata.phone);

  final existingImage = userDataNotifier.value.profileImage;
  imageFile.value = (kIsWeb || existingImage == null || existingImage.isEmpty) 
      ? null 
      : XFile(existingImage);

  if (kIsWeb && existingImage != null && existingImage.isNotEmpty) {
    try {
      webImage = base64Decode(existingImage);
    } catch (e) {
      webImage = null;
    }
  }
}

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = pickedFile;

      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          webImage = bytes;
        });
      }
    }
  }

  Widget _buildImagePicker() {
    return Center(
      child: ValueListenableBuilder<XFile?>(
        valueListenable: imageFile,
        builder: (context, file, _) {
          return GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 64,
              backgroundColor: Colors.grey[300],
              child: ClipOval(
                child: kIsWeb
                    ? (webImage != null
                        ? Image.memory(
                            webImage!,
                            width: 128,
                            height: 128,
                            fit: BoxFit.cover,
                          )
                        : _placeholderImage())
                    : (file != null
                        ? Image.file(
                            File(file.path),
                            width: 128,
                            height: 128,
                            fit: BoxFit.cover,
                          )
                        : _placeholderImage()),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 128,
      height: 128,
      color: Colors.grey[300],
      child: const Icon(
        Icons.person,
        size: 64,
        color: Colors.grey,
      ),
    );
  }

  Future<void> _updateProfile() async {
  final updatedUser = UserModel(
    id: widget.userdata.id,
    email: emailController.text,
    name: nameController.text,
    phone: phoneController.text,
    profileImage: kIsWeb
        ? base64Encode(webImage!)
        : imageFile.value?.path ?? widget.userdata.profileImage,
    username: userDataNotifier.value.email,
    password: userDataNotifier.value.password,
  );

  await updateUser(
    id: widget.userdata.id,
    email: updatedUser.email,
    name: updatedUser.name,
    phone: updatedUser.phone,
    image: updatedUser.profileImage,
  );

  // Update the notifier
  userDataNotifier.value = updatedUser;

  // Navigate back
  // ignore: use_build_context_synchronously
  Navigator.of(context).pop();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _updateProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            children: [
              _buildImagePicker(),
              SizedBox(height: MediaQueryInfo.screenHeight * 0.05),
              _buildEditFields(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditFields() {
    return Column(
      children: [
        _buildTextField("Name", nameController),
        _buildTextField("Email", emailController),
        _buildTextField("Phone", phoneController),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF3F3F3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}