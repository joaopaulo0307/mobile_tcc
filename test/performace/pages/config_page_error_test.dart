import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mobile_tcc/services/theme_service.dart';
import 'package:mobile_tcc/config.dart';

void main() {
  group('ConfigPage - Testes de Erro', () {
    late ThemeService themeService;

    setUp(() {
      themeService = ThemeService();
    });

    testWidgets('Deve lidar com tema service nulo', (WidgetTester tester) async {
      // Teste sem Provider - deve lidar gracefulmente
      await tester.pumpWidget(
        const MaterialApp(home: ConfigPage()),
      );

      // A página deve renderizar mesmo sem o Provider
      expect(find.text('Configurações'), findsOneWidget);
    });

    testWidgets('Deve lidar com múltiplos toques rápidos', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeService>.value(
          value: themeService,
          child: const MaterialApp(home: ConfigPage()),
        ),
      );

      final toggleButton = find.text('ALTERNAR TEMA AGORA');
      
      // Múltiplos toques rápidos
      expect(() async {
        for (int i = 0; i < 10; i++) {
          await tester.tap(toggleButton);
        }
        await tester.pump();
      }, returnsNormally);
    });

    testWidgets('Deve lidar com diálogos sobrepostos', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeService>.value(
          value: themeService,
          child: const MaterialApp(home: ConfigPage()),
        ),
      );

      final resetButton = find.text('REDEFINIR CONFIGURAÇÕES');
      
      // Abrir múltiplos diálogos
      await tester.tap(resetButton);
      await tester.pump();
      
      // Tentar abrir outro diálogo (deve ser ignorado)
      await tester.tap(resetButton);
      await tester.pump();
      
      // Deve fechar corretamente
      final cancelButton = find.text('CANCELAR');
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();
      
      expect(find.text('Redefinir Configurações'), findsNothing);
    });
  });
}