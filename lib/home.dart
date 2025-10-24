import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_tcc/usuarios.dart';
import 'package:mobile_tcc/economic/economico.dart';
import 'package:mobile_tcc/perfil.dart';

class HomePage extends StatefulWidget {
  final String nome;
  const HomePage({super.key, required this.nome});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Map<String, Widget> _opcoes;

  @override
  void initState() {
    super.initState();
    // Inicializa o mapa de telas (não colocamos HomePage dentro de HomePage)
    _opcoes = {
      "HOME": Container(), // Pode ser apenas a tela atual
      "ECONÔMICO": const Economico(),
      "USUÁRIOS": const Usuarios(),
      "MINHAS CASAS": Container(),
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
      backgroundColor: const Color.fromARGB(255, 60, 60, 60),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 10),
          const Divider(
              color: Colors.white54, thickness: 1, indent: 25, endIndent: 25),
          _drawerItem("HOME", () {
            Navigator.pop(context);
          }),
          _drawerItem("ECONÔMICO", () {
            Navigator.pop(context);
            _navegarParaTela("ECONÔMICO");
          }),
          _drawerItem("USUÁRIOS", () {
            Navigator.pop(context);
            _navegarParaTela("USUÁRIOS");
          }),
          const Divider(
              color: Colors.white54, thickness: 1, indent: 25, endIndent: 25),
          _drawerItem("MINHAS CASAS", () {
            Navigator.pop(context);
            _navegarParaTela("MINHAS CASAS");
          }),
          _drawerItem("MEU PERFIL", () {
            Navigator.pop(context);
            _navegarParaTela("MEU PERFIL");
          }),
          _drawerItem("CONFIGURAÇÕES", () {
            Navigator.pop(context);
            _navegarParaTela("CONFIGURAÇÕES");
          }),
        ],
      ),
    );
  }

  Widget _drawerItem(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 35, 35, 35),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          dense: true,
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top bar
            Container(
              color: const Color(0xFF1A3B6B),
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Card de boas-vindas
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF27226D),
                borderRadius: BorderRadius.circular(16),
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
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Data e tarefas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateChip("Sex", "24"),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTaskButton("PASSEAR COM O CACHORRO"),
                        const SizedBox(height: 8),
                        _buildTaskButton("COMPRAR ARROZ"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Opções
            const Divider(color: Colors.white54),
            const SizedBox(height: 8),
            const Text("Opções",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildOptionButton("Usuários", FontAwesomeIcons.user,
                    () => _navegarParaTela("USUÁRIOS")),
                _buildOptionButton("Econômico", FontAwesomeIcons.moneyBill,
                    () => _navegarParaTela("ECONÔMICO")),
                _buildOptionButton("Minhas Casas", FontAwesomeIcons.house,
                    () => _navegarParaTela("MINHAS CASAS")),
                _buildOptionButton("Perfil", FontAwesomeIcons.userTie,
                    () => _navegarParaTela("MEU PERFIL")),
              ],
            ),

            const SizedBox(height: 40),

            // Rodapé
            Container(
              color: const Color(0xFF1A3B6B),
              padding: const EdgeInsets.symmetric(vertical: 24),
              width: double.infinity,
              child: Column(
                children: const [
                  Text("Alarma",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(
                    "Organize suas tarefas de forma simples",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.instagram, color: Colors.white),
                      SizedBox(width: 16),
                      Icon(FontAwesomeIcons.facebook, color: Colors.white),
                      SizedBox(width: 16),
                      Icon(FontAwesomeIcons.google, color: Colors.white),
                      SizedBox(width: 16),
                      Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "© Todos os direitos reservados – 2025",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widgets auxiliares
  Widget _buildDateChip(String dia, String numero) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2C4A77),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          Text(dia,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF102B4E),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(numero,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF466A91),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(text,
          style: const TextStyle(color: Colors.white, fontSize: 13)),
    );
  }

  Widget _buildOptionButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A3B6B),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
