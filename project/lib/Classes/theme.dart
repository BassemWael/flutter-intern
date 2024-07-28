import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme';
  Box _box;
  ThemeData _themeData;

  ThemeProvider(this._box)
      : _themeData = _box.get(_themeKey, defaultValue: false) ? ThemeData.dark() : ThemeData.light();

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData.brightness == Brightness.dark;

  void setTheme(ThemeData themeData) {
    _themeData = themeData;
    _box.put(_themeKey, _themeData.brightness == Brightness.dark);
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData.brightness == Brightness.dark) {
      setTheme(ThemeData.light());
    } else {
      setTheme(ThemeData.dark());
    }
  }
}
