// test/pages/cadastro_page_test.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tcc/acesso/cadastro.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ---------------------------------------------------------------------------
/// MOCK DE IMAGENS (necessário porque a tela usa Image.asset)
/// ---------------------------------------------------------------------------

void registerMockImages() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fakeImage = Uint8List.fromList([0, 0, 0, 0]);

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', (message) async {
    return fakeImage.buffer.asByteData();
  });
}

/// ---------------------------------------------------------------------------
/// Mock do NavigatorObserver
/// ---------------------------------------------------------------------------

class MockNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route<dynamic>? previousRoute) {
    pushedRoutes.removeLast();
    super.didPop(route, previousRoute);
  }
}

/// ---------------------------------------------------------------------------
/// TESTES
/// ---------------------------------------------------------------------------

void main() {
  setUpAll(() {
    registerMockImages();
  });

  group('CadastroPage - Testes de Widget', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Deve exibir todos os campos do formulário', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      expect(find.text('CADASTRO'), findsOneWidget);
      expect(find.text('Nome completo'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Confirmar senha'), findsOneWidget);
      expect(find.text('CADASTRAR'), findsOneWidget);
      expect(find.text('Já tem uma conta?'), findsOneWidget);
    });

    testWidgets('Deve validar campos obrigatórios', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      await tester.tap(find.byKey(const Key('botao_cadastrar')));
      await tester.pump();

      expect(find.textContaining('insira seu nome'), findsOneWidget);
    });

    testWidgets('Deve validar email inválido', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      await tester.enterText(find.byKey(const Key('email_field')), 'email-invalido');
      await tester.tap(find.byKey(const Key('botao_cadastrar')));
      await tester.pump();

      expect(find.textContaining('email válido'), findsOneWidget);
    });

    testWidgets('Deve validar senha mínima', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      await tester.enterText(find.byKey(const Key('senha_field')), '123');
      await tester.tap(find.byKey(const Key('botao_cadastrar')));
      await tester.pump();

      expect(find.textContaining('pelo menos 6 caracteres'), findsOneWidget);
    });

    testWidgets('Deve validar confirmação de senha', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      await tester.enterText(find.byKey(const Key('senha_field')), '123456');
      await tester.enterText(find.byKey(const Key('confirmar_senha_field')), '654321');
      await tester.tap(find.byKey(const Key('botao_cadastrar')));
      await tester.pump();

      expect(find.textContaining('não coincidem'), findsOneWidget);
    });

    testWidgets('Deve alternar visibilidade da senha', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      final button = find.byKey(const Key('senha_visibility'));

      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('Deve alternar visibilidade da confirmação', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      final button = find.byKey(const Key('confirmar_visibility'));

      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('Deve navegar ao clicar no botão voltar', (tester) async {
      final observer = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: const CadastroPage(),
          navigatorObservers: [observer],
        ),
      );

      final backButton = find.byKey(const Key('botao_voltar'));
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(observer.pushedRoutes.length, 0); // voltou para trás
    });

    testWidgets('Formulário completo não deve mostrar erros', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      await tester.enterText(find.byKey(const Key('nome_field')), 'João Silva');
      await tester.enterText(find.byKey(const Key('email_field')), 'joao@email.com');
      await tester.enterText(find.byKey(const Key('senha_field')), '123456');
      await tester.enterText(find.byKey(const Key('confirmar_senha_field')), '123456');

      await tester.tap(find.byKey(const Key('botao_cadastrar')));
      await tester.pump();

      expect(find.textContaining('insira seu nome'), findsNothing);
      expect(find.textContaining('email válido'), findsNothing);
      expect(find.textContaining('6 caracteres'), findsNothing);
      expect(find.textContaining('não coincidem'), findsNothing);
    });

    testWidgets('Todas as Keys devem existir', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      expect(find.byKey(const Key('nome_field')), findsOneWidget);
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('senha_field')), findsOneWidget);
      expect(find.byKey(const Key('confirmar_senha_field')), findsOneWidget);
      expect(find.byKey(const Key('senha_visibility')), findsOneWidget);
      expect(find.byKey(const Key('confirmar_visibility')), findsOneWidget);
      expect(find.byKey(const Key('botao_cadastrar')), findsOneWidget);
      expect(find.byKey(const Key('botao_voltar')), findsOneWidget);
    });

    testWidgets('Deve exibir loading ao cadastrar', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      await tester.enterText(find.byKey(const Key('nome_field')), 'João Silva');
      await tester.enterText(find.byKey(const Key('email_field')), 'joao@email.com');
      await tester.enterText(find.byKey(const Key('senha_field')), '123456');
      await tester.enterText(find.byKey(const Key('confirmar_senha_field')), '123456');

      await tester.tap(find.byKey(const Key('botao_cadastrar')));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Deve encontrar link para login', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      expect(find.text('Já tem uma conta?'), findsOneWidget);
      expect(find.text('Faça login'), findsOneWidget);
    });

    testWidgets('Deve encontrar os 4 TextFormFields', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

      expect(find.byType(TextFormField), findsNWidgets(4));
    });
  });
}
