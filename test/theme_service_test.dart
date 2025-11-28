import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tcc/services/theme_service.dart';

void main() {
  group('ThemeService', () {
    late ThemeService themeService;

    setUp(() {
      themeService = ThemeService();
    });

    test('Deve iniciar com modo claro', () {
      expect(themeService.isDarkMode, false);
    });

    test('Deve alternar para modo escuro', () {
      themeService.toggleTheme();
      expect(themeService.isDarkMode, true);
    });

    test('Deve definir modo escuro manualmente', () {
      themeService.setDarkMode(true);
      expect(themeService.isDarkMode, true);
      
      themeService.setDarkMode(false);
      expect(themeService.isDarkMode, false);
    });

    test('Deve notificar listeners quando o tema mudar', () {
      var notified = false;
      themeService.addListener(() => notified = true);
      
      themeService.toggleTheme();
      expect(notified, true);
    });
  });
}