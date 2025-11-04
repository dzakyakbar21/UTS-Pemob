import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  void toggle() {
    _mode = (_mode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
