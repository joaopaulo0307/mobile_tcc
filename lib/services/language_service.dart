import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  Locale _currentLocale = const Locale('pt', 'BR');
  Locale get currentLocale => _currentLocale;

  final Map<String, Map<String, String>> _translations = {
    'pt': {
      'login': 'LOGIN',
      'email': 'E-mail',
      'password': 'Senha',
      'forgot_password': 'Esqueceu a senha?',
      'sign_up': 'Cadastrar',
      'enter': 'Entrar',
      'organize_tasks': 'Organize suas tarefas de forma simples',
      'rights_reserved': '© Todos os direitos reservados - 2025',
      'ola': 'Olá',
      'economico': 'ECONÔMICO',
      'calendario': 'CALENDÁRIO',
      'usuarios': 'USUÁRIOS',
      'minhas_casas': 'MINHAS CASAS',
      'meu_perfil': 'MEU PERFIL',
      'configuracoes': 'CONFIGURAÇÕES',
      'nenhuma_tarefa': 'Nenhuma tarefa pendente',
      'adicione_tarefas': 'Adicione tarefas no calendário',
      'acesso_rapido': 'Acesso Rápido',
      'organize_tarefas': 'Organize suas tarefas de forma simples',
      'direitos_reservados': '© Todos os direitos reservados - 2025',
      'hoje': 'Hoje',
      'amanha': 'Amanhã',
    },
    'en': {
      'login': 'LOGIN',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot password?',
      'sign_up': 'Sign Up',
      'enter': 'Enter',
      'organize_tasks': 'Organize your tasks simply',
      'rights_reserved': '© All rights reserved - 2025',
      'ola': 'Hello',
      'economico': 'ECONOMIC',
      'calendario': 'CALENDAR',
      'usuarios': 'USERS',
      'minhas_casas': 'MY HOUSES',
      'meu_perfil': 'MY PROFILE',
      'configuracoes': 'SETTINGS',
      'nenhuma_tarefa': 'No pending tasks',
      'adicione_tarefas': 'Add tasks in calendar',
      'acesso_rapido': 'Quick Access',
      'organize_tarefas': 'Organize your tasks simply',
      'direitos_reservados': '© All rights reserved - 2025',
      'hoje': 'Today',
      'amanha': 'Tomorrow',
    },
    'es': {
      'login': 'INICIAR SESIÓN',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'sign_up': 'Registrarse',
      'enter': 'Entrar',
      'organize_tasks': 'Organiza tus tareas de forma simple',
      'rights_reserved': '© Todos los derechos reservados - 2025',
      'ola': 'Hola',
      'economico': 'ECONÓMICO',
      'calendario': 'CALENDARIO',
      'usuarios': 'USUARIOS',
      'minhas_casas': 'MIS CASAS',
      'meu_perfil': 'MI PERFIL',
      'configuracoes': 'CONFIGURACIONES',
      'nenhuma_tarefa': 'No hay tareas pendientes',
      'adicione_tarefas': 'Agrega tareas en el calendario',
      'acesso_rapido': 'Acceso Rápido',
      'organize_tarefas': 'Organiza tus tareas de forma simple',
      'direitos_reservados': '© Todos los derechos reservados - 2025',
      'hoje': 'Hoy',
      'amanha': 'Mañana',
    },
  };

  String translate(String key) {
    return _translations[_currentLocale.languageCode]?[key] ?? key;
  }

  void setLocale(Locale locale) {
    _currentLocale = locale;
    notifyListeners();
  }

  void changeLanguageByCode(String code) {
    switch (code) {
      case 'pt':
        setLocale(const Locale('pt', 'BR'));
        break;
      case 'en':
        setLocale(const Locale('en', 'US'));
        break;
      case 'es':
        setLocale(const Locale('es', 'ES'));
        break;
    }
  }

  String getCurrentLanguageName() {
    switch (_currentLocale.languageCode) {
      case 'pt':
        return 'Português (BR)';
      case 'en':
        return 'English (US)';
      case 'es':
        return 'Español';
      default:
        return 'Português (BR)';
    }
  }

  List<Map<String, String>> getAvailableLanguages() {
    return [
      {'name': 'Português (BR)', 'code': 'pt_BR'},
      {'name': 'English (US)', 'code': 'en_US'},
      {'name': 'Español', 'code': 'es_ES'},
    ];
  }
}