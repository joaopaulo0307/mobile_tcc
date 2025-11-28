import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tcc/main.dart';
import 'package:mobile_tcc/services/theme_service.dart';
import 'package:mobile_tcc/services/formatting_service.dart';
import 'package:provider/provider.dart';

void main() {
  group('App Integration', () {
    testWidgets('Deve iniciar na LandingPage', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      expect(find.text('LOGIN'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
    });

    testWidgets('Deve navegar para cadastro', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      final cadastrarButton = find.text('CADASTRAR');
      await tester.tap(cadastrarButton);
      await tester.pumpAndSettle();
      
      // Verifica se navegou para a página de cadastro
      expect(find.text('Cadastro'), findsOneWidget);
    });

    testWidgets('Deve validar formulário de login', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Tenta fazer login sem preencher campos
      final entrarButton = find.text('ENTRAR');
      await tester.tap(entrarButton);
      await tester.pump();
      
      // Deve mostrar mensagens de erro
      expect(find.text('Por favor, insira seu email'), findsOneWidget);
    });
  });
}