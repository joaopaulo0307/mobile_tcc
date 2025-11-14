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
      'salvar': 'Salvar',
      'cancelar': 'Cancelar',
      'confirmar': 'Confirmar',
      'excluir': 'Excluir',
      'editar': 'Editar',
      'adicionar': 'Adicionar',
      'pesquisar': 'Pesquisar',
      'carregando': 'Carregando...',
      'erro': 'Erro',
      'sucesso': 'Sucesso',
      'atencao': 'Atenção',
      'sim': 'Sim',
      'nao': 'Não',
      'ok': 'OK',
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
      'salvar': 'Save',
      'cancelar': 'Cancel',
      'confirmar': 'Confirm',
      'excluir': 'Delete',
      'editar': 'Edit',
      'adicionar': 'Add',
      'pesquisar': 'Search',
      'carregando': 'Loading...',
      'erro': 'Error',
      'sucesso': 'Success',
      'atencao': 'Warning',
      'sim': 'Yes',
      'nao': 'No',
      'ok': 'OK',
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
      'salvar': 'Guardar',
      'cancelar': 'Cancelar',
      'confirmar': 'Confirmar',
      'excluir': 'Eliminar',
      'editar': 'Editar',
      'adicionar': 'Agregar',
      'pesquisar': 'Buscar',
      'carregando': 'Cargando...',
      'erro': 'Error',
      'sucesso': 'Éxito',
      'atencao': 'Advertencia',
      'sim': 'Sí',
      'nao': 'No',
      'ok': 'OK',
    },
  };

  // ✅ MANTIDO: Método principal de tradução
  String translate(String key) {
    return _translations[_currentLocale.languageCode]?[key] ?? key;
  }

  // ✅ MANTIDO: Alterar locale
  void setLocale(Locale locale) {
    _currentLocale = locale;
    notifyListeners();
  }

  // ✅ MANTIDO: Alterar por código
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

  // ✅ MANTIDO: Nome do idioma atual
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

  // ✅ MANTIDO: Idiomas disponíveis
  List<Map<String, String>> getAvailableLanguages() {
    return [
      {'name': 'Português (BR)', 'code': 'pt_BR'},
      {'name': 'English (US)', 'code': 'en_US'},
      {'name': 'Español', 'code': 'es_ES'},
    ];
  }

  // 🔥 NOVOS MÉTODOS ADICIONADOS:

  // 1. Verificar se uma chave existe
  bool hasKey(String key) {
    return _translations[_currentLocale.languageCode]?.containsKey(key) ?? false;
  }

  // 2. Formatar data de acordo com o locale
  String formatDate(DateTime date, {bool includeTime = false}) {
    final months = _getMonths();
    final days = _getDays();
    
    String formatted = '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
    
    if (includeTime) {
      formatted += ' ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    
    return formatted;
  }

  // 3. Formatar moeda (R$, $, €)
  String formatCurrency(double value) {
    switch (_currentLocale.languageCode) {
      case 'pt':
        return 'R\$${value.toStringAsFixed(2)}';
      case 'en':
        return '\$${value.toStringAsFixed(2)}';
      case 'es':
        return '€${value.toStringAsFixed(2)}';
      default:
        return 'R\$${value.toStringAsFixed(2)}';
    }
  }

  // 4. Obter direção do texto (LTR ou RTL)
  TextDirection get textDirection {
    switch (_currentLocale.languageCode) {
      case 'ar': // Árabe (exemplo de RTL)
        return TextDirection.rtl;
      default:
        return TextDirection.ltr;
    }
  }

  // 5. Método para tradução com parâmetros
  String translateWithParams(String key, Map<String, String> params) {
    String translation = translate(key);
    
    params.forEach((param, value) {
      translation = translation.replaceAll('{{$param}}', value);
    });
    
    return translation;
  }

  // 6. Obter todos os idiomas suportados com flags
  List<Map<String, dynamic>> getLanguagesWithFlags() {
    return [
      {
        'name': 'Português (BR)',
        'code': 'pt',
        'flag': '🇧🇷',
        'locale': const Locale('pt', 'BR')
      },
      {
        'name': 'English (US)',
        'code': 'en',
        'flag': '🇺🇸',
        'locale': const Locale('en', 'US')
      },
      {
        'name': 'Español',
        'code': 'es',
        'flag': '🇪🇸',
        'locale': const Locale('es', 'ES')
      },
    ];
  }

  // 7. Método para pluralização simples
  String pluralize(String singularKey, String pluralKey, int count) {
    return count == 1 ? translate(singularKey) : translate(pluralKey);
  }

  // 🔧 MÉTODOS PRIVADOS AUXILIARES:

  List<String> _getMonths() {
    switch (_currentLocale.languageCode) {
      case 'pt':
        return ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
      case 'en':
        return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      case 'es':
        return ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      default:
        return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    }
  }

  List<String> _getDays() {
    switch (_currentLocale.languageCode) {
      case 'pt':
        return ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
      case 'en':
        return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      case 'es':
        return ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
      default:
        return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    }
  }

  // 8. Método para inicializar com locale salvo (para usar com SharedPreferences)
  Future<void> initializeWithSavedLocale(Locale defaultLocale) async {
    // Aqui você pode adicionar lógica para carregar o locale salvo
    // Por exemplo, usando SharedPreferences
    _currentLocale = defaultLocale;
    notifyListeners();
  }

  // 9. Verificar se é um idioma específico
  bool isPortuguese() => _currentLocale.languageCode == 'pt';
  bool isEnglish() => _currentLocale.languageCode == 'en';
  bool isSpanish() => _currentLocale.languageCode == 'es';
}