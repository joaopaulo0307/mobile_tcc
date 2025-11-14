import 'package:flutter/material.dart';
import 'package:mobile_tcc/calendario/calendario.dart';
import 'package:mobile_tcc/economic/economico.dart';
import 'package:mobile_tcc/meu_casas.dart';
import 'package:mobile_tcc/perfil.dart';
import 'package:mobile_tcc/usuarios.dart';
import 'package:mobile_tcc/config.dart';
import '../acesso/auth_service.dart';
import '../serviços/theme_service.dart';
import '../serviços/language_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final Map<String, String> casa;
  
  const HomePage({super.key, required this.casa});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _userName = "Usuário";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userData = await AuthService.getUserData();

      if (!mounted) return;

      if (userData.isNotEmpty) {
        final nome = userData['nome'];
        if (nome is String && nome.isNotEmpty) {
          setState(() {
            _userName = nome;
          });
        } else {
          setState(() {
            _userName = "Usuário";
          });
        }
      } else {
        setState(() {
          _userName = widget.casa['nome'] ?? 'Usuário';
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar usuário: $e");
      setState(() {
        _userName = widget.casa['nome'] ?? 'Usuário';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados do usuário'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    final languageService = Provider.of<LanguageService>(context, listen: false);

    return AppBar(
      backgroundColor: ThemeService.primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<LanguageService>(
            builder: (context, languageService, child) {
              return Text(
                '${languageService.translate('ola')} $_userName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          Text(
            _getCurrentDate(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
      actions: [
        // Botão de seleção de idioma no AppBar
        PopupMenuButton<String>(
          icon: Icon(Icons.language, color: Colors.white),
          onSelected: (value) {
            languageService.changeLanguageByCode(value);
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 'pt',
              child: Row(
                children: [
                  Icon(Icons.language, color: ThemeService.primaryColor),
                  SizedBox(width: 8),
                  Text('Português'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'en',
              child: Row(
                children: [
                  Icon(Icons.language, color: ThemeService.primaryColor),
                  SizedBox(width: 8),
                  Text('English'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'es',
              child: Row(
                children: [
                  Icon(Icons.language, color: ThemeService.primaryColor),
                  SizedBox(width: 8),
                  Text('Español'),
                ],
              ),
            ),
          ],
        ),
      ],
      centerTitle: false,
    );
  }

  String _getCurrentDate() {
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

  Widget _buildDrawer() {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
        final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;

        return Consumer<LanguageService>(
          builder: (context, languageService, child) {
            return Drawer(
              backgroundColor: backgroundColor,
              child: Column(
                children: [
                  _buildDrawerHeader(),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildDrawerItem(
                          icon: Icons.attach_money,
                          title: languageService.translate('economico'),
                          textColor: textColor,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Economico(casa: {})),
                            );
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.calendar_today,
                          title: languageService.translate('calendario'),
                          textColor: textColor,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CalendarioPage()),
                            );
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.people,
                          title: languageService.translate('usuarios'),
                          textColor: textColor,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Usuarios()),
                            );
                          },
                        ),
                        Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300]),
                        _buildDrawerItem(
                          icon: Icons.house,
                          title: languageService.translate('minhas_casas'),
                          textColor: textColor,
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const MeuCasas()),
                              (route) => false,
                            );
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.person,
                          title: languageService.translate('meu_perfil'),
                          textColor: textColor,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PerfilPage()),
                            );
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.settings,
                          title: languageService.translate('configuracoes'),
                          textColor: textColor,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ConfigPage()),
                            );
                          },
                        ),
                        // Seletor de idioma no drawer
                        Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300]),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            'Idioma / Language',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        _buildLanguageSelector(textColor),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageSelector(Color textColor) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: languageService.currentLocale.languageCode,
                  isExpanded: true,
                  dropdownColor: ThemeService.primaryColor,
                  style: TextStyle(color: Colors.white),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      languageService.changeLanguageByCode(newValue);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'pt',
                      child: Text('🇧🇷 Português'),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('🇺🇸 English'),
                    ),
                    DropdownMenuItem(
                      value: 'es',
                      child: Text('🇪🇸 Español'),
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

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: ThemeService.primaryColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Text(
                "TD",
                style: TextStyle(
                  color: Color(0xFF133A67),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.casa['nome'] ?? 'Minha Casa',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _userName,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
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
      leading: Icon(icon, color: ThemeService.primaryColor),
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

  Widget _buildListaTarefas() {
    final tarefasPendentes = [];

    if (_isLoading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(
            color: ThemeService.primaryColor,
          ),
        ),
      );
    }

    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
        final cardColor = isDarkMode ? ThemeService.cardColorDark : ThemeService.cardColorLight;
        final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;

        return Consumer<LanguageService>(
          builder: (context, languageService, child) {
            return Expanded(
              child: Container(
                color: backgroundColor,
                child: tarefasPendentes.isEmpty 
                    ? _buildEmptyState(
                        textColor: textColor,
                        languageService: languageService,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: tarefasPendentes.length,
                        itemBuilder: (context, index) {
                          return _buildTarefaItem(
                            titulo: "Tarefa exemplo",
                            descricao: "Descrição exemplo",
                            data: DateTime.now(),
                            cor: Colors.blue,
                            cardColor: cardColor,
                            textColor: textColor,
                            languageService: languageService,
                            onTap: () {},
                            onConcluir: () {},
                          );
                        },
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState({
    required Color textColor,
    required LanguageService languageService,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            languageService.translate('nenhuma_tarefa'),
            style: TextStyle(
              fontSize: 16,
              color: textColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            languageService.translate('adicione_tarefas'),
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarefaItem({
    required String titulo,
    required String descricao,
    required DateTime data,
    required Color cor,
    required Color cardColor,
    required Color textColor,
    required LanguageService languageService,
    required VoidCallback onTap,
    required VoidCallback onConcluir,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: cor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatarData(data, languageService),
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                  if (descricao.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      descricao,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.check_circle_outline,
                color: ThemeService.primaryColor,
              ),
              onPressed: onConcluir,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecaoOpcoes() {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
        final cardColor = isDarkMode ? ThemeService.cardColorDark : ThemeService.cardColorLight;
        final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;

        return Consumer<LanguageService>(
          builder: (context, languageService, child) {
            return Container(
              padding: const EdgeInsets.all(16),
              color: backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageService.translate('acesso_rapido'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildGridOpcoes(
                    cardColor: cardColor,
                    languageService: languageService,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGridOpcoes({
    required Color cardColor,
    required LanguageService languageService,
  }) {
    final opcoes = [
      {
        'icon': Icons.people,
        'label': languageService.translate('usuarios'),
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Usuarios())),
      },
      {
        'icon': Icons.attach_money,
        'label': languageService.translate('economico'),
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Economico(casa: {}))),
      },
      {
        'icon': Icons.calendar_today,
        'label': languageService.translate('calendario'),
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarioPage())),
      },
      {
        'icon': Icons.house,
        'label': languageService.translate('minhas_casas'),
        'onTap': () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MeuCasas()),
          (route) => false,
        ),
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
          icon: opcao['icon'] as IconData,
          label: opcao['label'] as String,
          cardColor: cardColor,
          onTap: opcao['onTap'] as VoidCallback,
        );
      },
    );
  }

  Widget _buildOpcaoItem({
    required IconData icon,
    required String label,
    required Color cardColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
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
              color: ThemeService.primaryColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: ThemeService.primaryColor,
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

  Widget _buildFooter() {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          color: ThemeService.primaryColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                languageService.translate('organize_tarefas'),
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                languageService.translate('direitos_reservados'),
                style: TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivisor() {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final divisorColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
        return Container(
          height: 1,
          color: divisorColor,
        );
      },
    );
  }

  String _formatarData(DateTime data, LanguageService languageService) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(data.year, data.month, data.day);
    
    final hora = '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
    
    if (taskDate == today) {
      return '${languageService.translate('hoje')} • $hora';
    } else if (taskDate == today.add(const Duration(days: 1))) {
      return '${languageService.translate('amanha')} • $hora';
    } else {
      // Dias da semana em diferentes idiomas
      Map<String, List<String>> weekdays = {
        'pt': ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'],
        'en': ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        'es': ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'],
      };
      
      final locale = languageService.currentLocale.languageCode;
      final days = weekdays[locale] ?? weekdays['pt']!;
      
      return '${days[data.weekday - 1]}, ${data.day}/${data.month} • $hora';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListaTarefas(),
          _buildDivisor(),
          _buildSecaoOpcoes(),
          _buildFooter(),
        ],
      ),
    );
  }
}