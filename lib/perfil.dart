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



class PerfilPage extends StatefulWidget {
  final String userEmail; // Recebe o e-mail do login
  const PerfilPage({super.key, required this.userEmail});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File? _fotoPerfil;
  String nomeUsuario = "";

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
      backgroundColor: const Color(0xFF0F1C2F), // Azul escuro do fundo
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF142F47), // Azul mais claro
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
                        const Text("Sobre",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Icon(Icons.work, color: Colors.white70),
                            SizedBox(width: 8),
                            Text("Seu cargo",
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Icon(Icons.apartment, color: Colors.white70),
                            SizedBox(width: 8),
                            Text("Sua Organização",
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.email, color: Colors.white70),
                            const SizedBox(width: 8),
                            Text(widget.userEmail,
                                style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Icon(Icons.group, color: Colors.white70),
                            SizedBox(width: 8),
                            Text("Membros: Miguel, Danilo",
                                style: TextStyle(color: Colors.white70)),
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
                      const Text("Trabalhou",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text("As pessoas só veem o que podem acessar",
                          style: TextStyle(color: Colors.white54, fontSize: 12)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• insira texto",
                                style: TextStyle(color: Colors.white70)),
                            Text("• insira texto",
                                style: TextStyle(color: Colors.white70)),
                            Text("• insira texto",
                                style: TextStyle(color: Colors.white70)),
                            Text("• insira texto",
                                style: TextStyle(color: Colors.white70)),
                            SizedBox(height: 6),
                            Text("Mostrar mais",
                                style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Seção Descrição
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Descrição",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Insira um texto",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF2B2B2B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
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
