import 'package:flutter/material.dart';
import 'package:mobile_tcc/acesso/auth_service.dart';
import 'package:mobile_tcc/main.dart';
import 'package:mobile_tcc/home.dart';

class MeuCasas extends StatefulWidget {
  final String nome;

  const MeuCasas({super.key, required this.nome});

  @override
  State<MeuCasas> createState() => _MeuCasasState();
}

class _MeuCasasState extends State<MeuCasas> {
  final List<Map<String, String>> _casas = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ✅ Adiciona uma nova casa e volta para a home
  void _adicionarCasa(String nome) {
    setState(() {
      _casas.add({
        'nome': nome,
        'endereco': 'Endereço não informado',
      });
    });

    Navigator.pop(context, {
    'nomeCasa': nome,
    'enderecoCasa': 'Endereço não informado',
    });
  }

  void _editarCasa(int index, String novoNome) {
    setState(() {
      _casas[index]['nome'] = novoNome;
    });
  }

  void _removerCasa(int index) {
    setState(() {
      _casas.removeAt(index);
    });
  }

  // ✅ Ao entrar numa casa, volta para a home com os dados
  void _entrarNaCasa(String nomeCasa) {
    final endereco = _casas.firstWhere(
      (c) => c['nome'] == nomeCasa,
      orElse: () => {'endereco': 'Endereço não informado'},
    )['endereco'];

    Navigator.pop(context, {
      'nomeCasa': nomeCasa,
      'enderecoCasa': endereco,
    });
  }

  Future<void> _fazerLogout() async {
    try {
      if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
        Navigator.pop(context);
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await AuthService.logout();

      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/');
      }
    }
  }

  void _abrirPopupAdicionarCasa() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A3B6B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Adicionar Casa",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
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
        actions: [
          TextButton(
            child: const Text("Cancelar", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
                _adicionarCasa(controller.text);
              }
            },
            child: const Text("Confirmar"),
          )
        ],
      ),
    );
  }

  void _abrirPopupEditarCasa(int index) {
    final controller = TextEditingController(text: _casas[index]['nome']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A3B6B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Editar Casa",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
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
        actions: [
          TextButton(
            child: const Text("Cancelar", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            onPressed: () {
              _editarCasa(index, controller.text);
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          )
        ],
      ),
    );
  }

  void _mostrarOpcoesCasa(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A3B6B),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text("Entrar", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _entrarNaCasa(_casas[index]['nome']!);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.white),
            title: const Text("Editar", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _abrirPopupEditarCasa(index);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Excluir", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _removerCasa(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCasaCard(int index) {
    return Card(
      color: const Color(0xFF27226D),
      child: ListTile(
        leading: const Icon(Icons.home, color: Colors.white),
        title: Text(
          _casas[index]['nome']!,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () => _mostrarOpcoesCasa(index),
        ),
        onTap: () => _entrarNaCasa(_casas[index]['nome']!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: const Color(0xFF1A3B6B),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 35, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              widget.nome,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const Divider(color: Colors.white54),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Sair", style: TextStyle(color: Colors.red)),
              onTap: _fazerLogout,
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3B6B),
        title: const Text("Minhas Casas"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF466A91),
        child: const Icon(Icons.add),
        onPressed: _abrirPopupAdicionarCasa,
      ),
      body: _casas.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma casa cadastrada",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _casas.length,
              itemBuilder: (_, i) => _buildCasaCard(i),
            ),
    );
  }
}
