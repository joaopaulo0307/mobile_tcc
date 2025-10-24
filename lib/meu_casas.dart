import 'package:flutter/material.dart';

class MeuCasasPage extends StatefulWidget {
  const MeuCasasPage({super.key});

  @override
  State<MeuCasasPage> createState() => _MeuCasasPageState();
}

class _MeuCasasPageState extends State<MeuCasasPage> {
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
            if (nomeController.text.isNotEmpty && enderecoController.text.isNotEmpty) {
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
    final enderecoController = TextEditingController(text: _casas[index]['endereco']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildCasaDialog(
          context: context,
          titulo: "Editar Casa",
          nomeController: nomeController,
          enderecoController: enderecoController,
          onConfirmar: () {
            if (nomeController.text.isNotEmpty && enderecoController.text.isNotEmpty) {
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
      backgroundColor: const Color(0xFF133C74),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        titulo,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: enderecoController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Endereço",
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
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
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          onPressed: onConfirmar,
          child: const Text(
            "Confirmar",
            style: TextStyle(color: Color(0xFF133C74), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _mostrarMenuOpcoes(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF133C74),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF133C74),
        title: const Text("MINHAS CASAS", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Residências:",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _casas.isEmpty
                    ? const Center(
                        child: Text(
                          "Nenhuma casa cadastrada\nClique no + para adicionar",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _casas.length,
                        itemBuilder: (context, index) {
                          final casa = _casas[index];
                          return Card(
                            color: const Color(0xFF6C8ED0),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: ListTile(
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
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF133C74),
        onPressed: _abrirPopupAdicionarCasa,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF133C74),
        padding: const EdgeInsets.all(12),
        child: const Center(
          child: Text(
            "© Todos os direitos reservados - 2025",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      ),
    );
  }
}