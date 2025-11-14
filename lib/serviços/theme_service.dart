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

  // Método para inicializar (se necessário)
  static Future<void> initialize() async {
    // Aqui você pode carregar a preferência do tema do storage
    // Por enquanto, vamos deixar false como padrão
    themeNotifier.value = false;
  }

  // Getter para verificar se está no modo escuro
  static bool get isDarkMode => themeNotifier.value;

  // Método para alternar o tema
  static void toggleTheme() {
    themeNotifier.value = !themeNotifier.value;
  }
}