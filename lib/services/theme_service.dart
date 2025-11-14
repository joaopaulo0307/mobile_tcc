import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  // Singleton
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  // Cores principais
  static const Color primaryColor = Color(0xFF133A67);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);

  // Cores para tema claro
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Colors.white;
  static const Color cardColorLight = Colors.white;
  static const Color textColorLight = Color(0xFF333333);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color dividerLight = Color(0xFFE0E0E0);

  // Cores para tema escuro
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardColorDark = Color(0xFF1E1E1E);
  static const Color textColorDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFA0A0A0);
  static const Color dividerDark = Color(0xFF333333);

  // Estado
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // Métodos principais
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // Getters utilitários
  Color get backgroundColor => _isDarkMode ? backgroundDark : backgroundLight;
  Color get cardColor => _isDarkMode ? cardColorDark : cardColorLight;
  Color get textColor => _isDarkMode ? textColorDark : textColorLight;
  Color get surfaceColor => _isDarkMode ? surfaceDark : surfaceLight;
  Color get dividerColor => _isDarkMode ? dividerDark : dividerLight;

  // ThemeData
  ThemeData get themeData {
    return _isDarkMode ? _buildDarkTheme() : _buildLightTheme();
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,

      // Esquema de cores principal
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceLight,
        background: backgroundLight,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textColorLight,
        onBackground: textColorLight,
        onError: Colors.white,
      ),

      // Cores específicas
      scaffoldBackgroundColor: backgroundLight,
      cardColor: cardColorLight,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Cards
      cardTheme: const CardTheme(
        color: cardColorLight,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Texto
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textColorLight, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textColorLight, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: textColorLight, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textColorLight, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: textColorLight, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: textColorLight, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textColorLight),
        titleSmall: TextStyle(color: textColorLight),
        bodyLarge: TextStyle(color: textColorLight),
        bodyMedium: TextStyle(color: textColorLight),
        bodySmall: TextStyle(color: textSecondaryLight),
        labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(color: textSecondaryLight),
        labelSmall: TextStyle(color: textSecondaryLight, fontSize: 12),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: dividerLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: dividerLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondaryLight),
        hintStyle: const TextStyle(color: textSecondaryLight),
        errorStyle: const TextStyle(color: errorColor),
      ),

      // Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // Ícones
      iconTheme: const IconThemeData(color: primaryColor),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: dividerLight,
        thickness: 1,
        space: 1,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,

      // Esquema de cores principal
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceDark,
        background: backgroundDark,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textColorDark,
        onBackground: textColorDark,
        onError: Colors.white,
      ),

      // Cores específicas
      scaffoldBackgroundColor: backgroundDark,
      cardColor: cardColorDark,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Cards
      cardTheme: const CardTheme(
        color: cardColorDark,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Texto
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textColorDark, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textColorDark, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: textColorDark, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textColorDark, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: textColorDark, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: textColorDark, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textColorDark),
        titleSmall: TextStyle(color: textColorDark),
        bodyLarge: TextStyle(color: textColorDark),
        bodyMedium: TextStyle(color: textColorDark),
        bodySmall: TextStyle(color: textSecondaryDark),
        labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(color: textSecondaryDark),
        labelSmall: TextStyle(color: textSecondaryDark, fontSize: 12),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark.withOpacity(0.8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: dividerDark, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: dividerDark, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondaryDark),
        hintStyle: const TextStyle(color: textSecondaryDark),
        errorStyle: const TextStyle(color: errorColor),
      ),

      // Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // Ícones
      iconTheme: const IconThemeData(color: textColorDark),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: dividerDark,
        thickness: 1,
        space: 1,
      ),
    );
  }
}