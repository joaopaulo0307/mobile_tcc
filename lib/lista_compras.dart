import 'package:flutter/material.dart';
import 'package:mobile_tcc/home.dart';
import 'package:mobile_tcc/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListaCompras extends StatefulWidget {
  const ListaCompras({super.key});

  @override
  State<ListaCompras> createState() => _ListaComprasState();
}

class _ListaComprasState extends State<ListaCompras> {
  List<Map<String, dynamic>> produtos = [];

  final TextEditingController produtoController = TextEditingController();
  final TextEditingController responsavelController = TextEditingController();

  void adicionarProduto(String produto, String responsavel) {
    setState(() {
      produtos.add({
        'produto': produto,
        'responsavel': responsavel,
        'feito': false,
      });
    });
  }

  void removerProduto(int index) {
    setState(() {
      produtos.removeAt(index);
    });
  }

  void marcarComoFeito(int index) {
    setState(() {
      produtos[index]['feito'] = !produtos[index]['feito'];
    });
  }

  void abrirModalAdicionar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0D47A1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              'Listamento',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: produtoController,
                decoration: const InputDecoration(
                  labelText: 'Produto:',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: responsavelController,
                decoration: const InputDecoration(
                  labelText: 'Responsável:',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (produtoController.text.isNotEmpty &&
                      responsavelController.text.isNotEmpty) {
                    adicionarProduto(
                        produtoController.text, responsavelController.text);
                    produtoController.clear();
                    responsavelController.clear();
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0D47A1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('CRIAR'),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text(
          'Lista de Compras',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Produtos:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: produtos.isEmpty
                ? const Center(
                    child: Text(
                      'Não há nenhum produto listado no momento',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: produtos.length,
                    itemBuilder: (context, index) {
                      final item = produtos[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D47A1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () => marcarComoFeito(index),
                              child: CircleAvatar(
                                backgroundColor: item['feito']
                                    ? Colors.green
                                    : Colors.white,
                                radius: 12,
                                child: item['feito']
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            ),
                            title: Text(
                              item['produto'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: item['feito']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text(
                              "Responsável: ${item['responsavel']}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white),
                              onPressed: () => removerProduto(index),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: abrirModalAdicionar,
            backgroundColor: const Color(0xFF0D47A1),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Container(
            color: const Color(0xFF0D47A1),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                SizedBox(height: 5),
                Text(
                  'Organize suas tarefas de forma simples',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.facebook, color: Colors.white),
                    SizedBox(width: 10),
                    Icon(Icons.camera_alt, color: Colors.white),
                    SizedBox(width: 10),
                    Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '© Todos os direitos reservados - 2025',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
