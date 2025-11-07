import 'package:flutter/material.dart';
import 'package:mobile_tcc/calend%C3%A1rio/calendario.dart';
import 'package:mobile_tcc/economic/economico.dart';
import 'package:mobile_tcc/meu_casas.dart';
import 'package:mobile_tcc/perfil.dart';
import 'package:mobile_tcc/usuarios.dart';
import 'package:mobile_tcc/config.dart';
import 'package:mobile_tcc/main.dart';

class HomePage extends StatefulWidget {
  final Map<String, String> casa;
  
  const HomePage({super.key, required this.casa});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, dynamic>> _tarefas = [];

  // ==================== HEADER ====================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF133A67),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ola, Ullian Pirana',
            style: TextStyle(
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
    return Drawer(
      child: Column(
        children: [
          // Header do Drawer
          _buildDrawerHeader(),
          
          // Itens do Drawer
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.attach_money,
                  title: 'ECONÔMICO',
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Usuarios()),
                    );
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.house,
                  title: 'MINHAS CASAS',
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
  }

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF133A67),
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
            Text(
              widget.casa['endereco']!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
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
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF133A67)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  // ==================== BODY - LISTA DE TAREFAS ====================

  Widget _buildListaTarefas() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTarefaItem(
            titulo: 'PASSEAR COM O CACHORRO',
          ),
          _buildTarefaItem(
            titulo: 'COMPRAR ARROZ',
          ),
        ],
      ),
    );
  }

  Widget _buildTarefaItem({required String titulo}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
              color: const Color(0xFF133A67),
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
                    color: Colors.grey[700],
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
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTituloOpcoes(),
          const SizedBox(height: 16),
          _buildLinhaOpcoes1(),
          const SizedBox(height: 16),
          _buildLinhaOpcoes2(),
        ],
      ),
    );
  }

  Widget _buildTituloOpcoes() {
    return const Text(
      'Opções',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF133A67),
      ),
    );
  }

  Widget _buildLinhaOpcoes1() {
    return Row(
      children: [
        _buildOpcaoItem(
          icon: Icons.people,
          label: 'Usuários',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Usuarios()),
            );
          },
        ),
        const SizedBox(width: 24),
        _buildOpcaoItem(
          icon: Icons.attach_money,
          label: 'Econômico',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Economico()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLinhaOpcoes2() {
    return Row(
      children: [
        _buildOpcaoItem(
          icon: Icons.calendar_today,
          label: 'Calendário',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CalendarioPage()),
            );
          },
        ),
        const SizedBox(width: 24),
        _buildOpcaoItem(
          icon: Icons.house,
          label: 'Minhas Casas',
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
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
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
                color: const Color(0xFF133A67),
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF133A67),
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
      color: const Color(0xFF133A67),
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
    return Container(
      height: 1,
      color: Colors.grey[300],
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