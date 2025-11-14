import 'package:flutter/material.dart';

class LanguageService {
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
      
      // Usuários
      'members': 'Membros',
      'add_member': '+ Add Membro',
      'remove_member': '- Remover Membro',
      'no_members': 'Nenhum membro cadastrado',
      'add_member_hint': 'Clique em "+ Add Membro" para adicionar',
      'add_member_title': 'Adicionar Membro',
      'name': 'Nome',
      'description': 'Descrição',
      'confirm': 'Confirmar',
      'remove_member_title': 'Remover Membro',
      'remove_confirmation': 'Tem certeza que deseja remover este membro?',
      'remove': 'Remover',
      
      // Minhas Casas
      'my_houses_title': 'MINHAS CASAS',
      'no_houses': 'Nenhuma casa cadastrada',
      'add_house_hint': 'Toque no botão + para criar sua primeira casa',
      'create_house': 'Criar Nova Casa',
      'house_name': 'Nome da Casa',
      'create': 'Criar',
      'family_question': 'Quem significa uma família de forma simples?',
      'enter_house_name': 'Por favor, insira um nome para a casa',
      
      // Econômico
      'economic_title': 'ECONÔMICO',
      
      // Perfil
      'profile': 'Perfil',
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
      
      // Users
      'members': 'Members',
      'add_member': '+ Add Member',
      'remove_member': '- Remove Member',
      'no_members': 'No members registered',
      'add_member_hint': 'Click on "+ Add Member" to add',
      'add_member_title': 'Add Member',
      'name': 'Name',
      'description': 'Description',
      'confirm': 'Confirm',
      'remove_member_title': 'Remove Member',
      'remove_confirmation': 'Are you sure you want to remove this member?',
      'remove': 'Remove',
      
      // My Houses
      'my_houses_title': 'MY HOUSES',
      'no_houses': 'No houses registered',
      'add_house_hint': 'Tap the + button to create your first house',
      'create_house': 'Create New House',
      'house_name': 'House Name',
      'create': 'Create',
      'family_question': 'Who means a family in a simple way?',
      'enter_house_name': 'Please enter a name for the house',
      
      // Economic
      'economic_title': 'ECONOMIC',
      
      // Profile
      'profile': 'Profile',
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
      
      // Users
      'members': 'Miembros',
      'add_member': '+ Agregar Miembro',
      'remove_member': '- Remover Miembro',
      'no_members': 'No hay miembros registrados',
      'add_member_hint': 'Haz clic en "+ Agregar Miembro" para agregar',
      'add_member_title': 'Agregar Miembro',
      'name': 'Nombre',
      'description': 'Descripción',
      'confirm': 'Confirmar',
      'remove_member_title': 'Remover Miembro',
      'remove_confirmation': '¿Estás seguro de que quieres remover este miembro?',
      'remove': 'Remover',
      
      // My Houses
      'my_houses_title': 'MIS CASAS',
      'no_houses': 'No hay casas registradas',
      'add_house_hint': 'Toca el botón + para crear tu primera casa',
      'create_house': 'Crear Nueva Casa',
      'house_name': 'Nombre de la Casa',
      'create': 'Crear',
      'family_question': '¿Quién significa una familia de forma simple?',
      'enter_house_name': 'Por favor ingrese un nombre para la casa',
      
      // Economic
      'economic_title': 'ECONÓMICO',
      
      // Profile
      'profile': 'Perfil',
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
  }

  List<Map<String, String>> getAvailableLanguages() {
    return _languageNames.entries.map((entry) => {
      'code': entry.key,
      'name': entry.value,
    }).toList();
  }

  String _getLocaleKey(Locale locale) {
    return '${locale.languageCode}_${locale.countryCode}';
  }
}

// Extensão para facilitar o uso
extension TranslateExtension on String {
  String translate(BuildContext context) {
    return LanguageService().translate(this);
  }
}