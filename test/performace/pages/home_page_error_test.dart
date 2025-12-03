import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mobile_tcc/services/theme_service.dart';
import 'package:mobile_tcc/services/formatting_service.dart';
import 'package:mobile_tcc/home.dart';

void main() {
  group('HomePage - Testes de Casos Extremos', () {
    late ThemeService themeService;
    late FormattingService formattingService;

    setUp(() {
      themeService = ThemeService();
      formattingService = FormattingService();
    });

    testWidgets('Deve lidar com casa sem nome', (WidgetTester tester) async {
      final casaVazia = <String, String>{};
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeService>.value(value: themeService),
            Provider<FormattingService>.value(value: formattingService),
          ],
          child: MaterialApp(home: HomePage(casa: casaVazia)),
        ),
      );

      // Deve mostrar valor padrão
      expect(find.text('Minha Casa'), findsOneWidget);
    });

    testWidgets('Deve lidar com dados de casa nulos', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeService>.value(value: themeService),
            Provider<FormattingService>.value(value: formattingService),
          ],
          child: MaterialApp(
            home: HomePage(
              casa: {'nome': null, 'id': null} as Map<String, String>,
            ),
          ),
        ),
      );

      // Não deve quebrar, deve mostrar valores padrão
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Deve lidar com navegação rápida no drawer', (WidgetTester tester) async {
      final casa = {'nome': 'Teste', 'id': '1'};
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeService>.value(value: themeService),
            Provider<FormattingService>.value(value: formattingService),
          ],
          child: MaterialApp(home: HomePage(casa: casa)),
        ),
      );

      // Abrir drawer
      final menuButton = find.byIcon(Icons.menu);
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      // Navegação rápida entre itens
      final usuariosItem = find.text('Usuários');
      final perfilItem = find.text('Meu Perfil');
      
      await tester.tap(usuariosItem);
      await tester.tap(perfilItem); // Antes da navegação completar
      await tester.pumpAndSettle();

      // Deve navegar para uma das páginas sem quebrar
      expect(find.byType(HomePage), findsNothing);
    });
  });
}