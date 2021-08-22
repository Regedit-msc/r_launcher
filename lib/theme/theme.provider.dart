import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  final String key = "theme";
  bool _lightTheme = true;

  get lighttheme => _lightTheme;

  void toggleTheme() {
    _lightTheme = !_lightTheme;

    /// TODO: _saveToPrefs();
    notifyListeners();
  }
}
