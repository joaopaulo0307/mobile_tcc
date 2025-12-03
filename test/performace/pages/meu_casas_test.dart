import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tcc/pages/meu_casas_test.dart';
import 'package:provider/provider.dart';
import 'package:mobile_tcc/services/theme_service.dart';

/// Mock simples do ThemeService
class MockThemeService extends ChangeNotifier implements ThemeService {
  @override
  bool isDarkMode = false;

  @override
  Color get backgroundColor => Colors.white;

  @override
  Color get cardColor => Colors.white;

  @override
  Color get textColor => Colors.black;

  static @override
  Color primaryColor = const Color(0xFF133A67);

  @override
  void toggleTheme() {}
}

Widget createTestWidget(Widget child) {
  return ChangeNotifierProvider<ThemeService>.value(
    value: MockThemeService(),
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  group('MeuCasas - Testes de Widget', () {
    testWidgets('Deve renderizar título e botão +', (tester) async {
      await tester.pumpWidget(createTestWidget(const MeuCasas()));

      expect(find.text('MINHAS CASAS'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Deve mostrar empty state quando não há casas', (tester) async {
      await tester.pumpWidget(createTestWidget(const MeuCasas()));

      expect(find.text('Nenhuma casa cadastrada'), findsOneWidget);
      expect(find.text('Toque no botão + para criar sua primeira casa'),
          findsOneWidget);
    });

    testWidgets('Deve abrir o diálogo ao clicar no botão +', (tester) async {
      await tester.pumpWidget(createTestWidget(const MeuCasas()));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Criar Nova Casa'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Deve mostrar erro quando tentar criar sem nome',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const MeuCasas()));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Criar'));
      await tester.pump();

      expect(find.text('Por favor, insira um nome para a casa'), findsOneWidget);
    });

    testWidgets('Deve criar uma nova casa corretamente', (tester) async {
      await tester.pumpWidget(createTestWidget(const MeuCasas()));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Casa Teste');
      await tester.tap(find.text('Criar'));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Casa "Casa Teste" criada com sucesso!'), findsOneWidget);
    });

    testWidgets('Não deve permitir casas com nomes duplicados', (tester) async {
      await tester.pumpWidget(createTestWidget(const MeuCasas()));

      // Criação 1
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Casa A');
      await tester.tap(find.text('Criar'));
      await tester.pumpAndSettle();

      // Tenta duplicar
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Casa A');
      await tester.tap(find.text('Criar'));
      await tester.pump();

      expect(find.text('Já existe uma casa com este nome'), findsOneWidget);
    });

    testWidgets('Lista deve mostrar casas criadas', (tester) async {
      await tester.pumpWidget(createTestWidget(const MeuCasas()));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Casa Nova');
      await tester.tap(find.text('Criar'));
      await tester.pumpAndSettle();

      expect(find.text('Residencias:'), findsOneWidget);
      expect(find.text('Casa Nova'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });
  });
}
