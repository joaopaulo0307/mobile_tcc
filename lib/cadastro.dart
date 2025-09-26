
import 'package:flutter/material.dart';

class CadastroPage extends StatelessWidget {
  const CadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: const Color(0xFF133A67),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
   
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
     
                Navigator.pop(context);
              },
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}