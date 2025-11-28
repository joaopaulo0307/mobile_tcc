import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mobile_tcc/services/theme_service.dart';
import 'package:mobile_tcc/config.dart';

void main() {
  group('ConfigPage', () {
    late ThemeService themeService;

    setUp(() {
      themeService = ThemeService();
    });

    testWidgets('Deve exibir título Configurações', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeService>.value(
          value: themeService,
          child: const MaterialApp(home: ConfigPage()),
        ),
      );

      expect(find.text('Configurações'), findsOneWidget);
    });

    testWidgets('Deve exibir seções principais', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeService>.value(
          value: themeService,
          child: const MaterialApp(home: ConfigPage()),
        ),
      );

      expect(find.text('Preferências'), findsOneWidget);
      expect(find.text('Privacidade & Segurança'), findsOneWidget);
      expect(find.text('Sobre'), findsOneWidget);
    });

    testWidgets('Deve alternar tema quando botão for pressionado', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeService>.value(
          value: themeService,
          child: const MaterialApp(home: ConfigPage()),
        ),
      );

      // Verifica tema inicial
      expect(themeService.isDarkMode, false);

      // Encontra e pressiona o botão de alternar tema
      final toggleButton = find.text('ALTERNAR TEMA AGORA');
      await tester.tap(toggleButton);
      await tester.pump();

      // Verifica se o tema foi alterado
      expect(themeService.isDarkMode, true);
    });

    testWidgets('Deve exibir switches de configurações', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeService>.value(
          value: themeService,
          child: const MaterialApp(home: ConfigPage()),
        ),
      );

      expect(find.byType(Switch), findsNWidgets(4)); // Tema, Notificações, Biometria, Sincronização
    });
  });
}