import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // ✅ NOVO ARQUIVO FIREBASE
import 'package:mobile_tcc/meu_casas.dart';
import 'package:provider/provider.dart';
import '../acesso/auth_service.dart';
import '../acesso/cadastro.dart';
import '../acesso/esqueci_senha.dart';
import 'package:mobile_tcc/home.dart';
import 'package:mobile_tcc/config.dart';
import '../services/theme_service.dart';
import '../services/formatting_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // ✅ INICIALIZAÇÃO DO FIREBASE
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado com sucesso');
    
    // Verificar se o usuário já está logado
    await AuthService.initialize();
    print('✅ App inicializado com sucesso');
    
    // Log do usuário atual
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('👤 Usuário logado: ${user.email}');
    } else {
      print('🔒 Nenhum usuário logado');
    }
    
  } catch (e) {
    print('❌ Erro na inicialização do app: $e');
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeService()),
        Provider(create: (context) => FormattingService()),
        StreamProvider<User?>( // ✅ NOVO PROVIDER PARA USUÁRIO FIREBASE
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeService.themeData,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
          ],
          home: const AuthWrapper(), // ✅ ALTERADO PARA WRAPPER DE AUTENTICAÇÃO
          routes: {
            '/cadastro': (context) => const CadastroPage(),
            '/minhas_casas': (context) => const MeuCasas(),
            '/home': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>? ?? {};
              return HomePage(casa: args);
            },
            '/esqueci_senha': (context) => const EsqueciSenhaPage(),
            '/config': (context) => const ConfigPage(),
          },
        );
      },
    );
  }
}

// ✅ WRAPPER PARA GERENCIAR AUTENTICAÇÃO
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    
    if (user == null) {
      return const LandingPage();
    } else {
      // Verificar se o usuário verificou o email (opcional)
      if (!user.emailVerified) {
        return EmailVerificationScreen(user: user);
      }
      return const MeuCasas();
    }
  }
}

// ✅ TELA DE VERIFICAÇÃO DE EMAIL
class EmailVerificationScreen extends StatefulWidget {
  final User user;
  
