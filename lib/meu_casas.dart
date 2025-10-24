import 'package:flutter/material.dart';

class MeuCasas extends StatefulWidget {
  final String nome;
  const MeuCasas({super.key, required this.nome});

  @override
  State<MeuCasas> createState() => _MeuCasasState();
}

class _MeuCasasState extends State<MeuCasas> {
  final List<Map<String, String>> _casas = [];

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

  void _entrarNaCasa(String nomeCasa, String endereco) {
    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: {
        'nome': widget.nome,
        'casa': nomeCasa,
        'endereco': endereco,
      },
    );
  }

  void _abrirPopupAdicionarCasa() {
    final nomeController = TextEditingController();
    final enderecoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A3B6B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Adicionar Casa",
            style: TextStyle(
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
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
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
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar", style: TextStyle(color: Colors.white70)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF466A91),
              ),
              onPressed: () {
                if (nomeController.text.isNotEmpty && enderecoController.text.isNotEmpty) {
                  _adicionarCasa(nomeController.text, enderecoController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Confirmar", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _abrirPopupEditarCasa(int index) {
    final nomeController = TextEditingController(text: _casas[index]['nome']);
    final enderecoController = TextEditingController(text: _casas[index]['endereco']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A3B6B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Editar Casa",
            style: TextStyle(
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
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
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
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar", style: TextStyle(color: Colors.white70)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF466A91),
              ),
              onPressed: () {
                if (nomeController.text.isNotEmpty && enderecoController.text.isNotEmpty) {
                  _editarCasa(index, nomeController.text, enderecoController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Confirmar", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _mostrarMenuOpcoes(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A3B6B),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text('Entrar na Casa', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _entrarNaCasa(_casas[index]['nome']!, _casas[index]['endereco']!);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text('Editar', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _abrirPopupEditarCasa(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Excluir', style: TextStyle(color: Colors.red)),
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

  Widget _buildCasaCard(int index) {
    final casa = _casas[index];
    return Card(
      color: const Color(0xFF27226D),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.home, color: Colors.white),
        title: Text(
          casa['nome']!,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          casa['endereco']!,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () => _mostrarMenuOpcoes(index),
        ),
        onTap: () => _entrarNaCasa(casa['nome']!, casa['endereco']!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3B6B),
        title: const Text("MINHAS CASAS", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text("Olá, ${widget.nome}", style: const TextStyle(color: Colors.white70))),
          ),
        ],
      ),
      body: _casas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home, color: Colors.white70, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    "Nenhuma casa cadastrada",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Toque no + para adicionar sua primeira casa",
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Suas Casas (${_casas.length})",
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _casas.length,
                      itemBuilder: (context, index) => _buildCasaCard(index),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF466A91),
        onPressed: _abrirPopupAdicionarCasa,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}