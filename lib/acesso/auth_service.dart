// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // MUDANÇA IMPORTANTE: Use seu IP real ou um serviço de teste
  static const String baseUrl = 'http://192.168.1.100:3000/api'; // ALTERE PARA SEU IP
  // static const String baseUrl = 'https://jsonplaceholder.typicode.com'; // PARA TESTE
  static String? _token;

  // Getter para o token
  static String? get token => _token;

  // Inicializar o serviço
  static Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      print('AuthService inicializado. Token: ${_token != null ? "Presente" : "Nulo"}');
    } catch (e) {
      print('Erro na inicialização do AuthService: $e');
    }
  }

  // Salvar token
  static Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token salvo: $token');
  }

  // Salvar dados do usuário
  static Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', json.encode(userData));
    print('Dados do usuário salvos: ${userData['nome']}');
  }

  // Obter dados do usuário salvos
  static Future<Map<String, dynamic>> _getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData');
      if (userDataString != null) {
        return json.decode(userDataString);
      }
    } catch (e) {
      print('Erro ao obter dados do usuário: $e');
    }
    return {};
  }

  // Remover token (logout)
  static Future<void> removeToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userData');
    print('Token e dados removidos');
  }

  // Cadastro - APENAS CADASTRO, SEM LOGIN AUTOMÁTICO
  static Future<Map<String, dynamic>> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
  }) async {
    try {
      print('Tentando cadastrar: $email');
      
      // SIMULAÇÃO TEMPORÁRIA - REMOVA QUANDO O BACKEND ESTIVER PRONTO
      await Future.delayed(const Duration(seconds: 2));
      
      // Simular validação de email único
      final prefs = await SharedPreferences.getInstance();
      final usuarios = prefs.getStringList('usuarios_cadastrados') ?? [];
      
      if (usuarios.any((user) => user.contains(email))) {
        return {
          'success': false, 
          'message': 'Este email já está cadastrado'
        };
      }
      
      // Adicionar à lista de usuários cadastrados
      usuarios.add('$email|${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setStringList('usuarios_cadastrados', usuarios);
      
      // **IMPORTANTE**: Não salva token nem faz login automático
      // Apenas retorna sucesso para o usuário fazer login manualmente
      
      return {
        'success': true, 
        'message': 'Cadastro realizado com sucesso! Faça login para continuar.',
        'user': {
          'nome': nome,
          'email': email,
          'telefone': telefone,
        },
      };

      // CÓDIGO ORIGINAL PARA BACKEND REAL (COMENTADO TEMPORARIAMENTE)
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/auth/cadastro'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': nome,
          'email': email,
          'senha': senha,
          'telefone': telefone,
        }),
      ).timeout(const Duration(seconds: 10));

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        // **IMPORTANTE**: Não faz login automático no cadastro
        return {
          'success': true, 
          'message': 'Cadastro realizado com sucesso! Faça login para continuar.',
          'user': data['user']
        };
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Erro no cadastro'};
      }
      */
    } on http.ClientException catch (e) {
      return {'success': false, 'message': 'Erro de conexão. Verifique se o servidor está rodando.'};
    } on Exception catch (e) {
      return {'success': false, 'message': 'Erro: $e'};
    }
  }

  // Login - FAZ LOGIN E SALVA TOKEN/DADOS
  static Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    try {
      print('Tentando login: $email');
      
      // SIMULAÇÃO TEMPORÁRIA - REMOVA QUANDO O BACKEND ESTIVER PRONTO
      await Future.delayed(const Duration(seconds: 2));
      
      // Verificar se o usuário foi cadastrado (simulação)
      final prefs = await SharedPreferences.getInstance();
      final usuarios = prefs.getStringList('usuarios_cadastrados') ?? [];
      
      final usuarioCadastrado = usuarios.any((user) => user.contains(email));
      
      // Simular credenciais válidas (apenas para usuários cadastrados com senha >= 6)
      if (usuarioCadastrado && senha.length >= 6) {
        final userData = {
          'nome': email.split('@')[0],
          'email': email,
          'telefone': '(11) 99999-9999', // Simulado
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
        };
        
        final token = 'simulated_token_${DateTime.now().millisecondsSinceEpoch}';
        
        // **IMPORTANTE**: Salva token e dados apenas no login
        await _saveToken(token);
        await _saveUserData(userData);
        
        return {
          'success': true, 
          'user': userData,
          'message': 'Login realizado com sucesso!'
        };
      } else if (!usuarioCadastrado) {
        return {
          'success': false, 
          'message': 'Usuário não encontrado. Faça o cadastro primeiro.'
        };
      } else {
        return {
          'success': false, 
          'message': 'Senha incorreta'
        };
      }

      // CÓDIGO ORIGINAL PARA BACKEND REAL (COMENTADO TEMPORARIAMENTE)
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'senha': senha,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // **IMPORTANTE**: Salva token e dados apenas no login
        await _saveToken(data['token']);
        await _saveUserData(data['user']);
        return {'success': true, 'user': data['user']};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Erro no login'};
      }
      */
    } on http.ClientException catch (e) {
      return {'success': false, 'message': 'Erro de conexão. Verifique se o servidor está rodando.'};
    } on Exception catch (e) {
      return {'success': false, 'message': 'Erro: $e'};
    }
  }

  // Esqueci senha - VERSÃO SIMULADA
  static Future<Map<String, dynamic>> esqueciSenha(String email) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      // Verificar se o email existe (simulação)
      final prefs = await SharedPreferences.getInstance();
      final usuarios = prefs.getStringList('usuarios_cadastrados') ?? [];
      final usuarioExiste = usuarios.any((user) => user.contains(email));
      
      if (usuarioExiste) {
        return {
          'success': true, 
          'message': 'Instruções de recuperação enviadas para $email'
        };
      } else {
        return {
          'success': false, 
          'message': 'Email não cadastrado no sistema'
        };
      }
      
      // CÓDIGO ORIGINAL PARA BACKEND REAL (COMENTADO TEMPORARIAMENTE)
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/auth/esqueci-senha'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Email de recuperação enviado!'};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Erro ao enviar email'};
      }
      */
    } on Exception catch (e) {
      return {'success': false, 'message': 'Erro: $e'};
    }
  }

  // Redefinir senha - VERSÃO SIMULADA
  static Future<Map<String, dynamic>> redefinirSenha({
    required String token,
    required String novaSenha,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      // Simular redefinição de senha bem-sucedida
      return {
        'success': true, 
        'message': 'Senha redefinida com sucesso!'
      };
      
      // CÓDIGO ORIGINAL PARA BACKEND REAL (COMENTADO TEMPORARIAMENTE)
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/auth/redefinir-senha'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': token,
          'novaSenha': novaSenha,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Senha redefinida com sucesso!'};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Erro ao redefinir senha'};
      }
      */
    } on Exception catch (e) {
      return {'success': false, 'message': 'Erro: $e'};
    }
  }

  // Verificar se está autenticado
  static Future<bool> isAuthenticated() async {
    if (_token == null) {
      await initialize();
    }
    final bool autenticado = _token != null;
    print('Usuário autenticado: $autenticado');
    return autenticado;
  }

  // Obter dados do usuário
  static Future<Map<String, dynamic>> getUserData() async {
    try {
      // Primeiro tenta obter dos dados salvos
      final savedData = await _getUserData();
      if (savedData.isNotEmpty) {
        print('Dados do usuário obtidos do cache: ${savedData['nome']}');
        return savedData;
      }
      
      // Se não tiver dados salvos, tenta buscar da API
      if (_token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/auth/me'),
          headers: {'Authorization': 'Bearer $_token'},
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final userData = json.decode(response.body);
          await _saveUserData(userData);
          return userData;
        } else {
          await removeToken();
          return {};
        }
      }
      return {};
    } catch (e) {
      print('Erro ao obter dados do usuário: $e');
      // Em caso de erro, retorna dados salvos ou vazio
      return await _getUserData();
    }
  }

  // Logout - limpa todos os dados
  static Future<void> logout() async {
    await removeToken();
    print('Logout realizado com sucesso');
  }

  // Verificar se email já está cadastrado (para uso no cadastro)
  static Future<bool> isEmailCadastrado(String email) async {
    try {
      // Simulação - verifica na lista local
      final prefs = await SharedPreferences.getInstance();
      final usuarios = prefs.getStringList('usuarios_cadastrados') ?? [];
      return usuarios.any((user) => user.contains(email));
      
      // Para backend real:
      /*
      final response = await http.get(
        Uri.parse('$baseUrl/auth/verificar-email/$email'),
      ).timeout(const Duration(seconds: 10));
      
      return response.statusCode == 200;
      */
    } catch (e) {
      return false;
    }
  }
}