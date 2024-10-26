import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:invento2/database/users/models/models_user.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_main_scaffold/screen_main_scaffold.dart';
import 'package:invento2/screens/screen_register/widgets/widget_forms/widget_form.dart';

class ScreenSignIn extends StatefulWidget {
  const ScreenSignIn({super.key});

  @override
  _ScreenSignInState createState() => _ScreenSignInState();
}

class _ScreenSignInState extends State<ScreenSignIn> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Box userDB;

  String _usernameError = '';
  String _passwordError = '';

  @override
  void initState() {
    super.initState();
    userDB = Hive.box<User>("user_db");
  }

  void _validateAndLogin() {
    setState(() {
      _usernameError = '';
      _passwordError = '';
    });

    bool isValid = true;

    // Validation logic
    if (_usernameController.text.isEmpty) {
      setState(() {
        _usernameError = 'Please enter your username';
      });
      isValid = false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Please enter your password';
      });
      isValid = false;
    }

    // If fields are valid, proceed to login
    if (isValid) {
      _login();
    }
  }

  void _login() {
    String userName = _usernameController.text;
    String password = _passwordController.text;

    bool userFound = false;

    for (var element in userDB.values) {
      if (element.username == userName && element.password == password) {
        log("User ${element.username} successfully logged in");
        userFound = true;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ScreenMain(
            userdetails: element,
          ),
        ));
        break;
      }
    }

    if (!userFound) {
      setState(() {
        _usernameError = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQueryInfo.screenWidth * 0.07),
          child: Container(
            height: MediaQueryInfo.screenHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQueryInfo.screenHeight * 0.1),
                    Center(
                      child: Text(
                        "Welcome Back",
                        style: GoogleFonts.outfit(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 84, 81, 81),
                        ),
                      ),
                    ),
                    Text(
                      "Thank You for returning! Please log in to access your inventory and streamline your management process.",
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
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
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: _validateAndLogin,
                      child: Container(
                        width: MediaQueryInfo.screenWidth * 0.9,
                        height: MediaQueryInfo.screenHeight * 0.07,
                        decoration: BoxDecoration(
                          color: Color(0xFFE500D6),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            "Sign In",
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQueryInfo.screenHeight * 0.06),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
