import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tcc/services/theme_service.dart';

void main() {
  group('ThemeService', () {
    late ThemeService themeService;

    setUp(() {
      themeService = ThemeService();
    });

    test('Deve iniciar com tema claro', () {
      expect(themeService.isDarkMode, false);
    });

    test('Deve alternar entre tema claro e escuro', () {
      // Primeira alternância
      themeService.toggleTheme();
      expect(themeService.isDarkMode, true);
      
      // Segunda alternância
      themeService.toggleTheme();
      expect(themeService.isDarkMode, false);
    });

    test('Deve notificar listeners quando o tema mudar', () {
      var notified = false;
      themeService.addListener(() => notified = true);
      
      themeService.toggleTheme();
      
      expect(notified, true);
    });

    test('Deve parar de notificar listener removido', () {
      var notified = false;
      void listener() => notified = true;
      
      themeService.addListener(listener);
      themeService.removeListener(listener);
      
      themeService.toggleTheme();
      
      expect(notified, false);
    });

    test('Deve lidar com múltiplas alternâncias rápidas', () {
      expect(() {
        for (int i = 0; i < 50; i++) {
          themeService.toggleTheme();
        }
      }, returnsNormally);
    });

    test('Deve manter estado consistente após muitas mudanças', () {
      final initialValue = themeService.isDarkMode;
      
      // Número par de alternâncias deve voltar ao estado inicial
      for (int i = 0; i < 100; i++) {
        themeService.toggleTheme();
      }
      
      expect(themeService.isDarkMode, initialValue);
    });
  });
}