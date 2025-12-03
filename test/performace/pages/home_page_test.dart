import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mobile_tcc/services/theme_service.dart';
import 'package:mobile_tcc/services/formatting_service.dart';
import 'package:mobile_tcc/home.dart';

void main() {
  group('HomePage', () {
    late ThemeService themeService;
    late FormattingService formattingService;

    setUp(() {
      themeService = ThemeService();
      formattingService = FormattingService();
    });

    testWidgets('Deve exibir informações da casa', (WidgetTester tester) async {
      final casa = {'nome': 'Minha Casa', 'id': '1'};
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeService>.value(value: themeService),
            Provider<FormattingService>.value(value: formattingService),
          ],
          child: MaterialApp(home: HomePage(casa: casa)),
        ),
      );

      expect(find.text('Olá Usuário'), findsOneWidget);
    });

    testWidgets('Deve exibir resumo financeiro', (WidgetTester tester) async {
      final casa = {'nome': 'Minha Casa', 'id': '1'};
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeService>.value(value: themeService),
            Provider<FormattingService>.value(value: formattingService),
          ],
          child: MaterialApp(home: HomePage(casa: casa)),
        ),
      );

      expect(find.text('Saldo'), findsOneWidget);
      expect(find.text('Receitas'), findsOneWidget);
      expect(find.text('Despesas'), findsOneWidget);
    });

    testWidgets('Deve abrir drawer quando botão menu for pressionado', (WidgetTester tester) async {
      final casa = {'nome': 'Minha Casa', 'id': '1'};
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeService>.value(value: themeService),
            Provider<FormattingService>.value(value: formattingService),
          ],
          child: MaterialApp(home: HomePage(casa: casa)),
        ),
      );

      // Encontra e pressiona o botão do menu
      final menuButton = find.byIcon(Icons.menu);
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      // Verifica se o drawer foi aberto
      expect(find.text('Econômico'), findsOneWidget);
      expect(find.text('Calendário'), findsOneWidget);
      expect(find.text('Usuários'), findsOneWidget);
    });
  });
}