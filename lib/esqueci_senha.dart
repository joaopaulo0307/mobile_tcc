// recuperar_senha.dart
import 'package:flutter/material.dart';

class EsqueciSenha extends StatelessWidget {
  const EsqueciSenha({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: const Center(child: Text('Página de Recuperação de Senha')),
    );
  }
}