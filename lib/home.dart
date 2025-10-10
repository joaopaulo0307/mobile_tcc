import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mobile_tcc/usuarios.dart';

class HomePage extends StatefulWidget {
  final String nome;

  const HomePage({super.key, required this.nome});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, Widget> _opcoes = {
    "Minhas Casas": Container(),
    "Calendário": Container(),
    "Econômico": Container(),
    "Usuários": Usuarios(),
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
      drawer: Drawer(
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
            _drawerItem("HOME"),
            _drawerItem("ECONÔMICO"),
            _drawerItem("USUÁRIOS"),
            const Divider(color: Colors.white24),
            _drawerItem("MINHAS CASAS"),
            _drawerItem("MEU PERFIL"),
            _drawerItem("CONFIGURAÇÕES"),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ====== CABEÇALHO SUPERIOR ======
            Container(
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
                        prefixIcon: const Icon(Icons.search),
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
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // ====== CARD ROXO ======
                    Container(
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
                    ),

                    const SizedBox(height: 25),

                    // ====== TÍTULO “OPÇÕES” ======
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

                    // ====== BOTÕES DE OPÇÕES ======
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

                    const Divider(
                        color: Colors.white38, indent: 20, endIndent: 20),

                    const SizedBox(height: 40),

                    // ====== RODAPÉ ======
                    Container(
                      width: double.infinity,
                      color: const Color(0xFF0A347E),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
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
                              Icon(FontAwesomeIcons.instagram,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 20),
                              Icon(FontAwesomeIcons.facebook,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 20),
                              Icon(FontAwesomeIcons.google,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 20),
                              Icon(FontAwesomeIcons.whatsapp,
                                  color: Colors.white, size: 20),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "© Todos os direitos reservados - 2025",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====== BOTÃO DE OPÇÃO ======
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

  // ====== ITEM DO MENU LATERAL ======
  Widget _drawerItem(String title) {
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
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
