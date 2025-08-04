// Modified UserInfo Widget
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/database/users/user_model.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_profile/widgets/edit_profile_button.dart';

class UserInfo extends StatefulWidget {
  final UserModel? user;

  const UserInfo({super.key, required this.user});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool isEditing = false;
  late TextEditingController nameController;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?.name ?? '');
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    nameController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
      if (isEditing) {
        // Use the current displayed name from userDataNotifier
        nameController.text = userDataNotifier.value.name;
        // Auto-focus and position cursor at the end
        WidgetsBinding.instance.addPostFrameCallback((_) {
          focusNode.requestFocus();
          nameController.selection = TextSelection.fromPosition(
            TextPosition(offset: nameController.text.length),
          );
        });
      }
    });
  }

  Future<void> _saveChanges() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty || widget.user == null) return;

    final success = await updateUser(id: widget.user!.id, name: newName);
    if (success) {
      setState(() {
        isEditing = false;
      });
      // Unfocus the text field
      focusNode.unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel>(
      valueListenable: userDataNotifier,
      builder: (context, userData, child) {
        return Container(
          color: AppStyle.backgroundPurple,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: double.infinity,
              ),
              const SizedBox(height: 10),

              // Editable Name
              isEditing
                  ? IntrinsicHeight(
                      child: TextField(
                        controller: nameController,
                        focusNode: focusNode,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        cursorColor: const Color.fromARGB(255, 0, 0, 0),
                        cursorWidth: 3,
                        cursorHeight: 20,
                        decoration: const InputDecoration(
                          
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppStyle.textWhite,
                        ),
                      ),
                    )
                  : Text(
                      userData.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.textWhite,
                      ),
                    ),

              const SizedBox(height: 25),

              EditProfileButton(
                user: widget.user,
                isEditing: isEditing,
                onToggleEdit: toggleEditMode,
                onSave: _saveChanges,
              ),
            ],
          ),
        );
      },
    );
  }
}
