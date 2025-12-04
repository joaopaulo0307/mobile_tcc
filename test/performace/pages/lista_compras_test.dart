// test/pages/lista_compras_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tcc/lista_compras.dart';

void main() {
  group('ListaCompras - Testes de Interface', () {
    testWidgets('Deve renderizar a tela corretamente e mostrar mensagem inicial',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ListaCompras()),
      );

      expect(find.text('Lista de Compras'), findsOneWidget);
      expect(
        find.text('Não há nenhum produto listado no momento'),
        findsOneWidget,
      );
      expect(find.text('Produtos:'), findsOneWidget);
    });

    testWidgets('Deve abrir o modal ao clicar no botão de adicionar',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ListaCompras()),
      );

      // Clica no FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Listamento'), findsOneWidget);
      expect(find.text('Produto:'), findsOneWidget);
      expect(find.text('Responsável:'), findsOneWidget);
    });

    testWidgets('Deve adicionar um produto à lista', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ListaCompras()),
      );

      // Abre modal
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Preenche campos
      await tester.enterText(
          find.widgetWithText(TextField, 'Produto:'), 'Arroz');
      await tester.enterText(
          find.widgetWithText(TextField, 'Responsável:'), 'Daniel');

      // Botão CRIAR
      await tester.tap(find.text('CRIAR'));
      await tester.pumpAndSettle();

      expect(find.text('Arroz'), findsOneWidget);
      expect(find.text('Responsável: Daniel'), findsOneWidget);
    });

    testWidgets('Deve marcar item como feito', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ListaCompras()),
      );

      // Adiciona item rapidamente sem modal (acessando o state)
      final state =
          tester.state(find.byType(ListaCompras)) as dynamic;
      state.adicionarProduto('Pão', 'Carlos');
      await tester.pump();

      // Ícone de marcar
      final marcador = find.byType(GestureDetector).first;

      expect(
        find.byIcon(Icons.check),
        findsNothing,
      );

      // Marca como feito
      await tester.tap(marcador);
      await tester.pump();

      expect(
        find.byIcon(Icons.check),
        findsOneWidget,
      );
    });

    testWidgets('Deve remover um produto', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ListaCompras()),
      );

      // Adiciona item diretamente
      final state =
          tester.state(find.byType(ListaCompras)) as dynamic;
      state.adicionarProduto('Feijão', 'Ana');
      await tester.pump();

      expect(find.text('Feijão'), findsOneWidget);

      // Aperta o botão de deletar
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(find.text('Feijão'), findsNothing);
      expect(find.text('Não há nenhum produto listado no momento'),
          findsOneWidget);
    });
  });
}
