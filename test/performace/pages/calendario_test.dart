import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_tcc/calendario/calendario.dart';
import 'package:mobile_tcc/services/theme_service.dart';
import 'package:mobile_tcc/services/tarefa_service.dart';
import 'package:table_calendar/table_calendar.dart';

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

      await tester.pumpAndSettle();

      // Verifica elementos que realmente existem na tela
      expect(find.text('CALENDÁRIO'), findsOneWidget); // No menu lateral
      expect(find.byType(TableCalendar), findsOneWidget);
      expect(find.text('Hoje'), findsOneWidget); // Botão "Hoje"
      expect(find.text('Tarefas do dia'), findsOneWidget);
      expect(find.text('NOVA TAREFA'), findsOneWidget); // Botão na seção de tarefas
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

      await tester.pumpAndSettle();

      // Clica no botão "NOVA TAREFA" (não tem FloatingActionButton)
      await tester.tap(find.text('NOVA TAREFA'));
      await tester.pumpAndSettle();

      // Verifica elementos do diálogo REAL
      expect(find.textContaining('Tarefa'), findsOneWidget); // "Nova Tarefa" ou "Alteração"
      expect(find.text('Nome:'), findsOneWidget);
      expect(find.text('Descrição:'), findsOneWidget);
      expect(find.text('Data:'), findsOneWidget);
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

      await tester.pumpAndSettle();

      // Abre diálogo
      await tester.tap(find.text('NOVA TAREFA'));
      await tester.pumpAndSettle();

      // Tenta salvar sem título - clica em "CRIAR"
      await tester.tap(find.text('CRIAR'));
      await tester.pump();

      // Deve mostrar SnackBar com mensagem de erro
      expect(find.text('Por favor, insira um nome para a tarefa'), findsOneWidget);
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

      await tester.pumpAndSettle();

      // Encontra botões de navegação do TableCalendar (setas no header)
      final nextButtons = find.byIcon(Icons.chevron_right);
      expect(nextButtons, findsWidgets); // Pode ter mais de um

      // Clica no primeiro botão de próxima página
      await tester.tap(nextButtons.first);
      await tester.pump();

      expect(find.byType(TableCalendar), findsOneWidget);
    });

    testWidgets('Deve exibir menu lateral com itens', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
            ChangeNotifierProvider(create: (_) => tarefaService),
          ],
          child: const MaterialApp(home: CalendarioPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Verifica itens do menu lateral
      expect(find.text('HOME'), findsOneWidget);
      expect(find.text('ECONÓMICO'), findsOneWidget);
      expect(find.text('USUÁRIOS'), findsOneWidget);
      expect(find.text('CALENDÁRIO'), findsOneWidget);
      expect(find.text('MINHAS CASAS'), findsOneWidget);
      expect(find.text('MEU PERFIL'), findsOneWidget);
      expect(find.text('CONFIGURAÇÕES'), findsOneWidget);
    });

    testWidgets('Deve mostrar data formatada no header', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
            ChangeNotifierProvider(create: (_) => tarefaService),
          ],
          child: const MaterialApp(home: CalendarioPage()),
        ),
      );

      await tester.pumpAndSettle();

      // O header mostra data no formato "Dia da semana, dia de Mês de Ano"
      final headerText = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data!.contains(','),
      );
      expect(headerText, findsOneWidget);
    });

    testWidgets('Deve ter campos para editar tarefa no diálogo', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
            ChangeNotifierProvider(create: (_) => tarefaService),
          ],
          child: const MaterialApp(home: CalendarioPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Abre diálogo
      await tester.tap(find.text('NOVA TAREFA'));
      await tester.pumpAndSettle();

      // Verifica campos de entrada
      expect(find.byType(TextField), findsNWidgets(2)); // Título e descrição
      expect(find.text('Digite o nome da tarefa'), findsOneWidget);
      expect(find.text('Digite a descrição da tarefa'), findsOneWidget);
    });

    testWidgets('Deve poder cancelar criação de tarefa', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeService),
            ChangeNotifierProvider(create: (_) => tarefaService),
          ],
          child: const MaterialApp(home: CalendarioPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Abre diálogo
      await tester.tap(find.text('NOVA TAREFA'));
      await tester.pumpAndSettle();

      // Clica em cancelar
      await tester.tap(find.text('CANCELAR'));
      await tester.pumpAndSettle();

      // Diálogo deve fechar
      expect(find.text('CANCELAR'), findsNothing);
    });
  });
}