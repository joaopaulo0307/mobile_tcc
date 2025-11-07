import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'app_theme';
  
  static bool _isDarkMode = false;
  static bool get isDarkMode => _isDarkMode;

  static final ValueNotifier<bool> themeNotifier = ValueNotifier<bool>(_isDarkMode);

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    themeNotifier.value = _isDarkMode;
  }

  static Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    themeNotifier.value = _isDarkMode;
  }

  static Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    themeNotifier.value = _isDarkMode;
  }

  // Cores para modo claro
  static const Color primaryColor = Color(0xFF133A67);
  static const Color secondaryColor = Color(0xFF5E83AE);
  static const Color backgroundLight = Color(0xFFF0F2F5);
  static const Color cardColorLight = Colors.white;
  static const Color textColorLight = Color(0xFF333333);
  static const Color secondaryTextLight = Color(0xFF666666);

  // Cores para modo escuro
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardColorDark = Color(0xFF1E1E1E);
  static const Color textColorDark = Color(0xFFE0E0E0);
  static const Color secondaryTextDark = Color(0xFFAAAAAA);
}