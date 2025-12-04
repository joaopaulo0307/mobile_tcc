import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mobile_tcc/economic/economico.dart';
import 'package:mobile_tcc/services/theme_service.dart';

void main() {
  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: MaterialApp(
        home: Economico(
          casa: {'nome': 'Casa Teste'},
        ),
      ),
    );
  }

  testWidgets('Economico deve renderizar os cards de resumo', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Saldo'), findsOneWidget);
    expect(find.text('Receitas'), findsOneWidget);
    expect(find.text('Despesas'), findsOneWidget);
  });

  testWidgets('Economico deve calcular valores iniciais corretamente', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Valor inicial da única transação definida no estado
    expect(find.text('R\$2500.00'), findsOneWidget); // Receita
    expect(find.text('R\$2500.00'), findsWidgets);   // Saldo inicial
  });

  testWidgets('Economico deve exibir o gráfico', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // FLChart geralmente vira um CustomPaint
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('Botão de adicionar transação deve abrir o modal', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Abrir modal
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Adicionar Transação'), findsOneWidget);
  });

  testWidgets('Adicionar nova transação atualiza o saldo', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Abrir modal
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Preencher campos
    await tester.enterText(find.byType(TextField).at(0), '100');
    await tester.enterText(find.byType(TextField).at(1), 'Teste de Entrada');

    // Confirmar
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    // Modal de confirmação
    expect(find.text('Transação adicionada!'), findsOneWidget);

    // Fechar modal
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Agora saldo deve incluir +100
    expect(find.textContaining('R\$2600.00'), findsOneWidget);
  });
}
