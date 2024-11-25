
import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri phoneUrl = Uri(scheme: 'tel', path: phoneNumber);
  try {
    await launchUrl(phoneUrl);
  } catch (e) {
    log('Error launching phone call: $e');
  }
}
