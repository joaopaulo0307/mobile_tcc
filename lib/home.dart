import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Serviços
import './services/theme_service.dart';
import './services/language_service.dart';

// Telas
import './calendario/calendario.dart';
import './economic/economico.dart';
import './meu_casas.dart';
import './perfil.dart';
import './usuarios.dart';
import './config.dart';

class HomePage extends StatefulWidget {
  final Map<String, String> casa;
  
  const HomePage({super.key, required this.casa});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _userName = "Usuário";

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return MaterialApp(
          theme: themeService.themeData, // Aplica o tema globalmente
          home: Scaffold(
            key: _scaffoldKey,
            appBar: _buildAppBar(context, themeService),
            drawer: _buildDrawer(context, themeService),
            body: _buildBody(context, themeService),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeService themeService) {
    final languageService = Provider.of<LanguageService>(context, listen: false);

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<LanguageService>(
            builder: (context, languageService, child) {
              return Text(
                '${languageService.translate('ola')} $_userName',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          Text(
            _getCurrentDate(context),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.language),
          onSelected: (value) {
            languageService.changeLanguageByCode(value);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'pt',
              child: Row(
                children: [
                  Icon(Icons.language, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Text('Português'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'en',
              child: Row(
                children: [
                  Icon(Icons.language, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Text('English'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'es',
              child: Row(
                children: [
                  Icon(Icons.language, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Text('Español'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context, ThemeService themeService) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
        final textColor = Theme.of(context).colorScheme.onSurface;

        return Drawer(
          backgroundColor: backgroundColor,
          child: Column(
            children: [
              _buildDrawerHeader(context),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      icon: Icons.attach_money,
                      title: languageService.translate('economico'),
                      textColor: textColor,
                      onTap: () => _navigateToEconomico(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.calendar_today,
                      title: languageService.translate('calendario'),
                      textColor: textColor,
                      onTap: () => _navigateTo(context, const CalendarioPage()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.people,
                      title: languageService.translate('usuarios'),
                      textColor: textColor,
                      onTap: () => _navigateTo(context, const Usuarios()),
                    ),
                    Divider(color: Theme.of(context).dividerColor),
                    _buildDrawerItem(
                      icon: Icons.house,
                      title: languageService.translate('minhas_casas'),
                      textColor: textColor,
                      onTap: () => _navigateToHome(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.person,
                      title: languageService.translate('meu_perfil'),
                      textColor: textColor,
                      onTap: () => _navigateTo(context, const PerfilPage()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      title: languageService.translate('configuracoes'),
                      textColor: textColor,
                      onTap: () => _navigateTo(context, const ConfigPage()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ThemeService themeService) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              _buildListaTarefas(context, languageService),
              _buildSecaoOpcoes(context, languageService),
              _buildFooter(context, languageService),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListaTarefas(BuildContext context, LanguageService languageService) {
    return Expanded(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
              const SizedBox(height: 16),
              Text(
                languageService.translate('nenhuma_tarefa'),
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                languageService.translate('adicione_tarefas'),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecaoOpcoes(BuildContext context, LanguageService languageService) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageService.translate('acesso_rapido'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildGridOpcoes(context, languageService),
        ],
      ),
    );
  }

  Widget _buildGridOpcoes(BuildContext context, LanguageService languageService) {
    final opcoes = [
      {
        'icon': Icons.people,
        'label': languageService.translate('usuarios'),
        'onTap': () => _navigateTo(context, const Usuarios()),
      },
      {
        'icon': Icons.attach_money,
        'label': languageService.translate('economico'),
        'onTap': () => _navigateToEconomico(context),
      },
      {
        'icon': Icons.calendar_today,
        'label': languageService.translate('calendario'),
        'onTap': () => _navigateTo(context, const CalendarioPage()),
      },
      {
        'icon': Icons.house,
        'label': languageService.translate('minhas_casas'),
        'onTap': () => _navigateToHome(context),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: opcoes.length,
      itemBuilder: (context, index) {
        final opcao = opcoes[index];
        return _buildOpcaoItem(
          context: context,
          icon: opcao['icon'] as IconData,
          label: opcao['label'] as String,
          onTap: opcao['onTap'] as VoidCallback,
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context, LanguageService languageService) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            languageService.translate('organize_tarefas'),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, 
              fontSize: 14
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            languageService.translate('direitos_reservados'),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7), 
              fontSize: 12
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares
  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              child: Text(
                "TD",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.casa['nome'] ?? 'Minha Casa',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _userName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildOpcaoItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context); // Fecha o drawer
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _navigateToEconomico(BuildContext context) {
    Navigator.pop(context); // Fecha o drawer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Economico(casa: widget.casa),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MeuCasas()),
      (route) => false,
    );
  }

  String _getCurrentDate(BuildContext context) {
    final now = DateTime.now();
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final locale = languageService.currentLocale;
    
    if (locale.languageCode == 'en') {
      final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]}';
    } else if (locale.languageCode == 'es') {
      final days = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
      final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]}';
    } else {
      final days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
      final months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
      return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]}';
    }
  }
}