import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(ThemeMode) toggleTheme;
  final ThemeMode currentTheme;

  SettingsPage({required this.toggleTheme, required this.currentTheme});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.currentTheme == ThemeMode.dark;
  }

  void _onThemeChanged(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
    });

    widget.toggleTheme(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: _onThemeChanged,
            ),
          ],
        ),
      ),
    );
  }
}
