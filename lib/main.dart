import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_tcc/meu_casas.dart';
import '../acesso/auth_service.dart';
import '../acesso/cadastro.dart';
import '../acesso/esqueci_senha.dart';
import 'package:mobile_tcc/home.dart';
import 'dart:ui';
import 'package:mobile_tcc/config.dart';
import '../serviços/theme_service.dart'; // Adicionado

// Cores (mantidas para compatibilidade)
const Color primaryColor = Color(0xFF133A67);
const Color secondaryColor = Color(0xFF5E83AE);
const Color containerColor = Color.fromARGB(255, 55, 56, 57);
const Color textColor = Colors.white;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await AuthService.initialize();
    await ThemeService.initialize(); // Adicionado
    print('App inicializado com sucesso');
  } catch (e) {
    print('Erro na inicialização do app: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Escutar mudanças no tema
    ThemeService.themeNotifier.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(), // Adicionado
      darkTheme: _buildDarkTheme(), // Adicionado
      themeMode: ThemeService.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Adicionado
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

  // Adicionado: Tema claro
  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: ThemeService.primaryColor,
      colorScheme: const ColorScheme.light(
        primary: ThemeService.primaryColor,
        secondary: ThemeService.secondaryColor,
        background: ThemeService.backgroundLight,
        surface: ThemeService.cardColorLight,
      ),
      scaffoldBackgroundColor: ThemeService.backgroundLight,
      cardColor: ThemeService.cardColorLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeService.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: ThemeService.textColorLight),
        bodyMedium: TextStyle(color: ThemeService.textColorLight),
        titleLarge: TextStyle(color: ThemeService.textColorLight),
        titleMedium: TextStyle(color: ThemeService.textColorLight),
      ),
    );
  }

  // Adicionado: Tema escuro
  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: ThemeService.primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: ThemeService.primaryColor,
        secondary: ThemeService.secondaryColor,
        background: ThemeService.backgroundDark,
        surface: ThemeService.cardColorDark,
      ),
      scaffoldBackgroundColor: ThemeService.backgroundDark,
      cardColor: ThemeService.cardColorDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeService.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: ThemeService.textColorDark),
        bodyMedium: TextStyle(color: ThemeService.textColorDark),
        titleLarge: TextStyle(color: ThemeService.textColorDark),
        titleMedium: TextStyle(color: ThemeService.textColorDark),
      ),
    );
  }

  @override
  void dispose() {
    ThemeService.themeNotifier.dispose();
    super.dispose();
  }
}

// ==================== LANDING PAGE (TELA DE LOGIN) ====================

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Removido: bool _isDarkMode = false; (agora controlado pelo ThemeService)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _obscureSenha = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Removido: _toggleTheme() (agora controlado apenas na página de Configurações)

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final res = await AuthService.login(
        email: _emailController.text.trim(),
        senha: _senhaController.text.trim(),
      );

      if (!mounted) return;

      if (res['success']) {
        final nome = res['user']['nome'];
        Navigator.pushReplacementNamed(context, '/minhas_casas', arguments: nome);
      } else {
        _mostrarErro(res['message']);
      }
    } catch (e) {
      _mostrarErro('Erro ao fazer login');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(mensagem),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu email';
    }
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um email válido';
    }
    return null;
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Imagem de fundo
          SizedBox.expand(
            child: Image.asset(
              'lib/assets/images/fundo-tcc-mobile.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: const Color(0xFF133A67));
              },
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
          SafeArea(
            child: Column(
              children: [
                // Header com logo (removido botão de tema)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Alterado para center
                    children: [
                      CircleAvatar(
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
                      // Removido: IconButton do tema
                    ],
                  ),
                ),
                
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ClipRRect(
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
                                  const Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  
                                  // Campo Email
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Email',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(0.9),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                          hintText: 'seu@email.com',
                                          hintStyle: const TextStyle(color: Colors.black54),
                                        ),
                                        validator: _validarEmail,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  // Campo Senha
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Senha',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _senhaController,
                                        obscureText: _obscureSenha,
                                        textInputAction: TextInputAction.done,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(0.9),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                          hintText: '••••••',
                                          hintStyle: const TextStyle(color: Colors.black54),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureSenha ? Icons.visibility : Icons.visibility_off,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureSenha = !_obscureSenha;
                                              });
                                            },
                                          ),
                                        ),
                                        validator: _validarSenha,
                                        onFieldSubmitted: (_) => _fazerLogin(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  // Link Esqueceu a senha
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/esqueci_senha');
                                      },
                                      child: const Text(
                                        'Esqueceu a sua senha?',
                                        style: TextStyle(
                                          color: Color(0xFF5E83AE),
                                          fontSize: 14,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  
                                  // Botões CADASTRE-SE e ENTRAR
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/cadastro');
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            side: const BorderSide(color: Colors.white),
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          child: const Text(
                                            'CADASTRE-SE',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: _isLoading ? null : _fazerLogin,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF5E83AE),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            elevation: 2,
                                          ),
                                          child: _isLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  ),
                                                )
                                              : const Text(
                                                  'ENTRAR',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Rodapé
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: Colors.black.withOpacity(0.7),
                  child: const Column(
                    children: [
                      Text(
                        'Organize suas tarefas de forma simples',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                                  
                      // Ícones de redes sociais
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white70,
                            size: 20,
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.favorite_border,
                            color: Colors.white70,
                            size: 20,
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.star_border,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        '© Todos os direitos reservados - 2025',
                        style: TextStyle(
                          color: Colors.white70,
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }
}