import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_tcc/calend%C3%A1rio/calendario.dart';
import 'package:mobile_tcc/usuarios.dart';
import 'package:mobile_tcc/economic/economico.dart';
import 'package:mobile_tcc/perfil.dart';
import 'package:mobile_tcc/meu_casas.dart';


class HomePage extends StatefulWidget {
  final String nome;
  final String casaSelecionada;
  final String casaEndereco;
  
  const HomePage({
    super.key, 
    required this.nome, 
    required this.casaSelecionada,
    required this.casaEndereco,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Map<String, Widget> _opcoes;

  @override
  void initState() {
    super.initState();
    _opcoes = {
      "ECONÔMICO": const Economico(),
      "USUÁRIOS": const Usuarios(),
      "CALENDÁRIO": const CalendarPage(),
      "MINHAS CASAS": MeuCasas(nome: widget.nome),
      "MEU PERFIL": Perfil(
        userEmail: "${widget.nome}@exemplo.com",
        tarefasRealizadas: [
          "Comprar materiais",
          "Enviar relatório",
          "Limpar a casa",
          "Passear com o cachorro"
        ],
      ),
      "CONFIGURAÇÕES": Container(),
    };
  }

  void _navegarParaTela(String titulo) {
    if (_opcoes.containsKey(titulo) && titulo != "HOME") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _opcoes[titulo]!),
      );
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1A3B6B),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF133A67),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFF133A67)),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.nome,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  widget.casaSelecionada,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          _drawerItem("ECONÔMICO", Icons.attach_money, () => _navegarParaTela("ECONÔMICO")),
          _drawerItem("USUÁRIOS", Icons.people, () => _navegarParaTela("USUÁRIOS")),
          _drawerItem("CALENDÁRIO", Icons.calendar_today, () => _navegarParaTela("CALENDÁRIO")),
          const Divider(color: Colors.white54),
          _drawerItem("MINHAS CASAS", Icons.home, () => _navegarParaTela("MINHAS CASAS")),
          _drawerItem("MEU PERFIL", Icons.person, () => _navegarParaTela("MEU PERFIL")),
          _drawerItem("CONFIGURAÇÕES", Icons.settings, () => _navegarParaTela("CONFIGURAÇÕES")),
        ],
      ),
    );
  }

  Widget _drawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3B6B),
        title: Text(widget.casaSelecionada, style: const TextStyle(color: Colors.white)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card de boas-vindas
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF27226D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "sexta-feira, 24 de outubro",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Olá, ${widget.nome}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Casa: ${widget.casaSelecionada}",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    widget.casaEndereco,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Tarefas do dia
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C4A77),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text("SEX", style: TextStyle(color: Colors.white.withOpacity(0.8))),
                        const SizedBox(height: 6),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF102B4E),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text("24", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF466A91),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              "PASSEAR COM O CACHORRO",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF466A91),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              "COMPRAR ARROZ",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(color: Colors.white54),
            const SizedBox(height: 16),
            const Text("Opções", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 16),

            // Grid de opções
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildOptionButton("Usuários", FontAwesomeIcons.users, () => _navegarParaTela("USUÁRIOS")),
                  _buildOptionButton("Econômico", FontAwesomeIcons.chartLine, () => _navegarParaTela("ECONÔMICO")),
                  _buildOptionButton("Minhas Casas", FontAwesomeIcons.home, () => _navegarParaTela("MINHAS CASAS")),
                  _buildOptionButton("Perfil", FontAwesomeIcons.user, () => _navegarParaTela("MEU PERFIL")),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A3B6B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}