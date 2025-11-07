import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_tcc/meu_casas.dart';
import 'acesso/auth_service.dart';
import 'acesso/cadastro.dart';
import 'acesso/esqueci_senha.dart';
import 'package:mobile_tcc/home.dart';
import 'dart:ui';
import 'config.dart';

// Cores
const Color primaryColor = Color(0xFF133A67);
const Color secondaryColor = Color(0xFF5E83AE);
const Color containerColor = Color.fromARGB(255, 55, 56, 57);
const Color textColor = Colors.white;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await AuthService.initialize();
    print('App inicializado com sucesso');
  } catch (e) {
    print('Erro na inicialização do app: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const LandingPage());

          case '/cadastro':
            return MaterialPageRoute(builder: (_) => const CadastroPage());

          case '/minhas_casas':
            return MaterialPageRoute(builder: (_) => const MeuCasas());

          case '/home':
            final casa = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (_) => HomePage(casa: casa),
            );

          case '/esqueci_senha':
            return MaterialPageRoute(builder: (_) => const EsqueciSenhaPage());

          case '/config':
            return MaterialPageRoute(builder: (_) => const ConfigPage());

          default:
            return MaterialPageRoute(builder: (_) {
              return const Scaffold(
                body: Center(child: Text('Rota não encontrada')),
              );
            });
        }
      },
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}

// ==================== LANDING PAGE (TELA DE LOGIN) ====================

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header simplificado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: primaryColor,
                child: Text(
                  "TD",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    
                    // Título LOGIN
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Formulário de login
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          // Campo Email
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                border: InputBorder.none,
                                hintText: 'seu@email.com',
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Campo Senha
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Senha',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                border: InputBorder.none,
                                hintText: '••••••',
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Link Esqueceu a senha
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/esqueci_senha');
                              },
                              child: const Text(
                                'Esqueceu a sua senha?',
                                style: TextStyle(
                                  color: primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Botões CADASTRE-SE e ENTRAR
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/cadastro');
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: primaryColor,
                                    side: const BorderSide(color: primaryColor),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('CADASTRE-SE'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(context, '/minhas_casas');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('ENTRAR'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Texto final
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Organize suas tarefas de forma simples',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Rodapé
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      color: Colors.grey[100],
                      child: const Column(
                        children: [
                          Text(
                            '© Todos os direitos reservados - 2025',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
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
}