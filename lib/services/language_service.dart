import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  Locale _currentLocale = const Locale('pt', 'BR');
  Locale get currentLocale => _currentLocale;

  final Map<String, Map<String, String>> _translations = {
    'pt': {
      // AUTH E GERAL
      'login': 'LOGIN',
      'email': 'E-mail',
      'password': 'Senha',
      'forgot_password': 'Esqueceu a senha?',
      'sign_up': 'Cadastrar',
      'enter': 'Entrar',
      'organize_tasks': 'Organize suas tarefas de forma simples',
      'rights_reserved': '© Todos os direitos reservados - 2025',
      'ola': 'Olá',
      
      // MENU E NAVEGAÇÃO
      'economico': 'ECONÔMICO',
      'calendario': 'CALENDÁRIO',
      'usuarios': 'USUÁRIOS',
      'minhas_casas': 'MINHAS CASAS',
      'meu_perfil': 'MEU PERFIL',
      'configuracoes': 'CONFIGURAÇÕES',
      
      // HOME E TAREFAS
      'nenhuma_tarefa': 'Nenhuma tarefa pendente',
      'adicione_tarefas': 'Adicione tarefas no calendário',
      'acesso_rapido': 'Acesso Rápido',
      'organize_tarefas': 'Organize suas tarefas de forma simples',
      'direitos_reservados': '© Todos os direitos reservados - 2025',
      'hoje': 'Hoje',
      'amanha': 'Amanhã',
      
      // AÇÕES
      'salvar': 'Salvar',
      'cancelar': 'Cancelar',
      'confirmar': 'Confirmar',
      'excluir': 'Excluir',
      'editar': 'Editar',
      'adicionar': 'Adicionar',
      'pesquisar': 'Pesquisar',
      
      // STATUS
      'carregando': 'Carregando...',
      'erro': 'Erro',
      'sucesso': 'Sucesso',
      'atencao': 'Atenção',
      'sim': 'Sim',
      'nao': 'Não',
      'ok': 'OK',

      // 🔥 NOVAS TRADUÇÕES PARA CONFIGURAÇÕES
      'configuracoes': 'Configurações',
      'preferencias': 'Preferências',
      'modo_escuro': 'Modo Escuro',
      'modo_claro': 'Modo Claro',
      'tema_escuro_ativado': 'Tema escuro ativado',
      'tema_claro_ativado': 'Tema claro ativado',
      'notificacoes': 'Notificações',
      'notificacoes_ativas': 'Notificações ativas',
      'notificacoes_inativas': 'Notificações inativas',
      'biometria': 'Biometria',
      'biometria_ativa': 'Biometria ativa',
      'biometria_inativa': 'Biometria inativa',
      'sincronizacao_auto': 'Sincronização Automática',
      'sinc_auto_ativa': 'Sincronização automática ativa',
      'sinc_auto_inativa': 'Sincronização automática inativa',
      'privacidade': 'Privacidade',
      'config_privacidade': 'Configurar privacidade',
      'seguranca': 'Segurança',
      'config_seguranca': 'Configurar segurança',
      'versao_app': 'Versão do App',
      'avaliar_app': 'Avaliar App',
      'avaliar_na_loja': 'Avaliar na loja de aplicativos',
      'compartilhar_app': 'Compartilhar App',
      'compartilhar_amigos': 'Compartilhar com amigos',
      'alternar_tema': 'ALTERNAR TEMA AGORA',
      'redefinir_config': 'REDEFINIR CONFIGURAÇÕES',
      'confirmar_redefinir': 'Tem certeza que deseja redefinir todas as configurações para os padrões?',
      'config_redefinidas': 'Configurações redefinidas com sucesso!',
      'selecionar_idioma': 'Selecionar Idioma',
      'idioma_alterado': 'Idioma alterado para',
      'fechar': 'FECHAR',
      'redefinir': 'REDEFINIR',
      'voltar': 'VOLTAR',

      // IDIOMAS
      'idioma': 'Idioma',
      'portugues': 'Português (Brasil)',
      'ingles': 'English (US)',
      'espanhol': 'Español',

      // FINANCEIRO
      'resumo_financeiro': 'Resumo Financeiro',
      'saldo': 'Saldo',
      'despesas': 'Despesas',
      'receitas': 'Receitas',
      'total': 'Total',

      // 🔥 NOVAS TRADUÇÕES PARA USUÁRIOS
      'membros': 'Membros',
      'adicionar_membro': 'Adicionar Membro',
      'remover_membro': 'Remover Membro',
      'nome': 'Nome',
      'descricao': 'Descrição',
      'telefone': 'Telefone',
      'administracao_usuarios': 'Administração de Usuários',
      'total_membros': 'Total de {{count}} membros',
      'um_membro': '1 membro',
      'nenhum_membro': 'Nenhum membro',
      'nenhum_membro_cadastrado': 'Nenhum membro cadastrado',
      'clique_adicionar_membro': 'Clique em "+ Add Membro" para adicionar',
      'pesquisar_membros': 'Pesquisar membros...',
      'resultados_encontrados': '{{count}} resultados encontrados',
      'detalhes': 'Detalhes',
      'limpar': 'Limpar',
      'exportar': 'Exportar',
      'confirmar_exclusao': 'Tem certeza que deseja remover este membro?',
      'membro_adicionado_sucesso': 'Membro adicionado com sucesso!',
      'membro_removido_sucesso': 'Membro removido com sucesso!',
      'exportando_membros': 'Exportando lista de membros...',

      // CALENDÁRIO
      'nova_tarefa': 'Nova Tarefa',
      'data': 'Data',
      'hora': 'Hora',
      'prioridade': 'Prioridade',
      'alta': 'Alta',
      'media': 'Média',
      'baixa': 'Baixa',

      // MENSAGENS DE VALIDAÇÃO
      'campo_obrigatorio': 'Este campo é obrigatório',
      'email_invalido': 'E-mail inválido',
      'senha_curta': 'Senha muito curta',

      // 🔥 NOVAS TRADUÇÕES GERAIS
      'sim': 'Sim',
      'nao': 'Não',
      'continuar': 'Continuar',
      'concluir': 'Concluir',
      'proximo': 'Próximo',
      'anterior': 'Anterior',
      'selecionar': 'Selecionar',
      'selecionar_todos': 'Selecionar Todos',
      'desmarcar_todos': 'Desmarcar Todos',
      'atualizar': 'Atualizar',
      'recarregar': 'Recarregar',
      'filtrar': 'Filtrar',
      'ordenar': 'Ordenar',
      'visualizacao': 'Visualização',
      'lista': 'Lista',
      'grade': 'Grade',
      'detalhes': 'Detalhes',
      'informacoes': 'Informações',
      'configuracoes': 'Configurações',
      'sobre': 'Sobre',
      'ajuda': 'Ajuda',
      'suporte': 'Suporte',
      'sair': 'Sair',
      'sair_app': 'Sair do App',
      'confirmar_saida': 'Tem certeza que deseja sair?',
    },
    'en': {
      // AUTH AND GENERAL
      'login': 'LOGIN',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot password?',
      'sign_up': 'Sign Up',
      'enter': 'Enter',
      'organize_tasks': 'Organize your tasks simply',
      'rights_reserved': '© All rights reserved - 2025',
      'ola': 'Hello',
      
      // MENU AND NAVIGATION
      'economico': 'ECONOMIC',
      'calendario': 'CALENDAR',
      'usuarios': 'USERS',
      'minhas_casas': 'MY HOUSES',
      'meu_perfil': 'MY PROFILE',
      'configuracoes': 'SETTINGS',
      
      // HOME AND TASKS
      'nenhuma_tarefa': 'No pending tasks',
      'adicione_tarefas': 'Add tasks in calendar',
      'acesso_rapido': 'Quick Access',
      'organize_tarefas': 'Organize your tasks simply',
      'direitos_reservados': '© All rights reserved - 2025',
      'hoje': 'Today',
      'amanha': 'Tomorrow',
      
      // ACTIONS
      'salvar': 'Save',
      'cancelar': 'Cancel',
      'confirmar': 'Confirm',
      'excluir': 'Delete',
      'editar': 'Edit',
      'adicionar': 'Add',
      'pesquisar': 'Search',
      
      // STATUS
      'carregando': 'Loading...',
      'erro': 'Error',
      'sucesso': 'Success',
      'atencao': 'Warning',
      'sim': 'Yes',
      'nao': 'No',
      'ok': 'OK',

      // 🔥 NEW TRANSLATIONS FOR SETTINGS
      'configuracoes': 'Settings',
      'preferencias': 'Preferences',
      'modo_escuro': 'Dark Mode',
      'modo_claro': 'Light Mode',
      'tema_escuro_ativado': 'Dark theme activated',
      'tema_claro_ativado': 'Light theme activated',
      'notificacoes': 'Notifications',
      'notificacoes_ativas': 'Notifications active',
      'notificacoes_inativas': 'Notifications inactive',
      'biometria': 'Biometrics',
      'biometria_ativa': 'Biometrics active',
      'biometria_inativa': 'Biometrics inactive',
      'sincronizacao_auto': 'Auto Sync',
      'sinc_auto_ativa': 'Auto sync active',
      'sinc_auto_inativa': 'Auto sync inactive',
      'privacidade': 'Privacy',
      'config_privacidade': 'Configure privacy',
      'seguranca': 'Security',
      'config_seguranca': 'Configure security',
      'versao_app': 'App Version',
      'avaliar_app': 'Rate App',
      'avaliar_na_loja': 'Rate in app store',
      'compartilhar_app': 'Share App',
      'compartilhar_amigos': 'Share with friends',
      'alternar_tema': 'TOGGLE THEME NOW',
      'redefinir_config': 'RESET SETTINGS',
      'confirmar_redefinir': 'Are you sure you want to reset all settings to default?',
      'config_redefinidas': 'Settings reset successfully!',
      'selecionar_idioma': 'Select Language',
      'idioma_alterado': 'Language changed to',
      'fechar': 'CLOSE',
      'redefinir': 'RESET',
      'voltar': 'BACK',

      // LANGUAGES
      'idioma': 'Language',
      'portugues': 'Portuguese (Brazil)',
      'ingles': 'English (US)',
      'espanhol': 'Spanish',

      // FINANCIAL
      'resumo_financeiro': 'Financial Summary',
      'saldo': 'Balance',
      'despesas': 'Expenses',
      'receitas': 'Income',
      'total': 'Total',

      // 🔥 NEW TRANSLATIONS FOR USERS
      'membros': 'Members',
      'adicionar_membro': 'Add Member',
      'remover_membro': 'Remove Member',
      'nome': 'Name',
      'descricao': 'Description',
      'telefone': 'Phone',
      'administracao_usuarios': 'User Administration',
      'total_membros': 'Total of {{count}} members',
      'um_membro': '1 member',
      'nenhum_membro': 'No members',
      'nenhum_membro_cadastrado': 'No members registered',
      'clique_adicionar_membro': 'Click on "+ Add Member" to add',
      'pesquisar_membros': 'Search members...',
      'resultados_encontrados': '{{count}} results found',
      'detalhes': 'Details',
      'limpar': 'Clear',
      'exportar': 'Export',
      'confirmar_exclusao': 'Are you sure you want to remove this member?',
      'membro_adicionado_sucesso': 'Member added successfully!',
      'membro_removido_sucesso': 'Member removed successfully!',
      'exportando_membros': 'Exporting member list...',

      // CALENDAR
      'nova_tarefa': 'New Task',
      'data': 'Date',
      'hora': 'Time',
      'prioridade': 'Priority',
      'alta': 'High',
      'media': 'Medium',
      'baixa': 'Low',

      // VALIDATION MESSAGES
      'campo_obrigatorio': 'This field is required',
      'email_invalido': 'Invalid email',
      'senha_curta': 'Password too short',

      // 🔥 NEW GENERAL TRANSLATIONS
      'sim': 'Yes',
      'nao': 'No',
      'continuar': 'Continue',
      'concluir': 'Complete',
      'proximo': 'Next',
      'anterior': 'Previous',
      'selecionar': 'Select',
      'selecionar_todos': 'Select All',
      'desmarcar_todos': 'Deselect All',
      'atualizar': 'Update',
      'recarregar': 'Reload',
      'filtrar': 'Filter',
      'ordenar': 'Sort',
      'visualizacao': 'View',
      'lista': 'List',
      'grade': 'Grid',
      'detalhes': 'Details',
      'informacoes': 'Information',
      'configuracoes': 'Settings',
      'sobre': 'About',
      'ajuda': 'Help',
      'suporte': 'Support',
      'sair': 'Exit',
      'sair_app': 'Exit App',
      'confirmar_saida': 'Are you sure you want to exit?',
    },
    'es': {
      // AUTH Y GENERAL
      'login': 'INICIAR SESIÓN',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'sign_up': 'Registrarse',
      'enter': 'Entrar',
      'organize_tasks': 'Organiza tus tareas de forma simple',
      'rights_reserved': '© Todos los derechos reservados - 2025',
      'ola': 'Hola',
      
      // MENÚ Y NAVEGACIÓN
      'economico': 'ECONÓMICO',
      'calendario': 'CALENDARIO',
      'usuarios': 'USUARIOS',
      'minhas_casas': 'MIS CASAS',
      'meu_perfil': 'MI PERFIL',
      'configuracoes': 'CONFIGURACIONES',
      
      // HOME Y TAREAS
      'nenhuma_tarefa': 'No hay tareas pendientes',
      'adicione_tarefas': 'Agrega tareas en el calendario',
      'acesso_rapido': 'Acceso Rápido',
      'organize_tarefas': 'Organiza tus tareas de forma simple',
      'direitos_reservados': '© Todos los derechos reservados - 2025',
      'hoje': 'Hoy',
      'amanha': 'Mañana',
      
      // ACCIONES
      'salvar': 'Guardar',
      'cancelar': 'Cancelar',
      'confirmar': 'Confirmar',
      'excluir': 'Eliminar',
      'editar': 'Editar',
      'adicionar': 'Agregar',
      'pesquisar': 'Buscar',
      
      // ESTADO
      'carregando': 'Cargando...',
      'erro': 'Error',
      'sucesso': 'Éxito',
      'atencao': 'Advertencia',
      'sim': 'Sí',
      'nao': 'No',
      'ok': 'OK',

      // 🔥 NUEVAS TRADUCCIONES PARA CONFIGURACIONES
      'configuracoes': 'Configuraciones',
      'preferencias': 'Preferencias',
      'modo_escuro': 'Modo Oscuro',
      'modo_claro': 'Modo Claro',
      'tema_escuro_ativado': 'Tema oscuro activado',
      'tema_claro_ativado': 'Tema claro activado',
      'notificacoes': 'Notificaciones',
      'notificacoes_ativas': 'Notificaciones activas',
      'notificacoes_inativas': 'Notificaciones inactivas',
      'biometria': 'Biometría',
      'biometria_ativa': 'Biometría activa',
      'biometria_inativa': 'Biometría inactiva',
      'sincronizacao_auto': 'Sincronización Automática',
      'sinc_auto_ativa': 'Sincronización automática activa',
      'sinc_auto_inativa': 'Sincronización automática inactiva',
      'privacidade': 'Privacidad',
      'config_privacidade': 'Configurar privacidad',
      'seguranca': 'Seguridad',
      'config_seguranca': 'Configurar seguridad',
      'versao_app': 'Versión de la App',
      'avaliar_app': 'Calificar App',
      'avaliar_na_loja': 'Calificar en tienda de apps',
      'compartilhar_app': 'Compartir App',
      'compartilhar_amigos': 'Compartir con amigos',
      'alternar_tema': 'CAMBIAR TEMA AHORA',
      'redefinir_config': 'RESTABLECER CONFIGURACIÓN',
      'confirmar_redefinir': '¿Estás seguro de que quieres restablecer toda la configuración?',
      'config_redefinidas': '¡Configuración restablecida con éxito!',
      'selecionar_idioma': 'Seleccionar Idioma',
      'idioma_alterado': 'Idioma cambiado a',
      'fechar': 'CERRAR',
      'redefinir': 'RESTABLECER',
      'voltar': 'VOLVER',

      // IDIOMAS
      'idioma': 'Idioma',
      'portugues': 'Portugués (Brasil)',
      'ingles': 'Inglés (US)',
      'espanhol': 'Español',

      // FINANZAS
      'resumo_financeiro': 'Resumen Financiero',
      'saldo': 'Saldo',
      'despesas': 'Gastos',
      'receitas': 'Ingresos',
      'total': 'Total',

      // 🔥 NUEVAS TRADUCCIONES PARA USUARIOS
      'membros': 'Miembros',
      'adicionar_membro': 'Agregar Miembro',
      'remover_membro': 'Eliminar Miembro',
      'nome': 'Nombre',
      'descricao': 'Descripción',
      'telefone': 'Teléfono',
      'administracao_usuarios': 'Administración de Usuarios',
      'total_membros': 'Total de {{count}} miembros',
      'um_membro': '1 miembro',
      'nenhum_membro': 'Ningún miembro',
      'nenhum_membro_cadastrado': 'Ningún miembro registrado',
      'clique_adicionar_membro': 'Haz clic en "+ Agregar Miembro" para agregar',
      'pesquisar_membros': 'Buscar miembros...',
      'resultados_encontrados': '{{count}} resultados encontrados',
      'detalhes': 'Detalles',
      'limpar': 'Limpiar',
      'exportar': 'Exportar',
      'confirmar_exclusao': '¿Estás seguro de que quieres eliminar este miembro?',
      'membro_adicionado_sucesso': '¡Miembro agregado con éxito!',
      'membro_removido_sucesso': '¡Miembro eliminado con éxito!',
      'exportando_membros': 'Exportando lista de miembros...',

      // CALENDARIO
      'nova_tarefa': 'Nueva Tarea',
      'data': 'Fecha',
      'hora': 'Hora',
      'prioridade': 'Prioridad',
      'alta': 'Alta',
      'media': 'Media',
      'baixa': 'Baja',

      // MENSAJES DE VALIDACIÓN
      'campo_obrigatorio': 'Este campo es obligatorio',
      'email_invalido': 'Correo electrónico inválido',
      'senha_curta': 'Contraseña muy corta',

      // 🔥 NUEVAS TRADUCCIONES GENERALES
      'sim': 'Sí',
      'nao': 'No',
      'continuar': 'Continuar',
      'concluir': 'Concluir',
      'proximo': 'Siguiente',
      'anterior': 'Anterior',
      'selecionar': 'Seleccionar',
      'selecionar_todos': 'Seleccionar Todos',
      'desmarcar_todos': 'Desmarcar Todos',
      'atualizar': 'Actualizar',
      'recarregar': 'Recargar',
      'filtrar': 'Filtrar',
      'ordenar': 'Ordenar',
      'visualizacao': 'Visualización',
      'lista': 'Lista',
      'grade': 'Cuadrícula',
      'detalhes': 'Detalles',
      'informacoes': 'Información',
      'configuracoes': 'Configuraciones',
      'sobre': 'Acerca de',
      'ajuda': 'Ayuda',
      'suporte': 'Soporte',
      'sair': 'Salir',
      'sair_app': 'Salir de la App',
      'confirmar_saida': '¿Estás seguro de que quieres salir?',
    },
  };

  // ✅ MÉTODO PRINCIPAL DE TRADUÇÃO
  String translate(String key) {
    return _translations[_currentLocale.languageCode]?[key] ?? key;
  }

  // ✅ ALTERAR LOCALE
  void setLocale(Locale locale) {
    _currentLocale = locale;
    notifyListeners();
  }

  // ✅ ALTERAR POR CÓDIGO
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

  // ✅ NOME DO IDIOMA ATUAL
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

  //  IDIOMAS DISPONÍVEIS
  List<Map<String, String>> getAvailableLanguages() {
    return [
      {'name': 'Português (BR)', 'code': 'pt_BR'},
      {'name': 'English (US)', 'code': 'en_US'},
      {'name': 'Español', 'code': 'es_ES'},
    ];
  }

  // NOVOS MÉTODOS ADICIONADOS:

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

  // 8. Obter tradução segura (com fallback)
  String translateSafe(String key, {String fallback = ''}) {
    final translation = translate(key);
    return translation != key ? translation : fallback;
  }

  // 9. Verificar se é um idioma específico
  bool isPortuguese() => _currentLocale.languageCode == 'pt';
  bool isEnglish() => _currentLocale.languageCode == 'en';
  bool isSpanish() => _currentLocale.languageCode == 'es';

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

  // 10. Método para inicializar com locale salvo (para usar com SharedPreferences)
  Future<void> initializeWithSavedLocale(Locale defaultLocale) async {
    // Aqui você pode adicionar lógica para carregar o locale salvo
    // Por exemplo, usando SharedPreferences
    _currentLocale = defaultLocale;
    notifyListeners();
  }

  // 11. Obter lista de todas as chaves disponíveis (útil para debug)
  List<String> getAvailableKeys() {
    return _translations[_currentLocale.languageCode]?.keys.toList() ?? [];
  }

  // 12. Método para adicionar traduções dinamicamente (útil para carregar do backend)
  void addTranslations(Map<String, Map<String, String>> newTranslations) {
    newTranslations.forEach((language, translations) {
      if (_translations.containsKey(language)) {
        _translations[language]!.addAll(translations);
      } else {
        _translations[language] = translations;
      }
    });
    notifyListeners();
  }
}