import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_tcc/meu_casas.dart';
import '../acesso/auth_service.dart';
import '../acesso/cadastro.dart';
import '../acesso/esqueci_senha.dart';
import 'package:mobile_tcc/home.dart';
import 'dart:ui';
import 'package:mobile_tcc/config.dart';
import '../serviços/theme_service.dart';
import '../serviços/language_service.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    ThemeService.themeNotifier.addListener(_onThemeChanged);
    LanguageService().localeNotifier.addListener(_onLanguageChanged);
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeService.themeNotifier.value ? ThemeMode.dark : ThemeMode.light,
      locale: LanguageService().currentLocale,
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
            return MaterialPageRoute(builder: (_) => HomePage(casa: casa));
          case '/esqueci_senha':
            return MaterialPageRoute(builder: (_) => const EsqueciSenhaPage());
          case '/config':
            return MaterialPageRoute(builder: (_) => const ConfigPage());
          default:
            return MaterialPageRoute(builder: (_) => Scaffold(
              body: Center(child: Text('Rota não encontrada')),
            ));
        }
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: ThemeService.primaryColor,
      colorScheme: const ColorScheme.light(
        primary: ThemeService.primaryColor,
        secondary: ThemeService.secondaryColor,
      ),
      scaffoldBackgroundColor: ThemeService.backgroundLight,
      cardColor: ThemeService.cardColorLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeService.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: ThemeService.primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: ThemeService.primaryColor,
        secondary: ThemeService.secondaryColor,
      ),
      scaffoldBackgroundColor: ThemeService.backgroundDark,
      cardColor: ThemeService.cardColorDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeService.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  @override
  void dispose() {
    ThemeService.themeNotifier.removeListener(_onThemeChanged);
    LanguageService().localeNotifier.removeListener(_onLanguageChanged);
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _obscureSenha = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Métodos de validação simplificados
  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, insira seu email';
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) return 'Por favor, insira um email válido';
    return null;
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, insira sua senha';
    if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
    return null;
  }

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final res = await AuthService.login(
        email: _emailController.text.trim(),
        senha: _senhaController.text.trim(),
      );

      if (!mounted) return;

      if (res['success']) {
        Navigator.pushReplacementNamed(context, '/minhas_casas');
      } else {
        _mostrarErro(res['message']);
      }
    } catch (e) {
      _mostrarErro('Erro ao fazer login');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(mensagem)),
    );
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
          // Overlay escuro
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFF133A67),
                        child: Text("TD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      // Seletor de idioma simplificado
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.language, color: Colors.white),
                        onSelected: (String languageCode) {
                          final parts = languageCode.split('_');
                          LanguageService().setLocale(Locale(parts[0], parts[1]));
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              value: 'pt_BR',
                              child: Text('Português (BR)'),
                            ),
                            PopupMenuItem(
                              value: 'en_US',
                              child: Text('English (US)'),
                            ),
                            PopupMenuItem(
                              value: 'es_ES',
                              child: Text('Español'),
                            ),
                          ];
                        },
                      ),
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
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        style: const TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(0.9),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
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
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _senhaController,
                                        obscureText: _obscureSenha,
                                        textInputAction: TextInputAction.done,
                                        style: const TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(0.9),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                          hintText: '••••••',
                                          hintStyle: const TextStyle(color: Colors.black54),
                                          suffixIcon: IconButton(
                                            icon: Icon(_obscureSenha ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                                            onPressed: () => setState(() => _obscureSenha = !_obscureSenha),
                                          ),
                                        ),
                                        validator: _validarSenha,
                                        onFieldSubmitted: (_) => _fazerLogin(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  // Link Esqueceu a senha
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(context, '/esqueci_senha'),
                                    child: const Text(
                                      'Esqueceu a sua senha?',
                                      style: TextStyle(color: Color(0xFF5E83AE), fontSize: 14, decoration: TextDecoration.underline),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  
                                  // Botões
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () => Navigator.pushNamed(context, '/cadastro'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            side: const BorderSide(color: Colors.white),
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          child: const Text('CADASTRE-SE', style: TextStyle(fontWeight: FontWeight.bold)),
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
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          child: _isLoading
                                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                                              : const Text('ENTRAR', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Rodapé
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.black.withOpacity(0.7),
                  child: const Column(
                    children: [
                      Text(
                        'Organize suas tarefas de forma simples',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '© Todos os direitos reservados - 2025',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
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