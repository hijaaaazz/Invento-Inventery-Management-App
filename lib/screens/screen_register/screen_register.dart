import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_main_scaffold/screen_main_scaffold.dart';
import 'package:invento2/screens/screen_register/widgets/widget_forms/widget_form.dart';
import 'package:invento2/screens/screen_sign_in/screen_sign_in.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScreenRegisterState createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  
  final TextEditingController _organizationNameController = TextEditingController();
  
  

  
  String _organizationError = '';
  

  
  bool _validateFirstSetOfFields() {
    setState(() {
      _organizationError = '';
      
    });

    bool isValid = true;

    if (_organizationNameController.text.isEmpty) {
      _organizationError = 'Please enter organization name';
      isValid = false;
    }
   

    return isValid;
  }

  


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardVisible = mediaQuery.viewInsets.bottom > 0;
    final topPadding = keyboardVisible ? MediaQueryInfo.screenHeight * 0.05 : MediaQueryInfo.screenHeight * 0.1;

    return Scaffold(
      backgroundColor: AppStyle.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: topPadding),
            Center(
              child: Text(
                "Registration",
                style: GoogleFonts.outfit(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.textBlack,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Create your account to get started! Sign up to begin managing your inventory.",
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color:AppStyle.textBlack,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  
                    CustomTextField(
                      controller: _organizationNameController,
                      hintText: "Organization Name",
                      errorText: _organizationError,
                    ),
                    
                  
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
  if (_validateFirstSetOfFields()) {
 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Let\'s Start...')),
    );

    bool isSuccess = await addUser(
      name: _organizationNameController.text,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    if (isSuccess) {
      log("User added");
      // ignore: use_build_context_synchronously
      

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => ScreenMain()),
      );
    } else {
      log("Failed to add user");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to register. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
},

              child: Container(
                height: mediaQuery.size.height * 0.07,
                width: mediaQuery.size.width * 0.9,
                decoration: BoxDecoration(
                  color: AppStyle.backgroundPurple,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Continue" ,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:AppStyle.textWhite,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
