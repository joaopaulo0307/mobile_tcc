import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mobile_tcc/services/theme_service.dart';
import 'package:mobile_tcc/usuarios.dart';

void main() {
  Widget createTestWidget() {
    return ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: const MaterialApp(
        home: Usuarios(),
      ),
    );
  }

  group('Usuarios Page Tests', () {
    testWidgets('Renderiza a página Usuarios corretamente', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Membros'), findsNWidgets(2)); // AppBar + DrawerHeader
    });

    testWidgets('Carrega membros iniciais', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('João Silva'), findsOneWidget);
      expect(find.text('Maria Santos'), findsOneWidget);
    });

    testWidgets('Busca filtra membros corretamente', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Abrir diálogo de pesquisa
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'João');
      await tester.pump();

      expect(find.text('João Silva'), findsOneWidget);
      expect(find.text('Maria Santos'), findsNothing);
    });

    testWidgets('Exibe modal de detalhes do membro ao clicar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.text('João Silva'));
      await tester.pumpAndSettle();

      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Telefone'), findsOneWidget);
      expect(find.text('Descrição'), findsOneWidget);
    });

    testWidgets('Adicionar membro funciona', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Abrir modal de adicionar membro
      await tester.tap(find.text('+ Add Membro'));
      await tester.pumpAndSettle();

      // Inserir novo membro
      await tester.enterText(find.widgetWithText(TextField, 'Nome *'), 'Carlos Teste');
      await tester.pump();

      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      expect(find.text('Carlos Teste'), findsOneWidget);
    });

    testWidgets('Remover membro funciona', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Abrir menu do primeiro membro
      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      // Selecionar excluir
      await tester.tap(find.text('Excluir'));
      await tester.pumpAndSettle();

      // Confirmar remoção
      await tester.tap(find.text('Remover'));
      await tester.pumpAndSettle();

      expect(find.text('João Silva'), findsNothing);
    });

    testWidgets('Drawer abre corretamente', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.text('Administração de Usuários'), findsOneWidget);
      expect(find.text('Meu Perfil'), findsOneWidget);
    });
  });
}
