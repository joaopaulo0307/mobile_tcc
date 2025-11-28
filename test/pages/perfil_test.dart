// test/pages/perfil_page_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_tcc/perfil.dart';
import 'package:mobile_tcc/services/user_service.dart';
import 'package:mobile_tcc/services/theme_service.dart';

void main() {
  group('PerfilPage - Testes de Widget', () {
    late ThemeService themeService;
    late UserService userService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await UserService.initialize();
      themeService = ThemeService();
    });

    testWidgets('Deve exibir informações do usuário', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
          ],
          child: const MaterialApp(home: PerfilPage()),
        ),
      );

      expect(find.text('MEU PERFIL'), findsOneWidget);
      expect(find.text(UserService.userName), findsOneWidget);
      expect(find.text(UserService.userEmail), findsOneWidget);
      expect(find.text('Gerenciar sua conta'), findsOneWidget);
    });

    testWidgets('Deve exibir estatísticas', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
          ],
          child: const MaterialApp(home: PerfilPage()),
        ),
      );

      expect(find.text('Tarefas Concluídas'), findsOneWidget);
      expect(find.text('Dias Ativo'), findsOneWidget);
      expect(find.text('Pontos'), findsOneWidget);
    });

    testWidgets('Deve exibir seções informativas', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
          ],
          child: const MaterialApp(home: PerfilPage()),
        ),
      );

      expect(find.text('Sobre'), findsOneWidget);
      expect(find.text('Tarefas Realizadas'), findsOneWidget);
      expect(find.text('Descrição Pessoal'), findsOneWidget);
      expect(find.text('Personalização'), findsOneWidget);
    });

    testWidgets('Deve expandir/contrair lista de tarefas', (WidgetTester tester) async {
      // Adiciona várias tarefas para testar
      await UserService.setTarefasRealizadas([
        'Tarefa 1', 'Tarefa 2', 'Tarefa 3', 'Tarefa 4', 'Tarefa 5'
      ]);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
          ],
          child: const MaterialApp(home: PerfilPage()),
        ),
      );

      // Deve mostrar botão "Mostrar mais"
      expect(find.text('Mostrar mais'), findsOneWidget);

      // Clica para expandir
      await tester.tap(find.text('Mostrar mais'));
      await tester.pump();

      // Deve mostrar botão "Mostrar menos"
      expect(find.text('Mostrar menos'), findsOneWidget);
    });

    testWidgets('Deve exibir diálogo de seleção de cores', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
          ],
          child: const MaterialApp(home: PerfilPage()),
        ),
      );

      // Clica no botão de paleta
      await tester.tap(find.byIcon(Icons.palette));
      await tester.pumpAndSettle();

      // Deve mostrar diálogo de cores
      expect(find.text('Escolha uma cor para o tema'), findsOneWidget);
    });
  });
}