import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _key = "themeMode";

  // Save the selected theme mode
  Future<void> saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, themeMode == ThemeMode.dark ? "dark" : "light");
  }

  // Load the saved theme mode
  Future<ThemeMode> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_key) ?? "light";
    return themeString == "dark" ? ThemeMode.dark : ThemeMode.light;
  }
}
