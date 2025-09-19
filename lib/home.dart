import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:mobile_tcc/cadastro.dart';
// ignore: unused_import
import 'package:mobile_tcc/calendar.dart';
// ignore: unused_import
import 'package:mobile_tcc/financas.dart';
// ignore: unused_import
import 'package:mobile_tcc/lista_compras.dart';
// ignore: unused_import
import 'package:mobile_tcc/perfil.dart';
// ignore: unused_import
import 'package:mobile_tcc/to-do.dart';
import 'package:mobile_tcc/usuarios.dart'; // Mantida para a navegação

class HomePage extends StatefulWidget {
  final String nome; // recebe o nome do cadastro

  const HomePage({super.key, required this.nome});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Mapa para controlar as ações de cada botão
  final Map<String, Widget> _opcoes = {
    "Criar Nova casa": Container(), // Substitua pelo widget apropriado
    "Lar": Container(),
    "Tarefas": Container(),
    "Gastos": Container(),
    "Usuários": Usuarios(), // Página de usuários
    "Arq. de Tarefas": Container(),
  };

  void _navegarParaTela(String titulo) {
    Widget tela = _opcoes[titulo] ?? Container();
    
    if (titulo == "Usuários") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Usuarios()),
      );
    }
    // Adicione outras condições para outras telas aqui
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                color: Colors.blue[900],
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 20,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Pesquisar...",
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Card de boas-vindas
              SizedBox(height: 70),
              Container(
                margin: const EdgeInsets.all(30),
                padding: const EdgeInsets.all(80),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 79, 73, 196),
                      Color.fromARGB(255, 100, 38, 163)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nome.isNotEmpty
                          ? "Olá, ${widget.nome}"
                          : "Olá!",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Opções
              SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Opções",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              ),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _buildOptionButton(Icons.add_home, "Criar Nova casa", onPressed: () => _navegarParaTela("Criar Nova casa")),
                  _buildOptionButton(Icons.home, "Lar", onPressed: () => _navegarParaTela("Lar")),
                  _buildOptionButton(Icons.task, "Tarefas", onPressed: () => _navegarParaTela("Tarefas")),
                  _buildOptionButton(Icons.attach_money, "Gastos", onPressed: () => _navegarParaTela("Gastos")),
                  _buildOptionButton(Icons.people, "Usuários", onPressed: () => _navegarParaTela("Usuários")),
                  _buildOptionButton(Icons.archive, "Arq. de Tarefas", onPressed: () => _navegarParaTela("Arq. de Tarefas")),
                ],
              ),

              const SizedBox(height: 30),

              // Rodapé
              SizedBox(height: 100),
              Container(
                color: Colors.blue[900],
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Organize suas tarefas de forma simples",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(FontAwesomeIcons.facebook, color: Colors.white),
                        Icon(FontAwesomeIcons.instagram, color: Colors.white),
                        Icon(FontAwesomeIcons.google, color: Colors.white),
                        Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "© Todos os direitos reservados - 2025",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(IconData icon, String text, {VoidCallback? onPressed}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}