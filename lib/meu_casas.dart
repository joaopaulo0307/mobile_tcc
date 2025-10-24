import 'package:flutter/material.dart';
import 'dart:async';

class MeuCasas extends StatefulWidget {
  const MeuCasas({super.key});

  @override
  State<MeuCasas> createState() => _MeuCasasState();
}

class _MeuCasasState extends State<MeuCasas>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> _casas = [];

  // Controlador para a animação do brilho
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Inicializa o controlador de animação
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _adicionarCasa(String nome, String endereco) {
    setState(() {
      _casas.add({'nome': nome, 'endereco': endereco});
    });
  }

  void _editarCasa(int index, String novoNome, String novoEndereco) {
    setState(() {
      _casas[index]['nome'] = novoNome;
      _casas[index]['endereco'] = novoEndereco;
    });
  }

  void _removerCasa(int index) {
    setState(() {
      _casas.removeAt(index);
    });
  }

  void _abrirPopupAdicionarCasa() {
    final nomeController = TextEditingController();
    final enderecoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildCasaDialog(
          context: context,
          titulo: "Adicionar Casa",
          nomeController: nomeController,
          enderecoController: enderecoController,
          onConfirmar: () {
            if (nomeController.text.isNotEmpty &&
                enderecoController.text.isNotEmpty) {
              _adicionarCasa(nomeController.text, enderecoController.text);
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  void _abrirPopupEditarCasa(int index) {
    final nomeController = TextEditingController(text: _casas[index]['nome']);
    final enderecoController =
        TextEditingController(text: _casas[index]['endereco']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildCasaDialog(
          context: context,
          titulo: "Editar Casa",
          nomeController: nomeController,
          enderecoController: enderecoController,
          onConfirmar: () {
            if (nomeController.text.isNotEmpty &&
                enderecoController.text.isNotEmpty) {
              _editarCasa(index, nomeController.text, enderecoController.text);
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  Widget _buildCasaDialog({
    required BuildContext context,
    required String titulo,
    required TextEditingController nomeController,
    required TextEditingController enderecoController,
    required VoidCallback onConfirmar,
  }) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A3B6B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        titulo,
        style: const TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nomeController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Nome da casa",
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: enderecoController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Endereço",
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text(
            "Cancelar", 
            style: TextStyle(color: Colors.white70, fontSize: 14)
          ),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF466A91),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onConfirmar,
          child: const Text(
            "Confirmar",
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
              fontSize: 14
            ),
          ),
        ),
      ],
    );
  }

  void _mostrarMenuOpcoes(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A3B6B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text(
                  'Editar', 
                  style: TextStyle(color: Colors.white)
                ),
                onTap: () {
                  Navigator.pop(context);
                  _abrirPopupEditarCasa(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Excluir', 
                  style: TextStyle(color: Colors.red)
                ),
                onTap: () {
                  Navigator.pop(context);
                  _removerCasa(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderCard() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF27226D),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_work_outlined,
                  color: Colors.white70,
                  size: 50,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Nenhuma casa cadastrada",
                  style: TextStyle(
                    color: Colors.white70, 
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Toque no botão + para adicionar sua primeira casa",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCasaCard(int index) {
    final casa = _casas[index];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF27226D),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0xFF466A91),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.home,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          casa['nome']!,
          style: const TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
        ),
        subtitle: Text(
          casa['endereco']!,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () => _mostrarMenuOpcoes(index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3B6B),
        title: const Text(
          "MINHAS CASAS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Suas Residências",
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold, 
                fontSize: 20
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _casas.isEmpty ? "Nenhuma casa cadastrada" : "${_casas.length} casa(s) cadastrada(s)",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _casas.isEmpty
                  ? _buildPlaceholderCard()
                  : ListView.builder(
                      itemCount: _casas.length,
                      itemBuilder: (context, index) {
                        return _buildCasaCard(index);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF466A91),
        onPressed: _abrirPopupAdicionarCasa,
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF1A3B6B),
        padding: const EdgeInsets.all(16),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Alarma",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Organize suas residências de forma simples",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            SizedBox(height: 8),
            Text(
              "© Todos os direitos reservados - 2025",
              style: TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}