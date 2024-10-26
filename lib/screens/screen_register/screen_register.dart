import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/users/functions/users_db_functions.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_register/widgets/widget_forms/widget_form.dart';
import 'package:invento2/screens/screen_sign_in/screen_sign_in.dart';

class ScreenRegister extends StatefulWidget {
  @override
  _ScreenRegisterState createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _organizationNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // State variable to track which fields to show
  bool _showSecondSetOfFields = false;

  // Error messages
  String _organizationError = '';
  String _emailError = '';
  String _phoneError = '';
  String _usernameError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';

  void _validateAndSubmit() {
  // Reset error messages
  setState(() {
    _organizationError = '';
    _emailError = '';
    _phoneError = '';
    _usernameError = '';
    _passwordError = '';
    _confirmPasswordError = '';
  });

  bool isValid = true;

  if (!_showSecondSetOfFields) {
    // Validate the first set of fields
    if (_organizationNameController.text.isEmpty) {
      _organizationError = 'Please enter organization name';
      isValid = false;
    }
    if (_emailController.text.isEmpty) {
      _emailError = 'Please enter your email';
      isValid = false;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text)) {
      _emailError = 'Please enter a valid email';
      isValid = false;
    }
    if (_phoneController.text.isEmpty) {
      _phoneError = 'Please enter your phone number';
      isValid = false;
    } else if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(_phoneController.text)) {
      _phoneError = 'Please enter a valid phone number';
      isValid = false;
    }

    if (isValid) {
      // If valid, show the second set of fields
      setState(() {
        _showSecondSetOfFields = true;
      });
    }
  } else {
    // Validate the second set of fields
    if (_usernameController.text.isEmpty) {
      _usernameError = 'Please enter your username';
      isValid = false;
    }
    if (_passwordController.text.isEmpty) {
      _passwordError = 'Please enter your password';
      isValid = false;
    }
    if (_confirmPasswordController.text.isEmpty) {
      _confirmPasswordError = 'Please confirm your password';
      isValid = false;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      _passwordError = 'Passwords do not match';
      isValid = false;
    }

   
    if (isValid) {
      addUser(
        name: _organizationNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
     
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ScreenSignIn()),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardVisible = mediaQuery.viewInsets.bottom > 0; // Check if keyboard is visible
    final topPadding = keyboardVisible ?  MediaQueryInfo.screenHeight*0.05: MediaQueryInfo.screenHeight*0.1; // Adjust top padding based on keyboard visibility

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: topPadding), // Adjust the space based on keyboard visibility
            Center(
              child: Text(
                "Registration",
                style: GoogleFonts.outfit(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 84, 81, 81),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Create your account to get started! Sign up to begin managing your inventory.",
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Provide some space between the text and the form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!_showSecondSetOfFields) ...[
                    CustomTextField(
                      controller: _organizationNameController,
                      hintText: "Organization Name",
                      errorText: _organizationError,
                    ),
                    SizedBox(height: 5),
                    CustomTextField(
                      controller: _emailController,
                      hintText: "Email ID",
                      errorText: _emailError,
                    ),
                    SizedBox(height: 5),
                    CustomTextField(
                      controller: _phoneController,
                      hintText: "Phone Number",
                      errorText: _phoneError,
                    ),
                  ],
                  if (_showSecondSetOfFields) ...[
                    CustomTextField(
                      controller: _usernameController,
                      hintText: "Username",
                      errorText: _usernameError,
                    ),
                    SizedBox(height: 5),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: "Password",
                      obscureText: true,
                      errorText: _passwordError,
                    ),
                    SizedBox(height: 5),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: "Confirm Password",
                      obscureText: true,
                      errorText: _confirmPasswordError,
                    ),
                  ],
                ],
              ),
            ),
            Spacer(), // Pushes the button to the bottom
            GestureDetector(
              onTap: _validateAndSubmit,
              
              child: Container(
                height: mediaQuery.size.height * 0.07,
                width: mediaQuery.size.width * 0.9,
                decoration: BoxDecoration(
                  color: Color(0xFFE500D6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    _showSecondSetOfFields ? "Continue" : "Next",
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Provide some space at the bottom
          ],
        ),
      ),
    );
  }
}

