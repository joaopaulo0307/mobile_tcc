import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  // ============ CORES PRINCIPAIS ============
  static const Color primaryColor = Color(0xFF133A67);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFF2196F3);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color successColor = Color(0xFF4CAF50);

  // ============ CORES PARA TEMA CLARO ============
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Colors.white;
  static const Color cardColorLight = Colors.white;
  static const Color textColorLight = Color(0xFF333333);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color iconColorLight = Color(0xFF666666);

  // ============ CORES PARA TEMA ESCURO ============
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardColorDark = Color(0xFF1E1E1E);
  static const Color textColorDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFA0A0A0);
  static const Color dividerDark = Color(0xFF333333);
  static const Color iconColorDark = Color(0xFFA0A0A0);

  // ============ NOTIFIER E ESTADO ============
  static final ValueNotifier<bool> _themeNotifier = ValueNotifier<bool>(false);

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // ============ CONSTRUTOR ============
  ThemeService() {
    _isDarkMode = _themeNotifier.value;
    
    _themeNotifier.addListener(() {
      _isDarkMode = _themeNotifier.value;
      notifyListeners();
    });
  }

  // ============ GETTER PARA O THEME NOTIFIER ============
  static ValueNotifier<bool> get themeNotifier => _themeNotifier;

  // ============ MÉTODOS PRINCIPAIS ============
  void toggleTheme() {
    _themeNotifier.value = !_themeNotifier.value;
    _isDarkMode = _themeNotifier.value;
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    _themeNotifier.value = isDark;
    _isDarkMode = isDark;
    notifyListeners();
  }

  // ============ MÉTODOS ESTÁTICOS ============
  static void toggleThemeStatic() {
    _themeNotifier.value = !_themeNotifier.value;
  }

  static void setDarkModeStatic(bool isDark) {
    _themeNotifier.value = isDark;
  }

  // ============ MÉTODOS UTILITÁRIOS ============
  Color get backgroundColor {
    return _isDarkMode ? backgroundDark : backgroundLight;
  }

  Color get surfaceColor {
    return _isDarkMode ? surfaceDark : surfaceLight;
  }

  Color get cardColor {
    return _isDarkMode ? cardColorDark : cardColorLight;
  }

  Color get textColor {
    return _isDarkMode ? textColorDark : textColorLight;
  }

  Color get textSecondaryColor {
    return _isDarkMode ? textSecondaryDark : textSecondaryLight;
  }

  Color get dividerColor {
    return _isDarkMode ? dividerDark : dividerLight;
  }

  Color get iconColor {
    return _isDarkMode ? iconColorDark : iconColorLight;
  }

  // ============ THEME DATA COMPLETO ============
  ThemeData get themeData {
    return _isDarkMode ? _buildDarkTheme() : _buildLightTheme();
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundLight,
        surface: surfaceLight,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundLight,
      cardColor: cardColorLight,
      dialogBackgroundColor: surfaceLight,
      dividerColor: dividerLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceLight,
        selectedItemColor: primaryColor,
        unselectedItemColor: iconColorLight,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textColorLight),
        bodyMedium: TextStyle(color: textColorLight),
        titleLarge: TextStyle(color: textColorLight),
        titleMedium: TextStyle(color: textColorLight),
      ),
      iconTheme: const IconThemeData(color: iconColorLight),
        cardTheme: CardTheme(
          color: cardColorLight,
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: dividerLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: dividerLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundDark,
        surface: surfaceDark,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundDark,
      cardColor: cardColorDark,
      dialogBackgroundColor: surfaceDark,
      dividerColor: dividerDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: primaryColor,
        unselectedItemColor: iconColorDark,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textColorDark),
        bodyMedium: TextStyle(color: textColorDark),
        titleLarge: TextStyle(color: textColorDark),
        titleMedium: TextStyle(color: textColorDark),
      ),
      iconTheme: const IconThemeData(color: iconColorDark),
      cardTheme: CardTheme(
        color: cardColorDark,
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: dividerDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: dividerDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// CLASSE SIMPLIFICADA PARA MÉTODOS ESTÁTICOS
class ThemeHelper {
  static Color get primaryColor => ThemeService.primaryColor;
  static Color get secondaryColor => ThemeService.secondaryColor;
  static Color get backgroundLight => ThemeService.backgroundLight;
  static Color get backgroundDark => ThemeService.backgroundDark;
  static Color get cardColorLight => ThemeService.cardColorLight;
  static Color get cardColorDark => ThemeService.cardColorDark;
  static Color get textColorLight => ThemeService.textColorLight;
  static Color get textColorDark => ThemeService.textColorDark;

  static ValueNotifier<bool> get themeNotifier => ThemeService.themeNotifier;

  static Color getBackgroundColor(bool isDarkMode) {
    return isDarkMode ? backgroundDark : backgroundLight;
  }

  static Color getCardColor(bool isDarkMode) {
    return isDarkMode ? cardColorDark : cardColorLight;
  }

  static Color getTextColor(bool isDarkMode) {
    return isDarkMode ? textColorDark : textColorLight;
  }

  static void toggleTheme() {
    ThemeService.themeNotifier.value = !ThemeService.themeNotifier.value;
  }

  static void setDarkMode(bool isDark) {
    ThemeService.themeNotifier.value = isDark;
  }
}