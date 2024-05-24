import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../variables/language.dart';


final themeProvider = ChangeNotifierProvider<ThemeNotifier>(
      (ref) => themeNotifier,
);

ThemeNotifier? _themeNotifier;

ThemeNotifier get themeNotifier {
  _themeNotifier ??= ThemeNotifier();
  return _themeNotifier!;
}

class ThemeNotifier with ChangeNotifier {
  String currentTheme = 'system';

  ThemeMode get themeMode {
    if (currentTheme == 'light') {
      return ThemeMode.light;
    } else if (currentTheme == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  changeTheme(String theme) async {
    currentTheme = theme;
    final SharedPreferences prefs= await SharedPreferences.getInstance();
    await prefs.setString(PrefKeys.theme, theme);
    notifyListeners();
  }
  initialize() async {
    final SharedPreferences prefs= await SharedPreferences.getInstance();
    currentTheme = prefs.getString(PrefKeys.theme) ?? 'system';
    notifyListeners();
  }
}
