import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_tcc/home.dart';
import 'package:mobile_tcc/main.dart';
import 'package:mobile_tcc/meu_casas.dart';
import 'package:mobile_tcc/usuarios.dart';
import 'package:mobile_tcc/economic/economico.dart';
import 'package:mobile_tcc/economic/historico.dart';
import 'package:mobile_tcc/calendário/calendario.dart';
import 'package:mobile_tcc/calendário/to-do.dart';

class Perfil extends StatefulWidget {
  final String userEmail; // Recebe o e-mail do login
  const Perfil({super.key, required this.userEmail});

  @override
  State<Perfil> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<Perfil> {
  File? _fotoPerfil;
  String nomeUsuario = "";

  // Controllers para campos de texto discretos
  final TextEditingController cargoController = TextEditingController();
  final TextEditingController organizacaoController = TextEditingController();
  final TextEditingController membrosController = TextEditingController(text: "Miguel, Danilo");
  final TextEditingController trabalhou1 = TextEditingController();
  final TextEditingController trabalhou2 = TextEditingController();
  final TextEditingController trabalhou3 = TextEditingController();
  final TextEditingController trabalhou4 = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

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
    // Simula nome do usuário a partir do e-mail
    nomeUsuario = widget.userEmail.split('@')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1C2F),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabeçalho com foto e nome
            Container(
              color: const Color(0xFF142F47),
              padding: const EdgeInsets.only(top: 60, bottom: 30),
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
                      nomeUsuario,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Gerenciar sua conta",
                        style: TextStyle(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Corpo da página
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Seção "Sobre"
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
                            const Icon(Icons.work, color: Colors.white70),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomTextField(
                                  controller: cargoController, hint: "Seu cargo"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.apartment, color: Colors.white70),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomTextField(
                                  controller: organizacaoController,
                                  hint: "Sua organização"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.email, color: Colors.white70),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.userEmail,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.group, color: Colors.white70),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomTextField(
                                  controller: membrosController, hint: "Membros"),
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
                            CustomTextField(
                                controller: trabalhou1, hint: "insira texto"),
                            CustomTextField(
                                controller: trabalhou2, hint: "insira texto"),
                            CustomTextField(
                                controller: trabalhou3, hint: "insira texto"),
                            CustomTextField(
                                controller: trabalhou4, hint: "insira texto"),
                            const SizedBox(height: 6),
                            const Text(
                              "Mostrar mais",
                              style: TextStyle(
                                  color: Colors.lightBlueAccent, fontSize: 12),
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
                      controller: descricaoController, hint: "Insira um texto"),
                  const SizedBox(height: 30),
                  // Rodapé
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Image.asset(
                        'assets/logo.png', // coloque sua logo aqui
                        height: 40,
                      ),
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

// Widget para campos discretos
class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const CustomTextField(
      {super.key, required this.hint, required this.controller});

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

      