import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_tcc/usuarios.dart';
import 'package:mobile_tcc/economic/economico.dart';

class HomePage extends StatefulWidget {
  final String nome;

  const HomePage({super.key, required this.nome});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, Widget> _opcoes = {
    "Minhas Casas": Container(), // Substitua pela tela real quando tiver
    "Calendário": Container(),    // Substitua pela tela real quando tiver
    "Econômico": const Economico(),
    "Usuários": const Usuarios(),
  };

  void _navegarParaTela(String titulo) {
    if (_opcoes.containsKey(titulo)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _opcoes[titulo]!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO SUPERIOR
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildWelcomeCard(),
                    const SizedBox(height: 25),
                    _buildOptionsSection(),
                    const SizedBox(height: 40),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0A347E),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.nome.isNotEmpty ? widget.nome : "Usuário",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem("HOME", () => Navigator.pop(context)),
          _buildDrawerItem("ECONÔMICO", () {
            Navigator.pop(context);
            _navegarParaTela("Econômico");
          }),
          _buildDrawerItem("USUÁRIOS", () {
            Navigator.pop(context);
            _navegarParaTela("Usuários");
          }),
          _buildDrawerItem("CALENDÁRIO", () {
            Navigator.pop(context);
            _navegarParaTela("Calendário");
          }),
          const Divider(color: Colors.white24),
          _buildDrawerItem("MINHAS CASAS", () {
            Navigator.pop(context);
            _navegarParaTela("Minhas Casas");
          }),
          _buildDrawerItem("MEU PERFIL", () => Navigator.pop(context)),
          _buildDrawerItem("CONFIGURAÇÕES", () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 55, 55, 55),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF0A347E),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 18,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Hinted search text",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color.fromARGB(255, 230, 230, 230),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF241F69),
            Color(0xFF502E96),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "quarta-feira, 4 de Maio",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Olá, ${widget.nome}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Opções",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const Divider(color: Colors.white38, indent: 20, endIndent: 20),
        const SizedBox(height: 12),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            _buildOptionButton("Usuários"),
            _buildOptionButton("Econômico"),
            _buildOptionButton("Calendário"),
            _buildOptionButton("Minhas Casas"),
          ],
        ),
        const Divider(color: Colors.white38, indent: 20, endIndent: 20),
      ],
    );
  }

  Widget _buildOptionButton(String text) {
    return ElevatedButton(
      onPressed: () => _navegarParaTela(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0A347E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0A347E),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(height: 10),
          const Text(
            "Organize suas tarefas de forma simples",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(FontAwesomeIcons.instagram, color: Colors.white, size: 20),
              SizedBox(width: 20),
              Icon(FontAwesomeIcons.facebook, color: Colors.white, size: 20),
              SizedBox(width: 20),
              Icon(FontAwesomeIcons.google, color: Colors.white, size: 20),
              SizedBox(width: 20),
              Icon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "© Todos os direitos reservados - 2025",
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}