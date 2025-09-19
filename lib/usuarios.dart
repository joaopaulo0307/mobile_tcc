import 'package:flutter/material.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({super.key});

  @override
  State<Usuarios> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<Usuarios> {
  // Lista de membros (inicialmente vazia)
  final List<Map<String, String>> _membros = [];

  // Controladores para os campos de texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  // Função para adicionar um novo membro
  void _adicionarMembro() {
    final String nome = _nomeController.text.trim();
    final String descricao = _descricaoController.text.trim();

    if (nome.isNotEmpty) {
      setState(() {
        _membros.add({
          'nome': nome,
          'descricao': descricao,
        });
      });

      // Limpar os campos após adicionar
      _nomeController.clear();
      _descricaoController.clear();

      // Fechar o teclado se estiver aberto
      FocusScope.of(context).unfocus();
    }
  }

  // Função para remover um membro
  void _removerMembro(int index) {
    setState(() {
      _membros.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Usuários'),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Navegar para outras páginas baseado na seleção
              if (value == 'graficos') {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => GraficosPage()));
              } else if (value == 'arquivo') {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ArquivoTarefasPage()));
              } else if (value == 'home') {
                Navigator.pop(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'graficos',
                child: Text('Gráficos'),
              ),
              const PopupMenuItem<String>(
                value: 'usuarios',
                child: Text('Usuários'),
              ),
              const PopupMenuItem<String>(
                value: 'arquivo',
                child: Text('Arquivo de Tarefas'),
              ),
              const PopupMenuItem<String>(
                value: 'home',
                child: Text('Home'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Cabeçalho
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[800],
            child: const Center(
              child: Text(
                'Tarefas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Formulário para adicionar membros
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Adicionar Membro',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descricaoController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _adicionarMembro,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        '+ Add Membro',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Lista de membros
          Expanded(
            child: _membros.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum membro adicionado ainda.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _membros.length,
                    itemBuilder: (context, index) {
                      final membro = _membros[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            membro['nome']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(membro['descricao'] ?? ''),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => _removerMembro(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Rodapé
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.blue[900],
            child: Column(
              children: [
                const Text(
                  'Termos | Privacidade',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Contatos:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.email, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  '© 2025 - Todos os direitos reservados',
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