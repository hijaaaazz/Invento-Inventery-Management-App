import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const _unitKey = "unit_preference";
  static const _currencyKey = "currency_preference";

  static Future<String> get symbol async {
    final currency = await getCurrencyPreference();
    return _getCurrencySymbolFromCode(currency ?? "INR");
  }

  static String _getCurrencySymbolFromCode(String currency) {
    switch (currency) {
      case 'INR ₹':
        return '₹';
      case 'USD \$':
        return '\$';
      case 'EUR €':
        return '€';
      default:
        return '₹'; 
    }
  }

  static Future<void> saveUnitPreference(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitKey, unit);
  }

  static Future<String?> getUnitPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_unitKey) ?? "Pcs"; // Default to "Pcs"
  }

  // Save currency preference
  static Future<void> saveCurrencyPreference(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency);
  }

  // Get currency preference
  static Future<String?> getCurrencyPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey) ?? "INR ₹"; // Default to "INR"
  }

  
}
