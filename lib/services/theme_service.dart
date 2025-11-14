import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  // Singleton
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  // Cores
  static const Color primaryColor = Color(0xFF133A67);
  static const Color secondaryColor = Color(0xFF4CAF50);

  // Estado
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // Métodos
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // ThemeData - MÍNIMO FUNCIONAL
  ThemeData get themeData {
    if (_isDarkMode) {
      return ThemeData.dark().copyWith(
        primaryColor: primaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      );
    } else {
      return ThemeData.light().copyWith(
        primaryColor: primaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      );
    }
  }

  // Getters básicos para compatibilidade
  Color get backgroundColor => _isDarkMode ? Colors.black : Colors.white;
  Color get cardColor => _isDarkMode ? Colors.grey[900]! : Colors.white;
  Color get textColor => _isDarkMode ? Colors.white : Colors.black;
}