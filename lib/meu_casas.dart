import 'package:flutter/material.dart';
import '../acesso/auth_service.dart'; // Importar o AuthService

class MeuCasas extends StatefulWidget {
  final String nome;
  const MeuCasas({super.key, required this.nome});

  @override
  State<MeuCasas> createState() => _MeuCasasState();
}

class _MeuCasasState extends State<MeuCasas> {
  final List<Map<String, String>> _casas = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print('MeuCasas iniciado para: ${widget.nome}');
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

  void _entrarNaCasa(String nomeCasa, String endereco) {
    print('Entrando na casa: $nomeCasa');
    
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

  // MÉTODO ATUALIZADO: Fazer logout e voltar para login
  Future<void> _fazerLogout() async {
    try {
      // Fechar o drawer primeiro
      if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
        Navigator.pop(context);
      }

      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF466A91)),
          ),
        ),
      );

      // Fazer logout no AuthService
      await AuthService.logout();

      // Fechar loading e navegar para login
      if (mounted) {
        Navigator.pop(context); // Fecha o loading
        Navigator.pushReplacementNamed(context, '/');
      }

    } catch (e) {
      // Em caso de erro, ainda tenta navegar para login
      if (mounted) {
        Navigator.pop(context); // Fecha o loading
        Navigator.pushReplacementNamed(context, '/');
      }
      print('Erro durante logout: $e');
    }
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

  // Drawer lateral
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1A3B6B),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header do Drawer
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF133A67),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFF133A67)),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.nome,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "${_casas.length} casa(s)",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          
          // Menu do Drawer
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Minhas Casas', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text('Meu Perfil', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              // Aqui você pode adicionar navegação para o perfil se quiser
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('Configurações', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              // Aqui você pode adicionar navegação para configurações
            },
          ),
          
          const Divider(color: Colors.white54),
          
          // BOTÃO SAIR ATUALIZADO
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sair', style: TextStyle(color: Colors.red)),
            onTap: _fazerLogout, // Agora chama o método de logout
          ),
          
          // Footer do Drawer
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Alarma",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Organize suas residências",
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
                const SizedBox(height: 8),
                const Text(
                  "© 2025 Todos os direitos reservados",
                  style: TextStyle(color: Colors.white54, fontSize: 8),
                ),
              ],
            ),
          ),
        ],
      ),
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
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3B6B),
        title: const Text("MINHAS CASAS", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "Olá, ${widget.nome}", 
                style: const TextStyle(color: Colors.white70)
              ),
            ),
          ),
        ],
      ),
      body: _casas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.home, color: Colors.white70, size: 60),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF466A91),
                    ),
                    onPressed: _abrirPopupAdicionarCasa,
                    child: const Text('Adicionar Primeira Casa', style: TextStyle(color: Colors.white)),
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
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 18, 
                      fontWeight: FontWeight.bold
                    ),
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