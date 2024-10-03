import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'stock_search_page.dart';   // Ensure StockSearchPage is imported
import 'theme_manager.dart';       // For managing the theme persistence
import 'settings_page.dart';       // For settings page

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are loaded before SharedPreferences
  final themeMode = await ThemeManager().loadTheme();
  runApp(StockApp(themeMode: themeMode));
}

class StockApp extends StatefulWidget {
  final ThemeMode themeMode;

  StockApp({required this.themeMode});

  @override
  _StockAppState createState() => _StockAppState();
}

class _StockAppState extends State<StockApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.themeMode;
  }

  // Function to toggle the theme
  void _toggleTheme(ThemeMode newTheme) async {
    setState(() {
      _themeMode = newTheme;
    });
    await ThemeManager().saveTheme(newTheme);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Price Chart',
      theme: ThemeData.light(),  // Light theme
      darkTheme: ThemeData.dark(),  // Dark theme
      themeMode: _themeMode, // Set the initial theme mode
      home: StockSearchPage(toggleTheme: _toggleTheme), // Pass theme toggle function here
      routes: {
        '/settings': (context) => SettingsPage(toggleTheme: _toggleTheme, currentTheme: _themeMode),
      },
    );
  }
}
