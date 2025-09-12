import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nomeController = TextEditingController();
  String nome = "";

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
                          hintText: "Hinted search text",
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

              // Card de boas-vindas com campo para nome
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nomeController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Digite seu nome",
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          nome = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      nome.isNotEmpty ? "Olá, $nome" : "Olá!",
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
                        Icon(Icons.facebook, color: Colors.white),
                        Icon(Icons.instagram, color: Colors.white),
                        Icon(Icons.google, color: Colors.white),
                        Icon(Icons.whatsapp, color: Colors.white),
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
