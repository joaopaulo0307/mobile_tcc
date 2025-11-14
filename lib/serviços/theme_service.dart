import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  static const Color primaryColor = Color(0xFF133A67);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardColorLight = Colors.white;
  static const Color cardColorDark = Color(0xFF1E1E1E);
  static const Color textColorLight = Color(0xFF333333);
  static const Color textColorDark = Color(0xFFE0E0E0);

  static final ValueNotifier<bool> themeNotifier = ValueNotifier<bool>(false);

  // Método para alternar o tema
  static void toggleTheme() {
    themeNotifier.value = !themeNotifier.value;
  }

  // Método para definir o modo escuro
  static void setDarkMode(bool isDark) {
    themeNotifier.value = isDark;
  }

  bool get isDarkMode => themeNotifier.value;
}

// ThemeService.dart - Adicione estas funções
class ThemeService2 {
  static Color primaryColor = const Color(0xFF133A67);
  static Color secondaryColor = const Color(0xFFF0E8D5);
  
  // Cores para tema claro
  static Color backgroundLight = const Color(0xFFFFFFFF);
  static Color cardColorLight = const Color(0xFFF8F9FA);
  static Color textColorLight = const Color(0xFF333333);
  
  // Cores para tema escuro
  static Color backgroundDark = const Color(0xFF121212);
  static Color cardColorDark = const Color(0xFF1E1E1E);
  static Color textColorDark = const Color(0xFFFFFFFF);
  
  static ValueNotifier<bool> themeNotifier = ValueNotifier<bool>(false);

  // Método para alterar a cor primária
  static void setPrimaryColor(Color newColor) {
    primaryColor = newColor;
    // Força o rebuild dos widgets que dependem da cor primária
    themeNotifier.value = !themeNotifier.value;
  }

  // Método para definir o modo escuro
  static void setDarkMode(bool isDark) {
    themeNotifier.value = isDark;
  }

  // Método para obter a cor de fundo baseada no tema
  static Color getBackgroundColor(bool isDarkMode) {
    return isDarkMode ? backgroundDark : backgroundLight;
  }

  // Método para obter a cor do card baseada no tema
  static Color getCardColor(bool isDarkMode) {
    return isDarkMode ? cardColorDark : cardColorLight;
  }

  // Método para obter a cor do texto baseada no tema
  static Color getTextColor(bool isDarkMode) {
    return isDarkMode ? textColorDark : textColorLight;
  }
}