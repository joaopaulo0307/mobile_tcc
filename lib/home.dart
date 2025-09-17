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
// ignore: unused_import
import 'package:mobile_tcc/usuarios.dart';

class HomePage extends StatefulWidget {
  final String nome; // recebe o nome do cadastro

  const HomePage({super.key, required this.nome});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
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
                  _buildOptionButton(Icons.add_home, "Criar Nova casa"),
                  _buildOptionButton(Icons.home, "Lar"),
                  _buildOptionButton(Icons.task, "Tarefas"),
                  _buildOptionButton(Icons.attach_money, "Gastos"),
                  _buildOptionButton(Icons.people, "Usuários"),
                  _buildOptionButton(Icons.archive, "Arq. de Tarefas"),
                ],
              ),

              const SizedBox(height: 30),

              // Rodapé
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

  static Widget _buildOptionButton(IconData icon, String text) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      
    );
  }
}