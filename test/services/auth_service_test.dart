// test/services/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_tcc/acesso/auth_service.dart';

void main() {
  group('AuthService - Testes de Sucesso', () {
    setUp(() async {
      // Configurar SharedPreferences para teste
      SharedPreferences.setMockInitialValues({});
      await AuthService.initialize();
    });

    test('Deve inicializar corretamente sem token', () async {
      expect(AuthService.token, isNull);
    });

    test('Deve cadastrar usuário com sucesso', () async {
      final result = await AuthService.cadastrar(
        nome: 'João Silva',
        email: 'joao@teste.com',
        senha: '123456',
      );

      expect(result['success'], true);
      expect(result['message'], contains('sucesso'));
      expect(result['user'], isNotNull);
      expect(result['user']['nome'], 'João Silva');
    });

    test('Deve fazer login com sucesso', () async {
      // Primeiro cadastra
      await AuthService.cadastrar(
        nome: 'Maria Santos',
        email: 'maria@teste.com',
        senha: '123456',
      );

      // Depois faz login
      final result = await AuthService.login(
        email: 'maria@teste.com',
        senha: '123456',
      );

      expect(result['success'], true);
      expect(result['user']['nome'], 'Maria Santos');
      expect(AuthService.token, isNotNull);
    });

    test('Deve recuperar senha com email cadastrado', () async {
      await AuthService.cadastrar(
        nome: 'Teste',
        email: 'teste@recuperacao.com',
        senha: '123456',
      );

      final result = await AuthService.esqueciSenha('teste@recuperacao.com');
      
      expect(result['success'], true);
      expect(result['message'], contains('enviadas'));
    });

    test('Deve verificar autenticação após login', () async {
      await AuthService.cadastrar(
        nome: 'Auth Test',
        email: 'auth@test.com',
        senha: '123456',
      );

      await AuthService.login(
        email: 'auth@test.com',
        senha: '123456',
      );

      final autenticado = await AuthService.isAuthenticated();
      expect(autenticado, true);
    });

    test('Deve fazer logout corretamente', () async {
      await AuthService.login(
        email: 'maria@teste.com',
        senha: '123456',
      );

      await AuthService.logout();
      final autenticado = await AuthService.isAuthenticated();
      
      expect(autenticado, false);
      expect(AuthService.token, isNull);
    });
  });

  group('AuthService - Testes de Falha/Erro', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await AuthService.initialize();
    });

    test('Deve falhar ao cadastrar email duplicado', () async {
      // Primeiro cadastro
      await AuthService.cadastrar(
        nome: 'Usuario',
        email: 'duplicado@teste.com',
        senha: '123456',
      );

      // Segundo cadastro com mesmo email
      final result = await AuthService.cadastrar(
        nome: 'Outro Usuario',
        email: 'duplicado@teste.com',
        senha: '654321',
      );

      expect(result['success'], false);
      expect(result['message'], contains('já está cadastrado'));
    });

    test('Deve falhar login com usuário não cadastrado', () async {
      final result = await AuthService.login(
        email: 'naoexiste@teste.com',
        senha: '123456',
      );

      expect(result['success'], false);
      expect(result['message'], contains('não encontrado'));
    });

    test('Deve falhar login com senha incorreta', () async {
      await AuthService.cadastrar(
        nome: 'Teste Senha',
        email: 'senha@teste.com',
        senha: '123456',
      );

      final result = await AuthService.login(
        email: 'senha@teste.com',
        senha: 'senhaincorreta',
      );

      expect(result['success'], false);
      expect(result['message'], contains('Senha incorreta'));
    });

    test('Deve falhar recuperação com email não cadastrado', () async {
      final result = await AuthService.esqueciSenha('naocadastrado@teste.com');
      
      expect(result['success'], false);
      expect(result['message'], contains('não cadastrado'));
    });

    test('Deve retornar falso para usuário não autenticado', () async {
      await AuthService.logout(); // Garante logout
      final autenticado = await AuthService.isAuthenticated();
      
      expect(autenticado, false);
    });
  });
}