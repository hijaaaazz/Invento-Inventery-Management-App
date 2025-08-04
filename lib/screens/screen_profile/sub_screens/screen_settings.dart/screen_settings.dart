import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/screens/screen_intro/screen_intro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_profile/sub_screens/screen_settings.dart/widgets/settings_options_tile.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  bool isDarkTheme = AppStyle.isDarkThemeNotifier.value;
  String selectedCurrency = "INR ₹";
  String selectedUnit = 'Pcs';
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      // Load unit preference
      selectedUnit = _prefs.getString('unit_preference') ?? 'Pcs';
      if (!['Kg', 'Ltr', 'Pcs'].contains(selectedUnit)) {
        selectedUnit = 'Kg';
      }

      // Load currency preference
      selectedCurrency = _prefs.getString('currency_preference') ?? 'INR ₹';
      if (!['USD \$', 'EUR €', 'INR ₹'].contains(selectedCurrency)) {
        selectedCurrency = 'INR ₹';
      }
    });
  }

  // Function to show the confirmation dialog for deleting the user
  Future<void> _showDeleteConfirmationDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false, // User can't dismiss dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the delete user function here
                _deleteUser(context);

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Function to delete the user (just a placeholder for now)
  Future<void> _deleteUser(BuildContext context) async {
  final result = await deleteUser(userDataNotifier.value.id);

  if (result) {
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ScreenIntro(),
      ),
    );
    log("User deleted and navigated to ScreenIntro!");
  } else {
    // Log an error or show a dialog if deletion failed
    log("Error: Failed to delete user.");
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Deletion Failed"),
        content: const Text("Unable to delete the user. Please try again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundWhite,
      appBar: appBarHelper("settings"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQueryInfo.screenWidth * 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(),
            Text("General Settings", style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold, color: AppStyle.textBlack)),
            const Divider(height: 5),
            SizedBox(height: MediaQueryInfo.screenHeight * 0.03),

            SettingsOptionTile(
              icon: Icons.dark_mode,
              title: "Dark Mode",
              trailing: Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: isDarkTheme,
                  onChanged: (value) {
                    setState(() {
                      isDarkTheme = value;
                    });

                    AppStyle.isDarkThemeNotifier.value = value;

                    Future.delayed(const Duration(milliseconds: 300), () {
                      AppStyle.toggleTheme(value);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {});
                      });
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: MediaQueryInfo.screenHeight * 0.015),

            SettingsOptionTile(
              icon: Icons.straighten,
              title: "Unit Preference",
              trailing: DropdownButton<String>(
                value: selectedUnit,
                items: ['Kg', 'Ltr', 'Pcs']
                    .map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUnit = value!;
                  });
                  _prefs.setString('unit_preference', value!);
                },
                underline: const SizedBox(),
              ),
            ),
            SizedBox(height: MediaQueryInfo.screenHeight * 0.015),

            SettingsOptionTile(
              icon: Icons.attach_money,
              title: "Currency Symbol",
              trailing: DropdownButton<String>(
                value: selectedCurrency,
                items: ['USD \$', 'EUR €', 'INR ₹']
                    .map((currency) => DropdownMenuItem(
                          value: currency,
                          child: Text(currency),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCurrency = value!;
                  });
                  _prefs.setString('currency_preference', value!);
                },
                underline: const SizedBox(),
              ),
            ),

            SizedBox(height: MediaQueryInfo.screenHeight * 0.015),
            const SizedBox(),
            Text("User Settings", style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold, color: AppStyle.textBlack)),
            const Divider(height: 5),
            SizedBox(height: MediaQueryInfo.screenHeight * 0.03),

            
          ],
        ),
      ),
    );
  }
}
