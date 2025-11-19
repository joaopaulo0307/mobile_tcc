import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Serviços
import './services/theme_service.dart';
import './services/language_service.dart';
import './services/formatting_service.dart'; // ✅ NOVO SERViÇO

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
          theme: themeService.themeData,
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
    final formattingService = Provider.of<FormattingService>(context, listen: false); // ✅ NOVO

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
          Consumer2<LanguageService, FormattingService>(
            builder: (context, languageService, formattingService, child) {
              // ✅ USANDO FORMATTING SERVICE PARA DATA
              final currentDate = formattingService.formatDate(DateTime.now());
              return Text(
                currentDate,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                ),
              );
            },
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
    return Consumer2<LanguageService, FormattingService>(
      builder: (context, languageService, formattingService, child) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              _buildListaTarefas(context, languageService),
              _buildResumoFinanceiro(context, languageService, formattingService), // ✅ NOVA SEÇÃO
              _buildSecaoOpcoes(context, languageService),
              _buildFooter(context, languageService, formattingService), // ✅ ATUALIZADO
            ],
          ),
        );
      },
    );
  }

  // ✅ NOVA SEÇÃO: RESUMO FINANCEIRO
  Widget _buildResumoFinanceiro(BuildContext context, LanguageService languageService, FormattingService formattingService) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageService.translate('resumo_financeiro') ?? 'Resumo Financeiro',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoFinanceira(
                context: context,
                label: languageService.translate('saldo') ?? 'Saldo',
                value: formattingService.formatCurrency(2500.75), // ✅ MOEDA FORMATADA
                icon: Icons.account_balance_wallet,
                color: Colors.green,
              ),
              _buildInfoFinanceira(
                context: context,
                label: languageService.translate('despesas') ?? 'Despesas',
                value: formattingService.formatCurrency(1250.30), // ✅ MOEDA FORMATADA
                icon: Icons.money_off,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoFinanceira({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
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
              Consumer<FormattingService>(
                builder: (context, formattingService, child) {
                  // ✅ EXEMPLO DE PLURALIZAÇÃO DINÂMICA
                  final mensagemTarefas = formattingService.pluralize(
                    languageService.translate('uma_tarefa') ?? 'uma tarefa',
                    languageService.translate('varias_tarefas') ?? '{{count}} tarefas',
                    0
                  );
                  
                  return Text(
                    mensagemTarefas,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                languageService.translate('adicione_tarefas') ?? 'Adicione tarefas para começar',
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
            languageService.translate('acesso_rapido') ?? 'Acesso Rápido',
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
        'label': languageService.translate('usuarios') ?? 'Usuários',
        'onTap': () => _navigateTo(context, const Usuarios()),
      },
      {
        'icon': Icons.attach_money,
        'label': languageService.translate('economico') ?? 'Econômico',
        'onTap': () => _navigateToEconomico(context),
      },
      {
        'icon': Icons.calendar_today,
        'label': languageService.translate('calendario') ?? 'Calendário',
        'onTap': () => _navigateTo(context, const CalendarioPage()),
      },
      {
        'icon': Icons.house,
        'label': languageService.translate('minhas_casas') ?? 'Minhas Casas',
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

  Widget _buildFooter(BuildContext context, LanguageService languageService, FormattingService formattingService) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            languageService.translate('organize_tarefas') ?? 'Organize suas tarefas de forma simples',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, 
              fontSize: 14
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          // ✅ DATA FORMATADA NO FOOTER
          Consumer<FormattingService>(
            builder: (context, formattingService, child) {
              return Text(
                formattingService.formatDate(DateTime.now()),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8), 
                  fontSize: 12
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            languageService.translate('direitos_reservados') ?? 'Todos os direitos reservados',
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
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _navigateToEconomico(BuildContext context) {
    Navigator.pop(context);
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

  // ✅ MÉTODO ATUALIZADO USANDO FORMATTING SERVICE
  String _getCurrentDate(BuildContext context) {
    final formattingService = Provider.of<FormattingService>(context, listen: false);
    return formattingService.formatDate(DateTime.now());
  }
}