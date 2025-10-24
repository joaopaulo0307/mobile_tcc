import 'package:flutter/material.dart';
import 'acesso/cadastro.dart';
import 'home.dart';
import 'acesso/esqueci_senha.dart';
import 'dart:ui'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_tcc/meu_casas.dart';
import 'acesso/auth_service.dart'; // Adicione esta importação

const Color primaryColor = Color(0xFF133A67);
const Color secondaryColor = Color(0xFF5E83AE);
const Color containerColor = Color.fromARGB(255, 55, 56, 57);
const Color textFieldColor = Colors.white;
const Color textColor = Colors.white;
const Color accentColor = Colors.blueGrey;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar o serviço de autenticação
  await AuthService.initialize();
  
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
        '/minhas_casas': (context) {
          final nome = ModalRoute.of(context)!.settings.arguments as String;
          return MeuCasas(nome: nome);
        },
        '/home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return HomePage(
            nome: args['nome'], 
            casaSelecionada: args['casa'],
            casaEndereco: args['endereco'],
          );
        },
        '/esqueci_senha': (context) => const EsqueciSenhaPage(), // Atualize esta linha
      },
    );
  }
}

// ... (Header, Footer, LandingPage permanecem iguais)

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _verificarLoginAutomático();
  }

  void _verificarLoginAutomático() async {
    if (await AuthService.isAuthenticated()) {
      final userData = await AuthService.getUserData();
      if (userData.isNotEmpty) {
        _navegarParaMinhasCasas(userData['nome']);
      }
    }
  }

  void _navegarParaMinhasCasas(String nome) {
    Navigator.pushReplacementNamed(
      context,
      '/minhas_casas',
      arguments: nome,
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final result = await AuthService.login(
        email: _emailController.text,
        senha: _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        final nome = result['user']['nome'] ?? _emailController.text.split('@')[0];
        _navegarParaMinhasCasas(nome);
      } else {
        _mostrarErro(result['message']);
      }
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(mensagem),
        duration: const Duration(seconds: 3),
      ),
    );
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
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5E83AE)),
                  ),
                )
              else
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