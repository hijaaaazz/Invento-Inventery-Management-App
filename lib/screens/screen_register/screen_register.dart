import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  
  bool _showSecondSetOfFields = false;

  
  String _organizationError = '';
  String _emailError = '';
  String _phoneError = '';
  String _usernameError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';

  
  bool _validateFirstSetOfFields() {
    setState(() {
      _organizationError = '';
      _emailError = '';
      _phoneError = '';
    });

    bool isValid = true;

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

    return isValid;
  }

  
  bool _validateSecondSetOfFields() {
    setState(() {
      _usernameError = '';
      _passwordError = '';
      _confirmPasswordError = '';
    });

    bool isValid = true;

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

    return isValid;
  }

  
  bool _validateAndSubmit() {
    if (!_showSecondSetOfFields) {
      if (_validateFirstSetOfFields()) {
        setState(() {
          _showSecondSetOfFields = true;
        });
      }
    } else {
      if (_validateSecondSetOfFields()) {
        return true; 
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardVisible = mediaQuery.viewInsets.bottom > 0;
    final topPadding = keyboardVisible ? MediaQueryInfo.screenHeight * 0.05 : MediaQueryInfo.screenHeight * 0.1;
    AppStyle appStyle =AppStyle();

    return Scaffold(
      backgroundColor: appStyle.BackgroundWhite,
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
                  color: const Color.fromARGB(255, 84, 81, 81),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Create your account to get started! Sign up to begin managing your inventory.",
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
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
                    const SizedBox(height: 5),
                    CustomTextField(
                      controller: _emailController,
                      hintText: "Email ID",
                      errorText: _emailError,
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      controller: _phoneController,
                      hintText: "Phone Number",
                      errorText: _phoneError,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                  if (_showSecondSetOfFields) ...[
                    CustomTextField(
                      controller: _usernameController,
                      hintText: "Username",
                      errorText: _usernameError,
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: "Password",
                      obscureText: true,
                      errorText: _passwordError,
                    ),
                    const SizedBox(height: 5),
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
            const Spacer(),
            GestureDetector(
              onTap: () async {
  if (_validateAndSubmit()) {
 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registering...')),
    );

    bool isSuccess = await addUser(
      name: _organizationNameController.text,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: _emailController.text,
      phone: _phoneController.text,
      username: _usernameController.text,
      pass: _passwordController.text,
    );

    if (isSuccess) {
      log("User added");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully registered!'),
          duration: Duration(seconds: 2), 
        ),
      );

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const ScreenSignIn()),
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
                  color: appStyle.BackgroundPurple,
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
