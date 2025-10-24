// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.1.100:3000/api';
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

  // Cadastro - Salva o nome real do usuário
  static Future<Map<String, dynamic>> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      print('Tentando cadastrar: $email - Nome: $nome');
      
      // SIMULAÇÃO TEMPORÁRIA
      await Future.delayed(const Duration(seconds: 2));
      
      final prefs = await SharedPreferences.getInstance();
      final usuarios = prefs.getStringList('usuarios_cadastrados') ?? [];
      
      // Verificar se email já existe
      if (usuarios.any((user) => user.contains(email))) {
        return {
          'success': false, 
          'message': 'Este email já está cadastrado'
        };
      }
      
      // Criar dados do usuário com nome real
      final userData = {
        'nome': nome, // NOME REAL DO USUÁRIO
        'email': email,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      };
      
      // Salvar dados do usuário para uso no login
      await prefs.setString('user_data_$email', json.encode(userData));
      
      // Adicionar à lista de usuários cadastrados
      usuarios.add('$email|${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setStringList('usuarios_cadastrados', usuarios);
      
      print('Usuário cadastrado com sucesso: $nome');
      
      return {
        'success': true, 
        'message': 'Cadastro realizado com sucesso! Faça login para continuar.',
        'user': userData,
      };

    } catch (e) {
      return {'success': false, 'message': 'Erro: $e'};
    }
  }

  // Login - Retorna o nome real do cadastro
  static Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    try {
      print('Tentando login: $email');
      
      // SIMULAÇÃO TEMPORÁRIA
      await Future.delayed(const Duration(seconds: 2));
      
      final prefs = await SharedPreferences.getInstance();
      final usuarios = prefs.getStringList('usuarios_cadastrados') ?? [];
      
      // Verificar se usuário existe
      final usuarioCadastrado = usuarios.any((user) => user.contains(email));
      
      if (usuarioCadastrado && senha.length >= 6) {
        // Buscar dados reais do cadastro
        final userDataCadastrado = prefs.getString('user_data_$email');
        
        Map<String, dynamic> userData;
        
        if (userDataCadastrado != null) {
          // Usar dados reais do cadastro
          userData = json.decode(userDataCadastrado);
          print('Nome real do usuário: ${userData['nome']}');
        } else {
          // Fallback se não encontrar dados (não deveria acontecer)
          userData = {
            'nome': email.split('@')[0],
            'email': email,
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
          };
          print('Usando nome fallback: ${userData['nome']}');
        }
        
        final token = 'simulated_token_${DateTime.now().millisecondsSinceEpoch}';
        
        // Salvar token e dados para sessão
        await _saveToken(token);
        await _saveUserData(userData);
        
        print('Login bem-sucedido para: ${userData['nome']}');
        
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
      
    } catch (e) {
      return {'success': false, 'message': 'Erro: $e'};
    }
  }

  // Esqueci senha
  static Future<Map<String, dynamic>> esqueciSenha(String email) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      
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
    } catch (e) {
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
      
      return {};
    } catch (e) {
      print('Erro ao obter dados do usuário: $e');
      return await _getUserData();
    }
  }

  // Logout
  static Future<void> logout() async {
    await removeToken();
    print('Logout realizado com sucesso');
  }

  // Verificar se email já está cadastrado
  static Future<bool> isEmailCadastrado(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usuarios = prefs.getStringList('usuarios_cadastrados') ?? [];
      return usuarios.any((user) => user.contains(email));
    } catch (e) {
      return false;
    }
  }

  // Obter nome do usuário pelo email
  static Future<String?> getNomeUsuario(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataCadastrado = prefs.getString('user_data_$email');
      
      if (userDataCadastrado != null) {
        final userData = json.decode(userDataCadastrado);
        return userData['nome'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}