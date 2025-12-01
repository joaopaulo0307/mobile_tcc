import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_tcc/acesso/cadastro.dart';

void main() {
  late MockFirebaseAuth mockAuth;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock para carregar assets durante o teste
    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (message) async => Uint8List(0).buffer.asByteData(),
    );
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
  });

  Widget createWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  testWidgets('Deve encontrar todos os campos e botão de cadastro',
      (WidgetTester tester) async {

    await tester.pumpWidget(
      createWidget(CadastroPage(auth: mockAuth)),
    );

    expect(find.byKey(const Key('usernameField')), findsOneWidget);
    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
    expect(find.byKey(const Key('confirmPasswordField')), findsOneWidget);
    expect(find.byKey(const Key('signupButton')), findsOneWidget);
  });

  testWidgets('Deve preencher campos e criar usuário com Firebase',
      (WidgetTester tester) async {

    await tester.pumpWidget(
      createWidget(CadastroPage(auth: mockAuth)),
    );

    await tester.enterText(find.byKey(const Key('usernameField')), 'usuario123');
    await tester.enterText(find.byKey(const Key('emailField')), 'user@test.com');
    await tester.enterText(find.byKey(const Key('passwordField')), '123456');
    await tester.enterText(find.byKey(const Key('confirmPasswordField')), '123456');

    await tester.tap(find.byKey(const Key('signupButton')));
    await tester.pump();

    final userCred = await mockAuth.createUserWithEmailAndPassword(
      email: 'user@test.com',
      password: '123456',
    );

    expect(userCred.user, isA<User>());
  });

  testWidgets('Deve falhar se o Firebase retornar erro',
      (WidgetTester tester) async {

    mockAuth = MockFirebaseAuth(
      authExceptions: AuthExceptions(
        createUserWithEmailAndPassword: FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Email já cadastrado',
        ),
      ),
    );

    await tester.pumpWidget(
      createWidget(CadastroPage(auth: mockAuth)),
    );

    await tester.enterText(find.byKey(const Key('usernameField')), 'usuario123');
    await tester.enterText(find.byKey(const Key('emailField')), 'user@test.com');
    await tester.enterText(find.byKey(const Key('passwordField')), '123456');
    await tester.enterText(find.byKey(const Key('confirmPasswordField')), '123456');

    await tester.tap(find.byKey(const Key('signupButton')));
    await tester.pump();

    expect(
      () async {
        await mockAuth.createUserWithEmailAndPassword(
          email: 'user@test.com',
          password: '123456',
        );
      },
      throwsA(isA<FirebaseAuthException>()),
    );
  });
}
