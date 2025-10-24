import 'package:flutter/material.dart';
import 'acesso/cadastro.dart';
import 'home.dart';
import 'acesso/esqueci_senha.dart';
import 'dart:ui'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_tcc/meu_casas.dart';

const Color primaryColor = Color(0xFF133A67);
const Color secondaryColor = Color(0xFF5E83AE);
const Color containerColor = Color.fromARGB(255, 55, 56, 57);
const Color textFieldColor = Colors.white;
const Color textColor = Colors.white;
const Color accentColor = Colors.blueGrey;

// ✅ Incrementado apenas o necessário:
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // garante inicialização do Flutter
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/cadastro': (context) => const CadastroPage(),
        '/home': (context) {
          final nome = ModalRoute.of(context)!.settings.arguments as String;
          return HomePage(nome: nome);
        },
        '/esqueci_senha': (context) => const LoginSc(),
      },
    );
  }
}

// ------------------ HEADER ------------------
class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 2,
      centerTitle: false,
      title: const CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: Text(
          "TD",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

// ------------------ FOOTER ------------------
class Footer extends StatelessWidget {
  final String? text;
  final String? subText;

  const Footer({super.key, this.text, this.subText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(height: 10),
          Text(
            text ?? "Organize suas tarefas de forma simples",
            style: const TextStyle(color: textColor, fontSize: 14),
            textAlign: TextAlign.center,
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
          Text(
            subText ?? "Contato | Sobre | Termos de Uso",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          const Text(
            "© Todos os direitos reservados - 2025",
            style: TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ------------------ LANDING PAGE ------------------
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: Stack(
        children: [
          // Imagem de fundo
          SizedBox.expand(
            child: Image.asset(
              'lib/assets/images/fundo-tcc-mobile.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  LoginForm(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

// ------------------ LOGIN FORM ------------------
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: _emailController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 79, 73, 72),
          borderRadius: BorderRadius.circular(20),
        ),
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor, insira seu email';
                  if (!value.contains('@')) return 'Por favor, insira um email válido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Senha",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor, insira sua senha';
                  if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/esqueci_senha');
                  },
                  child: const Text(
                    "Esqueci minha senha",
                    style: TextStyle(
                      color: Color(0xFF5E83AE),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF5E83AE),
                      side: const BorderSide(color: Colors.black),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 25,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastro');
                    },
                    child: const Text("CADASTRE-SE"),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _login,
                    child: const Text("ENTRAR"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
