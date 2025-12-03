// test/pages/cadastro_page_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mobile_tcc/acesso/cadastro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockNavigatorObserver extends NavigatorObserver {
  bool didPopCalled = false;

  @override
  void didPop(Route route, Route? previousRoute) {
    didPopCalled = true;
    super.didPop(route, previousRoute);
  }
}


void main() {
  group('CadastroPage - Testes de Widget', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Deve exibir todos os campos do formulário', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      expect(find.text('CADASTRO'), findsOneWidget);
      expect(find.text('Nome completo'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Confirmar senha'), findsOneWidget);
      expect(find.text('CADASTRAR'), findsOneWidget);
      expect(find.text('Já tem uma conta?'), findsOneWidget);
    });

    testWidgets('Deve validar campos obrigatórios', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      // Tenta cadastrar sem preencher campos
      await tester.tap(find.text('CADASTRAR'));
      await tester.pump();

      // Deve mostrar mensagens de erro
      expect(find.text('Por favor, insira seu nome completo'), findsOneWidget);
    });

    testWidgets('Deve validar formato de email', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      // Encontra campo de email pela posição na árvore de widgets
      final emailFields = find.byType(TextFormField);
      await tester.enterText(emailFields.at(1), 'email-invalido'); // Email é o segundo campo
      await tester.tap(find.text('CADASTRAR'));
      await tester.pump();

      expect(find.text('Por favor, insira um email válido'), findsOneWidget);
    });

    testWidgets('Deve validar senha mínima', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      // Encontra campo de senha pela posição
      final senhaFields = find.byType(TextFormField);
      await tester.enterText(senhaFields.at(2), '123'); // Senha é o terceiro campo
      await tester.tap(find.text('CADASTRAR'));
      await tester.pump();

      expect(find.text('A senha deve ter pelo menos 6 caracteres'), findsOneWidget);
    });

    testWidgets('Deve validar confirmação de senha', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      // Encontra campos pela posição
      final campos = find.byType(TextFormField);
      await tester.enterText(campos.at(2), '123456'); // Campo de senha
      await tester.enterText(campos.at(3), '654321'); // Campo de confirmar senha
      await tester.tap(find.text('CADASTRAR'));
      await tester.pump();

      expect(find.text('As senhas não coincidem'), findsOneWidget);
    });

    testWidgets('Deve alternar visibilidade da senha', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      // Encontra botões de visibilidade pelos ícones
      final visibilityButtons = find.byIcon(Icons.visibility);
      expect(visibilityButtons, findsNWidgets(2)); // Um para cada campo de senha

      // Clica no primeiro botão
      await tester.tap(visibilityButtons.first);
      await tester.pump();

      // Deve mudar o ícone
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('Deve navegar de volta ao pressionar voltar', (WidgetTester tester) async {
      final navigatorObserver = MockNavigatorObserver();
      
      await tester.pumpWidget(
        MaterialApp(
          home: const CadastroPage(),
          navigatorObservers: [navigatorObserver],
        ),
      );

      // Clica no botão voltar
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verifica se navegou para trás
      expect(navigatorObserver.didPop, true);
    });

    testWidgets('Deve preencher formulário corretamente', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      // Encontra todos os campos
      final campos = find.byType(TextFormField);
      
      // Preenche todos os campos corretamente
      await tester.enterText(campos.at(0), 'João Silva');        // Nome completo
      await tester.enterText(campos.at(1), 'joao@email.com');   // Email
      await tester.enterText(campos.at(2), '123456');           // Senha
      await tester.enterText(campos.at(3), '123456');           // Confirmar senha

      // Tenta cadastrar
      await tester.tap(find.text('CADASTRAR'));
      await tester.pump();

      // Não deve mostrar mensagens de erro
      expect(find.text('Por favor, insira seu nome completo'), findsNothing);
      expect(find.text('Por favor, insira um email válido'), findsNothing);
      expect(find.text('A senha deve ter pelo menos 6 caracteres'), findsNothing);
      expect(find.text('As senhas não coincidem'), findsNothing);
    });

    testWidgets('Deve encontrar link para login', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      expect(find.text('Já tem uma conta?'), findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('Deve encontrar todos os TextFormFields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      // Verifica se existem 4 campos de texto (nome, email, senha, confirmar senha)
      final campos = find.byType(TextFormField);
      expect(campos, findsNWidgets(4));
    });
  });
}