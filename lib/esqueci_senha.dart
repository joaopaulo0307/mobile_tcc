import 'package:flutter/material.dart';

// Defina a cor primária
const primaryColor = Color(0xFF133A67); // Usando um tom de azul

// Classe para a tela "Esqueci Senha"
class EsqueciSenha extends StatelessWidget {
  const EsqueciSenha({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Header(), 
    );
  }
}

// Classe Header separada para o cabeçalho
class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor, // Usando a cor primária
      height: 80,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Text(
              "TD", // Texto dentro do CircleAvatar
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

