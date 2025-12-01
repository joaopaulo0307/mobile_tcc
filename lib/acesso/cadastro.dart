import 'package:flutter/material.dart';
import '../acesso/auth_service.dart';
import 'dart:ui';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureSenha = true;
  bool _obscureConfirmarSenha = true;

  // ✅ ADICIONE ESTAS KEYS PARA OS TESTES
  final Key _nomeFieldKey = const Key('nome_field');
  final Key _emailFieldKey = const Key('email_field');
  final Key _senhaFieldKey = const Key('senha_field');
  final Key _confirmarSenhaFieldKey = const Key('confirmar_senha_field');
  final Key _senhaVisibilityKey = const Key('senha_visibility');
  final Key _confirmarVisibilityKey = const Key('confirmar_visibility');
  final Key _botaoCadastrarKey = const Key('botao_cadastrar');
  final Key _botaoVoltarKey = const Key('botao_voltar');

  // ==================== MÉTODOS DE VALIDAÇÃO ====================
  String? _validarNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu nome completo';
    }
    if (value.length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres';
    }
    return null;
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

  // ==================== MÉTODOS DE AÇÃO ====================
  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_senhaController.text != _confirmarSenhaController.text) {
      _mostrarErro('As senhas não coincidem');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.cadastrar(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        senha: _senhaController.text,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        _mostrarSucesso(result['message']);
        
        // Navegar de volta para login após cadastro
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        _mostrarErro(result['message']);
      }
    } catch (e) {
      if (mounted) {
        _mostrarErro('Erro inesperado: $e');
      }
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

  void _mostrarSucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(mensagem),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ==================== WIDGETS ====================

  // BOTÃO DE VOLTAR FLUTUANTE
  Widget _buildBotaoVoltar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: IconButton(
          key: _botaoVoltarKey, // ✅ KEY ADICIONADA
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  // BACKGROUND
  Widget _buildBackground() {
    return Stack(
      children: [
        // Imagem de fundo que ocupa toda a tela
        SizedBox.expand(
          child: Image.asset(
            'lib/assets/images/fundo-tcc-mobile.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: const Color(0xFF133A67));
            },
          ),
        ),
        // Overlay com blur
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }

  // FORMULÁRIO DE CADASTRO
  Widget _buildCadastroForm() {
    return Center(
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
                    // Título
                    _buildTitulo(),
                    const SizedBox(height: 20),
                    
                    // Campos do formulário
                    _buildCampoNome(),
                    const SizedBox(height: 12),
                    
                    _buildCampoEmail(),
                    const SizedBox(height: 12),
                    
                    _buildCampoSenha(),
                    const SizedBox(height: 12),
                    
                    _buildCampoConfirmarSenha(),
                    const SizedBox(height: 20),
                    
                    // Botão de cadastro
                    _buildBotaoCadastro(),
                    const SizedBox(height: 16),
                    
                    // Link para login
                    _buildLinkLogin(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // COMPONENTES DO FORMULÁRIO
  Widget _buildTitulo() {
    return const Text(
      'CADASTRO',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCampoNome() {
    return TextFormField(
      key: _nomeFieldKey, // ✅ KEY ADICIONADA
      controller: _nomeController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: "Nome completo",
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: _validarNome,
    );
  }

  Widget _buildCampoEmail() {
    return TextFormField(
      key: _emailFieldKey, // ✅ KEY ADICIONADA
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: _validarEmail,
    );
  }

  Widget _buildCampoSenha() {
    return TextFormField(
      key: _senhaFieldKey, // ✅ KEY ADICIONADA
      controller: _senhaController,
      obscureText: _obscureSenha,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: "Senha",
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: IconButton(
          key: _senhaVisibilityKey, // ✅ KEY ADICIONADA
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
    );
  }

  Widget _buildCampoConfirmarSenha() {
    return TextFormField(
      key: _confirmarSenhaFieldKey, // ✅ KEY ADICIONADA
      controller: _confirmarSenhaController,
      obscureText: _obscureConfirmarSenha,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: "Confirmar senha",
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: IconButton(
          key: _confirmarVisibilityKey, // ✅ KEY ADICIONADA
          icon: Icon(
            _obscureConfirmarSenha ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmarSenha = !_obscureConfirmarSenha;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, confirme sua senha';
        }
        if (value != _senhaController.text) {
          return 'As senhas não coincidem';
        }
        return null;
      },
      onFieldSubmitted: (_) => _cadastrar(),
    );
  }

  Widget _buildBotaoCadastro() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5E83AE)),
        ),
      );
    }

    return ElevatedButton(
      key: _botaoCadastrarKey, // ✅ KEY ADICIONADA
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5E83AE),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      onPressed: _cadastrar,
      child: const Text(
        'CADASTRAR',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLinkLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Já tem uma conta?',
          style: TextStyle(color: Colors.white70),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Faça login',
            style: TextStyle(
              color: Color(0xFF5E83AE),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== BUILD PRINCIPAL ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fundo ocupando toda a tela
          _buildBackground(),
          
          // Formulário centralizado
          _buildCadastroForm(),
          
          // Botão de voltar flutuante
          _buildBotaoVoltar(),
        ],
      ),
    );
  }

  // ==================== DISPOSE ====================
  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }
}