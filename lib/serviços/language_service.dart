// lib/serviços/language_service.dart
import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  final ValueNotifier<Locale> _localeNotifier = ValueNotifier<Locale>(const Locale('pt', 'BR'));
  ValueNotifier<Locale> get localeNotifier => _localeNotifier;

  static const Map<String, Map<String, String>> _translations = {
    'pt_BR': {
      // Configurações
      'settings': 'Configurações',
      'appearance': 'Aparência',
      'dark_mode': 'Modo Escuro',
      'dark_mode_subtitle': 'Ativar tema escuro',
      'notifications': 'Notificações',
      'notifications_subtitle': 'Receber notificações do app',
      'language': 'Idioma',
      'privacy': 'Privacidade',
      'privacy_security': 'Privacidade e Segurança',
      'account': 'Conta',
      'edit_profile': 'Editar Perfil',
      'change_password': 'Alterar Senha',
      'about_app': 'Sobre o App',
      'app_version': 'Versão do App',
      'terms_of_use': 'Termos de Uso',
      'privacy_policy': 'Política de Privacidade',
      'back': 'Voltar',
      'select_language': 'Selecione o Idioma',
      'close': 'FECHAR',
      
      // Login e Autenticação
      'login': 'LOGIN',
      'email': 'Email',
      'password': 'Senha',
      'forgot_password': 'Esqueceu a sua senha?',
      'sign_up': 'Cadastre-se',
      'enter': 'Entrar',
      'confirm_password': 'Confirmar Senha',
      'already_have_account': 'Já tem uma conta?',
      'create_account': 'Criar Conta',
      'reset_password': 'Redefinir Senha',
      'send_instructions': 'Enviar Instruções',
      
      // Home
      'hello': 'Olá',
      'options': 'Opções',
      'users': 'Usuários',
      'economic': 'Econômico',
      'calendar': 'Calendário',
      'my_houses': 'Minhas Casas',
      'my_profile': 'Meu Perfil',
      'settings_nav': 'Configurações',
      'organize_tasks': 'Organize suas tarefas de forma simples',
      'rights_reserved': 'Todos os direitos reservados',
      
      // Calendário
      'calendar_title': 'CALENDÁRIO',
      'today': 'Hoje',
      'tasks_for': 'Tarefas para',
      'no_tasks_date': 'Nenhuma tarefa para esta data',
      'add_task_hint': 'Toque no botão + para adicionar uma tarefa',
      'new_task': 'Nova Tarefa',
      'task_title': 'Título da tarefa *',
      'task_description': 'Descrição (opcional)',
      'task_color': 'Cor da tarefa',
      'save_task': 'Salvar Tarefa',
      'cancel': 'Cancelar',
      'task_added': 'Tarefa adicionada com sucesso!',
      'task_completed': 'Tarefa concluída!',
      'enter_title': 'Por favor, insira um título para a tarefa',
      'select_date': 'Selecionar Data',
      'select_time': 'Selecionar Hora',
      
      // Usuários
      'members': 'Membros',
      'add_member': '+ Add Membro',
      'remove_member': '- Remover Membro',
      'no_members': 'Nenhum membro cadastrado',
      'add_member_hint': 'Clique em "+ Add Membro" para adicionar',
      'add_member_title': 'Adicionar Membro',
      'name': 'Nome',
      'member_description': 'Descrição do Membro', // CORRIGIDO: mudado de 'description'
      'confirm': 'Confirmar',
      'remove_member_title': 'Remover Membro',
      'remove_confirmation': 'Tem certeza que deseja remover este membro?',
      'remove': 'Remover',
      'edit_member': 'Editar Membro',
      'save_changes': 'Salvar Alterações',
      
      // Minhas Casas
      'my_houses_title': 'MINHAS CASAS',
      'no_houses': 'Nenhuma casa cadastrada',
      'add_house_hint': 'Toque no botão + para criar sua primeira casa',
      'create_house': 'Criar Nova Casa',
      'house_name': 'Nome da Casa',
      'create': 'Criar',
      'family_question': 'Quem significa uma família de forma simples?',
      'enter_house_name': 'Por favor, insira um nome para a casa',
      'select_house': 'Selecionar Casa',
      'edit_house': 'Editar Casa',
      'delete_house': 'Excluir Casa',
      'delete_house_confirmation': 'Tem certeza que deseja excluir esta casa?',
      
      // Econômico
      'economic_title': 'ECONÔMICO',
      'income': 'Receita',
      'expenses': 'Despesas',
      'balance': 'Saldo',
      'add_transaction': 'Adicionar Transação',
      'transaction_type': 'Tipo de Transação',
      'amount': 'Valor',
      'date': 'Data',
      'category': 'Categoria',
      'transaction_description': 'Descrição da Transação', // CORRIGIDO: mudado de 'description'
      'income_categories': 'Categorias de Receita',
      'expense_categories': 'Categorias de Despesa',
      
      // Perfil
      'profile': 'Perfil',
      'personal_info': 'Informações Pessoais',
      'full_name': 'Nome Completo',
      'phone': 'Telefone',
      'address': 'Endereço',
      'save_profile': 'Salvar Perfil',
      'change_photo': 'Alterar Foto',
      'logout': 'Sair',
      'logout_confirmation': 'Tem certeza que deseja sair?',
      
      // Adicionais para Home
      'acesso_rapido': 'Acesso Rápido',
      'nenhuma_tarefa': 'Nenhuma tarefa pendente',
      'adicione_tarefas': 'Adicione tarefas no calendário',
      'organize_tarefas': 'Organize suas tarefas de forma simples',
      'direitos_reservados': '© Todos os direitos reservados - 2025',
      'amanha': 'Amanhã',
      'esta_semana': 'Esta Semana',
      'proxima_semana': 'Próxima Semana',
      
      // Mensagens Gerais
      'success': 'Sucesso',
      'error': 'Erro',
      'warning': 'Aviso',
      'info': 'Informação',
      'loading': 'Carregando...',
      'saving': 'Salvando...',
      'deleting': 'Excluindo...',
      'search': 'Pesquisar',
      'filter': 'Filtrar',
      'sort': 'Ordenar',
      'view_all': 'Ver Todos',
      'see_more': 'Ver Mais',
      'no_data': 'Nenhum dado disponível',
      'try_again': 'Tentar Novamente',
      'connection_error': 'Erro de conexão',
    },
    'en_US': {
      // Settings
      'settings': 'Settings',
      'appearance': 'Appearance',
      'dark_mode': 'Dark Mode',
      'dark_mode_subtitle': 'Enable dark theme',
      'notifications': 'Notifications',
      'notifications_subtitle': 'Receive app notifications',
      'language': 'Language',
      'privacy': 'Privacy',
      'privacy_security': 'Privacy and Security',
      'account': 'Account',
      'edit_profile': 'Edit Profile',
      'change_password': 'Change Password',
      'about_app': 'About App',
      'app_version': 'App Version',
      'terms_of_use': 'Terms of Use',
      'privacy_policy': 'Privacy Policy',
      'back': 'Back',
      'select_language': 'Select Language',
      'close': 'CLOSE',
      
      // Login and Authentication
      'login': 'LOGIN',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot your password?',
      'sign_up': 'Sign Up',
      'enter': 'Enter',
      'confirm_password': 'Confirm Password',
      'already_have_account': 'Already have an account?',
      'create_account': 'Create Account',
      'reset_password': 'Reset Password',
      'send_instructions': 'Send Instructions',
      
      // Home
      'hello': 'Hello',
      'options': 'Options',
      'users': 'Users',
      'economic': 'Economic',
      'calendar': 'Calendar',
      'my_houses': 'My Houses',
      'my_profile': 'My Profile',
      'settings_nav': 'Settings',
      'organize_tasks': 'Organize your tasks simply',
      'rights_reserved': 'All rights reserved',
      
      // Calendar
      'calendar_title': 'CALENDAR',
      'today': 'Today',
      'tasks_for': 'Tasks for',
      'no_tasks_date': 'No tasks for this date',
      'add_task_hint': 'Tap the + button to add a task',
      'new_task': 'New Task',
      'task_title': 'Task title *',
      'task_description': 'Description (optional)',
      'task_color': 'Task color',
      'save_task': 'Save Task',
      'cancel': 'Cancel',
      'task_added': 'Task added successfully!',
      'task_completed': 'Task completed!',
      'enter_title': 'Please enter a title for the task',
      'select_date': 'Select Date',
      'select_time': 'Select Time',
      
      // Users
      'members': 'Members',
      'add_member': '+ Add Member',
      'remove_member': '- Remove Member',
      'no_members': 'No members registered',
      'add_member_hint': 'Click on "+ Add Member" to add',
      'add_member_title': 'Add Member',
      'name': 'Name',
      'member_description': 'Member Description', // CORRIGIDO: mudado de 'description'
      'confirm': 'Confirm',
      'remove_member_title': 'Remove Member',
      'remove_confirmation': 'Are you sure you want to remove this member?',
      'remove': 'Remove',
      'edit_member': 'Edit Member',
      'save_changes': 'Save Changes',
      
      // My Houses
      'my_houses_title': 'MY HOUSES',
      'no_houses': 'No houses registered',
      'add_house_hint': 'Tap the + button to create your first house',
      'create_house': 'Create New House',
      'house_name': 'House Name',
      'create': 'Create',
      'family_question': 'Who means a family in a simple way?',
      'enter_house_name': 'Please enter a name for the house',
      'select_house': 'Select House',
      'edit_house': 'Edit House',
      'delete_house': 'Delete House',
      'delete_house_confirmation': 'Are you sure you want to delete this house?',
      
      // Economic
      'economic_title': 'ECONOMIC',
      'income': 'Income',
      'expenses': 'Expenses',
      'balance': 'Balance',
      'add_transaction': 'Add Transaction',
      'transaction_type': 'Transaction Type',
      'amount': 'Amount',
      'date': 'Date',
      'category': 'Category',
      'transaction_description': 'Transaction Description', // CORRIGIDO: mudado de 'description'
      'income_categories': 'Income Categories',
      'expense_categories': 'Expense Categories',
      
      // Profile
      'profile': 'Profile',
      'personal_info': 'Personal Information',
      'full_name': 'Full Name',
      'phone': 'Phone',
      'address': 'Address',
      'save_profile': 'Save Profile',
      'change_photo': 'Change Photo',
      'logout': 'Logout',
      'logout_confirmation': 'Are you sure you want to logout?',
      
      // Additional for Home
      'acesso_rapido': 'Quick Access',
      'nenhuma_tarefa': 'No pending tasks',
      'adicione_tarefas': 'Add tasks in calendar',
      'organize_tarefas': 'Organize your tasks simply',
      'direitos_reservados': '© All rights reserved - 2025',
      'amanha': 'Tomorrow',
      'esta_semana': 'This Week',
      'proxima_semana': 'Next Week',
      
      // General Messages
      'success': 'Success',
      'error': 'Error',
      'warning': 'Warning',
      'info': 'Information',
      'loading': 'Loading...',
      'saving': 'Saving...',
      'deleting': 'Deleting...',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'view_all': 'View All',
      'see_more': 'See More',
      'no_data': 'No data available',
      'try_again': 'Try Again',
      'connection_error': 'Connection Error',
    },
    'es_ES': {
      // Configuración
      'settings': 'Configuración',
      'appearance': 'Apariencia',
      'dark_mode': 'Modo Oscuro',
      'dark_mode_subtitle': 'Activar tema oscuro',
      'notifications': 'Notificaciones',
      'notifications_subtitle': 'Recibir notificaciones de la app',
      'language': 'Idioma',
      'privacy': 'Privacidad',
      'privacy_security': 'Privacidad y Seguridad',
      'account': 'Cuenta',
      'edit_profile': 'Editar Perfil',
      'change_password': 'Cambiar Contraseña',
      'about_app': 'Acerca de la App',
      'app_version': 'Versión de la App',
      'terms_of_use': 'Términos de Uso',
      'privacy_policy': 'Política de Privacidad',
      'back': 'Volver',
      'select_language': 'Seleccionar Idioma',
      'close': 'CERRAR',
      
      // Login y Autenticación
      'login': 'INICIAR SESIÓN',
      'email': 'Correo',
      'password': 'Contraseña',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'sign_up': 'Registrarse',
      'enter': 'Entrar',
      'confirm_password': 'Confirmar Contraseña',
      'already_have_account': '¿Ya tienes una cuenta?',
      'create_account': 'Crear Cuenta',
      'reset_password': 'Restablecer Contraseña',
      'send_instructions': 'Enviar Instrucciones',
      
      // Home
      'hello': 'Hola',
      'options': 'Opciones',
      'users': 'Usuarios',
      'economic': 'Económico',
      'calendar': 'Calendario',
      'my_houses': 'Mis Casas',
      'my_profile': 'Mi Perfil',
      'settings_nav': 'Configuración',
      'organize_tasks': 'Organiza tus tareas de forma simple',
      'rights_reserved': 'Todos los derechos reservados',
      
      // Calendar
      'calendar_title': 'CALENDARIO',
      'today': 'Hoy',
      'tasks_for': 'Tareas para',
      'no_tasks_date': 'No hay tareas para esta fecha',
      'add_task_hint': 'Toca el botón + para agregar una tarea',
      'new_task': 'Nueva Tarea',
      'task_title': 'Título de la tarea *',
      'task_description': 'Descripción (opcional)',
      'task_color': 'Color de la tarea',
      'save_task': 'Guardar Tarea',
      'cancel': 'Cancelar',
      'task_added': '¡Tarea agregada con éxito!',
      'task_completed': '¡Tarea completada!',
      'enter_title': 'Por favor ingrese un título para la tarea',
      'select_date': 'Seleccionar Fecha',
      'select_time': 'Seleccionar Hora',
      
      // Users
      'members': 'Miembros',
      'add_member': '+ Agregar Miembro',
      'remove_member': '- Remover Miembro',
      'no_members': 'No hay miembros registrados',
      'add_member_hint': 'Haz clic en "+ Agregar Miembro" para agregar',
      'add_member_title': 'Agregar Miembro',
      'name': 'Nombre',
      'member_description': 'Descripción del Miembro', // CORRIGIDO: mudado de 'description'
      'confirm': 'Confirmar',
      'remove_member_title': 'Remover Miembro',
      'remove_confirmation': '¿Estás seguro de que quieres remover este miembro?',
      'remove': 'Remover',
      'edit_member': 'Editar Miembro',
      'save_changes': 'Guardar Cambios',
      
      // My Houses
      'my_houses_title': 'MIS CASAS',
      'no_houses': 'No hay casas registradas',
      'add_house_hint': 'Toca el botón + para crear tu primera casa',
      'create_house': 'Crear Nueva Casa',
      'house_name': 'Nombre de la Casa',
      'create': 'Crear',
      'family_question': '¿Quién significa una familia de forma simple?',
      'enter_house_name': 'Por favor ingrese un nombre para la casa',
      'select_house': 'Seleccionar Casa',
      'edit_house': 'Editar Casa',
      'delete_house': 'Eliminar Casa',
      'delete_house_confirmation': '¿Estás seguro de que quieres eliminar esta casa?',
      
      // Economic
      'economic_title': 'ECONÓMICO',
      'income': 'Ingreso',
      'expenses': 'Gastos',
      'balance': 'Saldo',
      'add_transaction': 'Agregar Transacción',
      'transaction_type': 'Tipo de Transacción',
      'amount': 'Cantidad',
      'date': 'Fecha',
      'category': 'Categoría',
      'transaction_description': 'Descripción de la Transacción', // CORRIGIDO: mudado de 'description'
      'income_categories': 'Categorías de Ingreso',
      'expense_categories': 'Categorías de Gasto',
      
      // Profile
      'profile': 'Perfil',
      'personal_info': 'Información Personal',
      'full_name': 'Nombre Completo',
      'phone': 'Teléfono',
      'address': 'Dirección',
      'save_profile': 'Guardar Perfil',
      'change_photo': 'Cambiar Foto',
      'logout': 'Cerrar Sesión',
      'logout_confirmation': '¿Estás seguro de que quieres cerrar sesión?',
      
      // Adicionales para Home
      'acesso_rapido': 'Acceso Rápido',
      'nenhuma_tarefa': 'No hay tareas pendientes',
      'adicione_tarefas': 'Agrega tareas en el calendario',
      'organize_tarefas': 'Organiza tus tareas de forma simple',
      'direitos_reservados': '© Todos los derechos reservados - 2025',
      'amanha': 'Mañana',
      'esta_semana': 'Esta Semana',
      'proxima_semana': 'Próxima Semana',
      
      // Mensajes Generales
      'success': 'Éxito',
      'error': 'Error',
      'warning': 'Advertencia',
      'info': 'Información',
      'loading': 'Cargando...',
      'saving': 'Guardando...',
      'deleting': 'Eliminando...',
      'search': 'Buscar',
      'filter': 'Filtrar',
      'sort': 'Ordenar',
      'view_all': 'Ver Todos',
      'see_more': 'Ver Más',
      'no_data': 'No hay datos disponibles',
      'try_again': 'Intentar Nuevamente',
      'connection_error': 'Error de conexión',
    },
  };

  static const Map<String, String> _languageNames = {
    'pt_BR': 'Português (Brasil)',
    'en_US': 'English (US)',
    'es_ES': 'Español',
  };

  Locale get currentLocale => _localeNotifier.value;

  String getCurrentLanguageName() {
    return _languageNames[_getLocaleKey(currentLocale)] ?? 'Português (Brasil)';
  }

  String translate(String key) {
    final localeKey = _getLocaleKey(currentLocale);
    return _translations[localeKey]?[key] ?? _translations['pt_BR']?[key] ?? key;
  }

  void setLocale(Locale locale) {
    _localeNotifier.value = locale;
    notifyListeners();
  }

  // Método para facilitar a mudança por código de idioma
  void changeLanguageByCode(String languageCode) {
    switch (languageCode) {
      case 'pt':
        setLocale(const Locale('pt', 'BR'));
        break;
      case 'en':
        setLocale(const Locale('en', 'US'));
        break;
      case 'es':
        setLocale(const Locale('es', 'ES'));
        break;
      default:
        setLocale(const Locale('pt', 'BR'));
    }
  }

  List<Map<String, String>> getAvailableLanguages() {
    return _languageNames.entries.map((entry) => {
      'code': entry.key,
      'name': entry.value,
    }).toList();
  }

  // Método para obter dias da semana baseado no idioma
  List<String> getWeekdays() {
    final locale = currentLocale.languageCode;
    switch (locale) {
      case 'en':
        return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      case 'es':
        return ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
      default: // 'pt'
        return ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    }
  }

  // Método para obter meses baseado no idioma
  List<String> getMonths() {
    final locale = currentLocale.languageCode;
    switch (locale) {
      case 'en':
        return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      case 'es':
        return ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      default: // 'pt'
        return ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    }
  }

  // Método para formatar data baseado no idioma
  String formatDate(DateTime date) {
    final weekdays = getWeekdays();
    final months = getMonths();
    return '${weekdays[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
  }

  // Método para formatar data completa (incluindo hora)
  String formatDateTime(DateTime date) {
    final weekdays = getWeekdays();
    final months = getMonths();
    final hora = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} • $hora';
  }

  String _getLocaleKey(Locale locale) {
    return '${locale.languageCode}_${locale.countryCode}';
  }

  // Método para adicionar listener
  void addListener(VoidCallback listener) {
    _localeNotifier.addListener(listener);
  }

  // Método para remover listener
  void removeListener(VoidCallback listener) {
    _localeNotifier.removeListener(listener);
  }

  // Dispose (opcional, para limpeza)
  void disposeService() {
    _localeNotifier.dispose();
  }
}

// Extensão para facilitar o uso
extension TranslateExtension on String {
  String translate(BuildContext context) {
    return LanguageService().translate(this);
  }
}