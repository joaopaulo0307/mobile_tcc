// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:3000/api'; // Altere para sua API
  static String? _token;

  // Getter para o token
  static String? get token => _token;

  // Inicializar o serviço
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  // Salvar token
  static Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Remover token (logout)
  static Future<void> removeToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Cadastro
  static Future<Map<String, dynamic>> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/cadastro'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': nome,
          'email': email,
          'senha': senha,
          'telefone': telefone,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        await _saveToken(data['token']);
        return {'success': true, 'message': 'Cadastro realizado com sucesso!'};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Erro no cadastro'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveToken(data['token']);
        return {'success': true, 'user': data['user']};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Erro no login'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }

  // Esqueci senha
  static Future<Map<String, dynamic>> esqueciSenha(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/esqueci-senha'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Email de recuperação enviado!'};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Erro ao enviar email'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }

  // Redefinir senha
  static Future<Map<String, dynamic>> redefinirSenha({
    required String token,
    required String novaSenha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/redefinir-senha'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': token,
          'novaSenha': novaSenha,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Senha redefinida com sucesso!'};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Erro ao redefinir senha'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }

  // Verificar se está autenticado
  static Future<bool> isAuthenticated() async {
    if (_token == null) {
      await initialize();
    }
    return _token != null;
  }

  // Obter dados do usuário (usando JWT)
  static Future<Map<String, dynamic>> getUserData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        await removeToken();
        return {};
      }
    } catch (e) {
      await removeToken();
      return {};
    }
  }
}