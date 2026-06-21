import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _unitKey = 'temperature_unit';
  
  Future<void> saveUnit(bool isCelsius) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_unitKey, isCelsius);
  }
  
  Future<bool> getUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_unitKey) ?? true; // Default to Celsius
  }
  // Add these methods to PreferencesService class

Future<void> saveLastSearchedCity(String city) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('last_searched_city', city);
}

Future<String?> getLastSearchedCity() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('last_searched_city');
}

Future<void> clearLastSearchedCity() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('last_searched_city');
}
}