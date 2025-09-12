import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              color: const Color(0xFF133A67),
              height: 100,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),

            // CARROSSEL SIMPLES
            Container(
              color: const Color(0xFF133A67),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    color: Colors.white,
                    child: const Center(
                      child: Text(
                        "CARROSSEL / BANNER",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: index == 0 ? Colors.orange : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // LOGIN
            Container(
              color: const Color(0xFF133A67),
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAE0C8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            filled: true,
                            fillColor: Colors.grey[300],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Senha",
                            filled: true,
                            fillColor: Colors.grey[300],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Esqueci minha senha",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                "CADASTRE-SE",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5A7E92),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text("ENTRAR"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("ou continue com", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(FontAwesomeIcons.instagram, size: 28, color: Colors.white),
                      SizedBox(width: 20),
                      Icon(FontAwesomeIcons.facebook, size: 28, color: Colors.white),
                      SizedBox(width: 20),
                      Icon(FontAwesomeIcons.google, size: 28, color: Colors.white),
                      SizedBox(width: 20),
                      Icon(FontAwesomeIcons.whatsapp, size: 28, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),

            // RODAPÉ
            Container(
              color: const Color(0xFF133A67),
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lado esquerdo
                  Column(
                    children: const [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Organize suas tarefas de forma simples",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Lado direito
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Termos | Privacidade",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Contatos:",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(FontAwesomeIcons.instagram, color: Colors.white, size: 18),
                          SizedBox(width: 10),
                          Icon(FontAwesomeIcons.facebook, color: Colors.white, size: 18),
                          SizedBox(width: 10),
                          Icon(FontAwesomeIcons.google, color: Colors.white, size: 18),
                          SizedBox(width: 10),
                          Icon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 18),
                        ],
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
