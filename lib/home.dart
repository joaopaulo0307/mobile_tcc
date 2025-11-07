import 'package:flutter/material.dart';
import 'package:mobile_tcc/calend%C3%A1rio/calendario.dart';
import 'package:mobile_tcc/economic/economico.dart';
import 'package:mobile_tcc/meu_casas.dart';
import 'package:mobile_tcc/perfil.dart';
import 'package:mobile_tcc/usuarios.dart';
import 'package:mobile_tcc/config.dart';
import '../acesso/auth_service.dart';
import '../serviços/theme_service.dart';

class HomePage extends StatefulWidget {
  final Map<String, String> casa;
  
  const HomePage({super.key, required this.casa});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, dynamic>> _tarefas = [];
  String _userName = "Usuário";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userData = AuthService.getCurrentUser();
    if (userData != null && userData['nome'] != null) {
      setState(() {
        _userName = userData['nome']!;
      });
    }
  }

  // ==================== HEADER ====================

  PreferredSizeWidget _buildAppBar() {
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
          Text(
            'Olá, $_userName',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Qua 4',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  // ==================== DRAWER ====================

  Widget _buildDrawer() {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
        final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;
        
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
                      title: 'ECONÔMICO',
                      textColor: textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Economico()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.calendar_today,
                      title: 'CALENDÁRIO',
                      textColor: textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CalendarioPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.people,
                      title: 'USUÁRIOS',
                      textColor: textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Usuarios()),
                        );
                      },
                    ),
                    Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300]),
                    _buildDrawerItem(
                      icon: Icons.house,
                      title: 'MINHAS CASAS',
                      textColor: textColor,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MeuCasas()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.person,
                      title: 'MEU PERFIL',
                      textColor: textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PerfilPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      title: 'CONFIGURAÇÕES',
                      textColor: textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ConfigPage()),
                        );
                      },
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
              widget.casa['nome']!,
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

  // ==================== BODY - LISTA DE TAREFAS ====================

  Widget _buildListaTarefas() {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
        final cardColor = isDarkMode ? ThemeService.cardColorDark : ThemeService.cardColorLight;
        final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;

        return Expanded(
          child: Container(
            color: backgroundColor,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildTarefaItem(
                  titulo: 'PASSEAR COM O CACHORRO',
                  cardColor: cardColor,
                  textColor: textColor,
                ),
                _buildTarefaItem(
                  titulo: 'COMPRAR ARROZ',
                  cardColor: cardColor,
                  textColor: textColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTarefaItem({
    required String titulo,
    required Color cardColor,
    required Color textColor,
  }) {
    return Container(
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
              color: ThemeService.primaryColor,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== BODY - SEÇÃO DE OPÇÕES ====================

  Widget _buildSecaoOpcoes() {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
        final cardColor = isDarkMode ? ThemeService.cardColorDark : ThemeService.cardColorLight;
        final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;

        return Container(
          padding: const EdgeInsets.all(16),
          color: backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTituloOpcoes(textColor: textColor),
              const SizedBox(height: 16),
              _buildLinhaOpcoes1(cardColor: cardColor),
              const SizedBox(height: 16),
              _buildLinhaOpcoes2(cardColor: cardColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTituloOpcoes({required Color textColor}) {
    return Text(
      'Opções',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildLinhaOpcoes1({required Color cardColor}) {
    return Row(
      children: [
        _buildOpcaoItem(
          icon: Icons.people,
          label: 'Usuários',
          cardColor: cardColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Usuarios()),
            );
          },
        ),
        const SizedBox(width: 24),
        _buildOpcaoItem(
          icon: Icons.attach_money,
          label: 'Econômico',
          cardColor: cardColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Economico()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLinhaOpcoes2({required Color cardColor}) {
    return Row(
      children: [
        _buildOpcaoItem(
          icon: Icons.calendar_today,
          label: 'Calendário',
          cardColor: cardColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalendarioPage()),
            );
          },
        ),
        const SizedBox(width: 24),
        _buildOpcaoItem(
          icon: Icons.house,
          label: 'Minhas Casas',
          cardColor: cardColor,
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MeuCasas()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildOpcaoItem({
    required IconData icon,
    required String label,
    required Color cardColor,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
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
      ),
    );
  }

  // ==================== FOOTER ====================

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: ThemeService.primaryColor,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Organize suas tarefas de forma simples",
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "© Todos os direitos reservados - 2025",
            style: TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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

  // ==================== BUILD PRINCIPAL ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lista de tarefas
          _buildListaTarefas(),
          
          // Divisor
          _buildDivisor(),
          
          // Seção de opções
          _buildSecaoOpcoes(),
          
          // Rodapé
          _buildFooter(),
        ],
      ),
    );
  }
}