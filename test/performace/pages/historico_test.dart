import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tcc/economic/historico.dart';
import 'package:mobile_tcc/models/transacao.dart';

void main() {
  group('HistoricoPage - Testes de Interface e Funcionamento', () {
    // 🔧 Função para criar um widget padrão
    Widget criarWidget(List<Transacao> transacoes) {
      return MaterialApp(
        home: HistoricoPage(transacoes: transacoes),
      );
    }

    testWidgets('Deve renderizar a página e mostrar o título HISTÓRICO', (tester) async {
      await tester.pumpWidget(criarWidget([]));

      expect(find.text('HISTÓRICO'), findsOneWidget);
    });

    testWidgets('Deve exibir mensagem quando não há transações', (tester) async {
      await tester.pumpWidget(criarWidget([]));

      expect(find.text('Nenhuma transação no período selecionado'), findsOneWidget);
    });

    testWidgets('Deve exibir transações corretamente', (tester) async {
      final agora = DateTime.now();

      final transacoes = [
        Transacao(
          tipo: 'entrada',
          valor: 50.0,
          data: agora,
          local: "Mercado",
          categoria: "alimentacao", 
        ),
        Transacao(
          tipo: 'saida',
          valor: 20.0,
          data: agora.subtract(const Duration(days: 1)),
          local: "Uber",
        ),
      ];

      await tester.pumpWidget(criarWidget(transacoes));
      await tester.pumpAndSettle();

      // Verifica se aparecem os valores formatados
      expect(find.textContaining('R\$ +50.00'), findsOneWidget);
      expect(find.textContaining('R\$ -20.00'), findsOneWidget);

      // Verifica se aparecem os locais
      expect(find.text('Mercado'), findsOneWidget);
      expect(find.text('Uber'), findsOneWidget);

      // Agrupamento por HOJE e ONTEM
      expect(find.text('Hoje:'), findsOneWidget);
      expect(find.text('Ontem:'), findsOneWidget);
    });

    testWidgets('Deve alterar filtro quando clica nos botões de período (7, 15, 30)', (tester) async {
      final agora = DateTime.now();

      final transacoes = [
        Transacao(
          tipo: 'entrada',
          valor: 100,
          data: agora.subtract(const Duration(days: 10)),
          local: 'Loja',
          categoria: 'outros', 
        )
      ];

      await tester.pumpWidget(criarWidget(transacoes));

      // Começa com 7 dias → transação não deve aparecer
      expect(find.textContaining('R\$'), findsNothing);

      // Clicar em "Últimos 15 dias"
      await tester.tap(find.text("Últimos 15 dias"));
      await tester.pumpAndSettle();

      // Agora deve aparecer
      expect(find.textContaining('R\$'), findsOneWidget);

      // Clicar em "Últimos 30 dias"
      await tester.tap(find.text("Últimos 30 dias"));
      await tester.pumpAndSettle();

      expect(find.textContaining('R\$'), findsOneWidget);
    });

    testWidgets('Deve exibir categoria formatada corretamente', (tester) async {
      final agora = DateTime.now();

      final transacoes = [
        Transacao(
          tipo: 'entrada',
          valor: 30,
          data: agora,
          local: 'Padaria',
          categoria: 'lazer',
        ),
      ];

      await tester.pumpWidget(criarWidget(transacoes));
      await tester.pumpAndSettle();

      expect(find.textContaining('Categoria: Lazer'), findsOneWidget);
    });
  });
}
