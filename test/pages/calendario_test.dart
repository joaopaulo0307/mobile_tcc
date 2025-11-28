// test/pages/calendario_page_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_tcc/calendario/calendario.dart';
import 'package:mobile_tcc/services/theme_service.dart';
import 'package:mobile_tcc/services/tarefa_service.dart';

void main() {
  group('CalendarioPage - Testes de Widget', () {
    late ThemeService themeService;
    late TarefaService tarefaService;

    setUp(() {
      themeService = ThemeService();
      tarefaService = TarefaService();
    });

    testWidgets('Deve exibir calendário e elementos principais', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
            ChangeNotifierProvider(create: (_) => tarefaService),
          ],
          child: const MaterialApp(home: CalendarioPage()),
        ),
      );

      expect(find.text('CALENDÁRIO'), findsOneWidget);
      expect(find.byType(TableCalendar), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Deve abrir diálogo para adicionar tarefa', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
            ChangeNotifierProvider(create: (_) => tarefaService),
          ],
          child: const MaterialApp(home: CalendarioPage()),
        ),
      );

      // Clica no FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Deve mostrar diálogo de nova tarefa
      expect(find.text('Nova Tarefa'), findsOneWidget);
      expect(find.text('Título da tarefa *'), findsOneWidget);
      expect(find.text('Descrição (opcional)'), findsOneWidget);
      expect(find.text('Cor da tarefa:'), findsOneWidget);
    });

    testWidgets('Deve validar título obrigatório na tarefa', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
            ChangeNotifierProvider(create: (_) => tarefaService),
          ],
          child: const MaterialApp(home: CalendarioPage()),
        ),
      );

      // Abre diálogo
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Tenta salvar sem título
      await tester.tap(find.text('Salvar Tarefa'));
      await tester.pump();

      // Deve mostrar mensagem de erro
      expect(find.text('Por favor, insira um título para a tarefa'), findsOneWidget);
    });

    testWidgets('Deve selecionar cor para tarefa', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
            ChangeNotifierProvider(create: (_) => tarefaService),
          ],
          child: const MaterialApp(home: CalendarioPage()),
        ),
      );

      // Abre diálogo
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Seleciona uma cor (ajustar índice se necessário)
      final corWidgets = find.byType(GestureDetector);
      await tester.tap(corWidgets.at(8));
      await tester.pump();

      expect(find.text('Por favor, insira um título para a tarefa'), findsNothing);
    });

    testWidgets('Deve navegar entre meses no calendário', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
            ChangeNotifierProvider(create: (_) => tarefaService),
          ],
          child: const MaterialApp(home: CalendarioPage()),
        ),
      );

      final nextButton = find.byIcon(Icons.chevron_right);
      expect(nextButton, findsOneWidget);

      await tester.tap(nextButton);
      await tester.pump();

      expect(find.byType(TableCalendar), findsOneWidget);
    });
  });
}
