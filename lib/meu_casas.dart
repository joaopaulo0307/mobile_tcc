import 'package:flutter/material.dart';
import 'package:mobile_tcc/home.dart';
import 'acesso/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_tcc/main.dart';

class MeuCasas extends StatefulWidget {
  const MeuCasas({super.key});

  @override
  State<MeuCasas> createState() => _MeuCasasState();
}

class _MeuCasasState extends State<MeuCasas> {
  final List<Map<String, String>> _casas = [
    {
      'nome': 'Mens da casa',
      'endereco': 'Endereço',
    },
    {
      'nome': 'Nome da casa',
      'endereco': 'Endereço',
    }
  ];
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF133A67),
        title: const Text('MINHAS CASAS'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Lista de casas
          Expanded(
            child: _casas.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Nenhuma casa cadastrada',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _casas.length,
                    itemBuilder: (context, index) {
                      final casa = _casas[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              casa['nome']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF133A67),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              casa['endereco']!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          
          // Texto "Quem significa uma família de forma simples?"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: const Text(
              "Quem significa uma família de forma simples?",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Rodapé
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF133A67),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Organize suas tarefas de forma simples",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "© Todos os direitos reservados - 2025",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF133A67),
        onPressed: _mostrarDialogoCriarCasa,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _mostrarDialogoCriarCasa() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar Nova Casa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome da Casa',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _enderecoController,
              decoration: const InputDecoration(
                labelText: 'Endereço',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _limparCampos();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF133A67),
            ),
            onPressed: _criarCasa,
            child: const Text('Criar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _criarCasa() {
    if (_nomeController.text.trim().isNotEmpty && 
        _enderecoController.text.trim().isNotEmpty) {
      setState(() {
        _casas.add({
          'nome': _nomeController.text.trim(),
          'endereco': _enderecoController.text.trim(),
        });
      });
      Navigator.pop(context);
      _limparCampos();
      
      // Navegar para a Home após criar a casa
      final casaCriada = _casas.last;
      _entrarNaCasa(casaCriada);
    }
  }

  void _entrarNaCasa(Map<String, String> casa) {
    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: casa,
    );
  }

  void _limparCampos() {
    _nomeController.clear();
    _enderecoController.clear();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }
}