import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_tcc/user_service.dart'; // Importar o UserService

class PerfilPage extends StatefulWidget {
  const PerfilPage({
    super.key,
    String? userEmail,
    List<String>? tarefasRealizadas,
  });

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File? _fotoPerfil;
  final TextEditingController descricaoController = TextEditingController();
  int tarefasVisiveis = 3;

  Future<void> _selecionarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _fotoPerfil = File(imagem.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Inicializar com dados de exemplo se estiver vazio
    if (UserService.tarefasRealizadas.isEmpty) {
      UserService.initializeWithSampleData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalTarefas = UserService.tarefasRealizadas.length;
    final mostrarTodas = tarefasVisiveis >= totalTarefas;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1C2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF142F47),
        title: const Text(
          'MEU PERFIL',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabeçalho com foto e nome
            Container(
              color: const Color(0xFF142F47),
              padding: const EdgeInsets.only(top: 40, bottom: 30),
              child: Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _selecionarFoto,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[400],
                        backgroundImage:
                            _fotoPerfil != null ? FileImage(_fotoPerfil!) : null,
                        child: _fotoPerfil == null
                            ? const Icon(Icons.add_a_photo, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      UserService.userName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        // TODO: Implementar gerenciamento de conta
                      },
                      child: const Text(
                        "Gerenciar sua conta",
                        style: TextStyle(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Corpo
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Seção Sobre
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sobre",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.email, color: Colors.white70),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                UserService.userEmail,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Seção Trabalhou
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Trabalhou",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "As pessoas só veem o que podem acessar",
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (UserService.tarefasRealizadas.isEmpty)
                              const Text(
                                "Nenhuma tarefa realizada ainda",
                                style: TextStyle(color: Colors.white70),
                              ),
                            for (int i = 0;
                                i < (mostrarTodas ? totalTarefas : tarefasVisiveis);
                                i++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  "• ${UserService.tarefasRealizadas[i]}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                            if (totalTarefas > 3)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tarefasVisiveis =
                                        mostrarTodas ? 3 : totalTarefas;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    mostrarTodas ? "Mostrar menos" : "Mostrar mais",
                                    style: const TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Seção Descrição
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Descrição",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 6),
                  CustomTextField(
                    controller: descricaoController,
                    hint: "Insira um texto",
                  ),

                  const SizedBox(height: 30),

                  // Rodapé
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      // Image.asset(
                      //   'assets/logo.png',
                      //   height: 40,
                      // ),
                      const SizedBox(height: 10),
                      const Text(
                        "Organize suas tarefas de forma simples",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(FontAwesomeIcons.facebook, color: Colors.white),
                          SizedBox(width: 15),
                          Icon(Icons.camera_alt, color: Colors.white),
                          SizedBox(width: 15),
                          Icon(Icons.mail, color: Colors.white),
                          SizedBox(width: 15),
                          Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "© Todos os direitos reservados - 2025",
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Campo discreto reutilizável
class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const CustomTextField({
    super.key, 
    required this.hint, 
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white70, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}