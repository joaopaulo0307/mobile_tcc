import 'package:flutter/material.dart';
import '../acesso/auth_service.dart';
import 'dart:ui';

class EsqueciSenhaPage extends StatefulWidget {
  const EsqueciSenhaPage({super.key});

  @override
  State<EsqueciSenhaPage> createState() => _EsqueciSenhaPageState();
}

class _EsqueciSenhaPageState extends State<EsqueciSenhaPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _emailEnviado = false;

  // ==================== MÉTODOS DE AÇÃO ====================
  Future<void> _enviarEmailRecuperacao() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.esqueciSenha(_emailController.text.trim());

      if (!mounted) return;

      if (result['success'] == true) {
        setState(() {
          _emailEnviado = true;
        });
        _mostrarSucesso(result['message']);
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

  void _voltarParaLogin() {
    Navigator.pop(context);
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _voltarParaLogin,
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

  // FORMULÁRIO DE RECUPERAÇÃO
  Widget _buildRecuperacaoForm() {
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
                    
                    // Conteúdo dinâmico baseado no estado
                    _emailEnviado ? _buildSucesso() : _buildFormulario(),
                    
                    const SizedBox(height: 16),
                    
                    // Link para voltar ao login (apenas quando não enviado)
                    if (!_emailEnviado) _buildLinkVoltar(),
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
      'RECUPERAR SENHA',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFormulario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Digite seu email para receber as instruções de recuperação de senha:',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        
        // Campo Email com título
        _buildCampoEmail(),
        const SizedBox(height: 20),
        
        // Botão de envio
        _buildBotaoEnviar(),
      ],
    );
  }

  Widget _buildCampoEmail() {
    return Column(
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
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintText: 'seu@email.com',
            hintStyle: const TextStyle(color: Colors.black54),
          ),
          validator: _validarEmail,
          onFieldSubmitted: (_) => _enviarEmailRecuperacao(),
        ),
      ],
    );
  }

  Widget _buildBotaoEnviar() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5E83AE)),
        ),
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5E83AE),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      onPressed: _enviarEmailRecuperacao,
      child: const Text(
        'ENVIAR INSTRUÇÕES',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSucesso() {
    return Column(
      children: [
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 60,
        ),
        const SizedBox(height: 20),
        const Text(
          'Email enviado com sucesso!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Verifique sua caixa de entrada (${_emailController.text}) e siga as instruções para redefinir sua senha.',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5E83AE),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
          onPressed: _voltarParaLogin,
          child: const Text(
            'VOLTAR AO LOGIN',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinkVoltar() {
    return TextButton(
      onPressed: _voltarParaLogin,
      child: const Text(
        'Voltar ao login',
        style: TextStyle(
          color: Color(0xFF5E83AE),
          fontWeight: FontWeight.bold,
        ),
      ),
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
          _buildRecuperacaoForm(),
          
          // Botão de voltar flutuante
          _buildBotaoVoltar(),
        ],
      ),
    );
  }

  // ==================== DISPOSE ====================
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}