  const EmailVerificationScreen({super.key, required this.user});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isSendingEmail = false;
  bool _isLoading = true;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
    widget.user.reload(); // Recarrega o usuário para verificar status atualizado
  }

  Future<void> _checkEmailVerification() async {
    await widget.user.reload();
    setState(() => _isLoading = false);
  }

  Future<void> _sendVerificationEmail() async {
    if (_resendCooldown > 0) return;
    
    setState(() => _isSendingEmail = true);
    
    try {
      await widget.user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Email de verificação enviado!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Configurar cooldown de 60 segundos
      setState(() => _resendCooldown = 60);
      _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            if (_resendCooldown > 0) {
              _resendCooldown--;
            } else {
              timer.cancel();
            }
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar email: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSendingEmail = false);
      }
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifique seu email'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.email_outlined,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Verificação de Email',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Enviamos um email de verificação para:',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.user.email ?? 'Email não disponível',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Por favor, verifique sua caixa de entrada e clique no link de verificação.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Após verificar, clique no botão abaixo para continuar.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _checkEmailVerification,
              icon: _isLoading 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: Text(_isLoading ? 'Verificando...' : 'Já verifiquei meu email'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _isSendingEmail || _resendCooldown > 0 ? null : _sendVerificationEmail,
              icon: const Icon(Icons.send),
              label: _resendCooldown > 0
                  ? Text('Reenviar em $_resendCooldowns')
                  : Text(_isSendingEmail ? 'Enviando...' : 'Reenviar email'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text('Usar outra conta'),
            ),
          ],
        ),
      ),
    );
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

  // ✅ AUTENTICAÇÃO COM FIREBASE
  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();
      
      // Tentar login com Firebase
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      
      if (!mounted) return;
      
      // Verificar se o email foi verificado
      if (userCredential.user?.emailVerified == false) {
        // Não faz logout, apenas redireciona para tela de verificação
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Por favor, verifique seu email antes de entrar.'),
            backgroundColor: Colors.orange,
          ),
        );
        // O AuthWrapper cuidará do redirecionamento
      } else {
        // Login bem-sucedido, AuthWrapper redirecionará para /minhas_casas
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login realizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String mensagemErro = 'Erro ao fazer login';
      
      switch (e.code) {
        case 'user-not-found':
          mensagemErro = 'Usuário não encontrado';
          break;
        case 'wrong-password':
          mensagemErro = 'Senha incorreta';
          break;
        case 'invalid-email':
          mensagemErro = 'Email inválido';
          break;
        case 'user-disabled':
          mensagemErro = 'Esta conta foi desativada';
          break;
        case 'too-many-requests':
          mensagemErro = 'Muitas tentativas. Tente novamente mais tarde';
          break;
        default:
          mensagemErro = 'Erro: ${e.message}';
      }
      
      _mostrarErro(mensagemErro);
    } catch (e) {
      _mostrarErro('Erro inesperado: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ✅ LOGIN COM GOOGLE (OPCIONAL)
  Future<void> _loginComGoogle() async {
    try {
      setState(() => _isLoading = true);
      // Adicione a lógica de login com Google aqui
      // Você precisará do pacote google_sign_in
    } catch (e) {
      _mostrarErro('Erro ao entrar com Google: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red, 
        content: Text(mensagem),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
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
                    return Container(color: ThemeService.primaryColor);
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
                          // Botão para alternar tema
                          IconButton(
                            icon: Icon(
                              themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              themeService.toggleTheme();
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
                                  color: themeService.isDarkMode 
                                    ? Colors.grey[800]!.withOpacity(0.9)
                                    : const Color.fromARGB(255, 79, 73, 72),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: MediaQuery.of(context).size.width * 0.85,
                                constraints: const BoxConstraints(maxWidth: 400),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Título "LOGIN"
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
                                            style: TextStyle(
                                              color: themeService.isDarkMode ? Colors.white : Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: themeService.isDarkMode 
                                                ? Colors.grey[700] 
                                                : Colors.white.withOpacity(0.9),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8), 
                                                borderSide: BorderSide.none
                                              ),
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                              hintText: 'seu@email.com',
                                              hintStyle: TextStyle(
                                                color: themeService.isDarkMode ? Colors.white70 : Colors.black54,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) return 'Por favor, insira seu email';
                                              final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                                              if (!emailRegex.hasMatch(value)) return 'Por favor, insira um email válido';
                                              return null;
                                            },
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
                                            style: TextStyle(
                                              color: themeService.isDarkMode ? Colors.white : Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: themeService.isDarkMode 
                                                ? Colors.grey[700] 
                                                : Colors.white.withOpacity(0.9),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8), 
                                                borderSide: BorderSide.none
                                              ),
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                              hintText: '••••••',
                                              hintStyle: TextStyle(
                                                color: themeService.isDarkMode ? Colors.white70 : Colors.black54,
                                              ),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _obscureSenha ? Icons.visibility : Icons.visibility_off, 
                                                  color: themeService.isDarkMode ? Colors.white70 : Colors.grey
                                                ),
                                                onPressed: () => setState(() => _obscureSenha = !_obscureSenha),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) return 'Por favor, insira sua senha';
                                              if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
                                              return null;
                                            },
                                            onFieldSubmitted: (_) => _fazerLogin(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      
                                      // Link Esqueceu a senha
                                      GestureDetector(
                                        onTap: () => Navigator.pushNamed(context, '/esqueci_senha'),
                                        child: const Text(
                                          'Esqueceu a senha?',
                                          style: TextStyle(
                                            color: Colors.white, 
                                            fontSize: 14, 
                                            decoration: TextDecoration.underline
                                          ),
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
                                              child: const Text(
                                                'CADASTRAR', 
                                                style: TextStyle(fontWeight: FontWeight.bold)
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: _isLoading ? null : _fazerLogin,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: ThemeService.primaryColor,
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(vertical: 16),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                disabledBackgroundColor: ThemeService.primaryColor.withOpacity(0.5),
                                              ),
                                              child: _isLoading
                                                  ? const SizedBox(
                                                      height: 20, 
                                                      width: 20, 
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2, 
                                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                                                      )
                                                    )
                                                  : const Text(
                                                      'ENTRAR', 
                                                      style: TextStyle(fontWeight: FontWeight.bold)
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      // Divisor "OU"
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        child: Row(
                                          children: [
                                            Expanded(child: Divider(color: Colors.white70)),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Text('OU', style: TextStyle(color: Colors.white70)),
                                            ),
                                            Expanded(child: Divider(color: Colors.white70)),
                                          ],
                                        ),
                                      ),
                                      
                                      // Botão de login com Google (opcional)
                                      OutlinedButton.icon(
                                        onPressed: _isLoading ? null : _loginComGoogle,
                                        icon: const Icon(Icons.g_mobiledata, size: 24),
                                        label: const Text('Entrar com Google'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: const BorderSide(color: Colors.white),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
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
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF133A67), // Azul escuro
                            Color(0xFF1E4A7A), // Azul médio
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          // Logo/Imagem
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              backgroundImage: AssetImage('lib/assets/images/logo-mobile.png'),
                            ),
                          ),
                          
                          // Textos
                          const Column(
                            children: [
                              Text(
                                'Organize suas tarefas de forma simples',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Todos os direitos reservados - 2025',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
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
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }
}