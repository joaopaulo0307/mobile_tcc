import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_tcc/home.dart';
import '../services/theme_service.dart';

class MeuCasas extends StatefulWidget {
  const MeuCasas({super.key});

  @override
  State<MeuCasas> createState() => _MeuCasasState();
}

class _MeuCasasState extends State<MeuCasas> {
  final List<Map<String, String>> _casas = []; 
  final TextEditingController _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _entrarNaCasa(Map<String, String> casa) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(casa: casa),
      ),
    );
  }

  Widget _buildEmptyState({required Color secondaryTextColor}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_outlined, 
            size: 64, 
            color: secondaryTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma casa cadastrada',
            style: TextStyle(
              color: secondaryTextColor, 
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Toque no botão + para criar sua primeira casa',
              style: TextStyle(
                color: secondaryTextColor.withOpacity(0.7), 
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCasaItem({
    required Map<String, String> casa,
    required Color textColor,
    required Color primaryColor,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.house,
            color: primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          casa['nome']!,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
            fontSize: 16,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: () => _entrarNaCasa(casa),
      ),
    );
  }

  Widget _buildListaCasas({
    required Color textColor,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título "Residencias:"
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
          child: Text(
            'Residencias:',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Lista de casas
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: _casas.length,
            itemBuilder: (context, index) {
              final casa = _casas[index];
              return _buildCasaItem(
                casa: casa,
                textColor: textColor,
                primaryColor: primaryColor,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF133A67),
            Color(0xFF1E4A7A),
          ],
        ),
      ),
      child: Column(
        children: [
          // Logo/Imagem
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withOpacity(0.1),
              child: Icon(
                Icons.task_alt,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          
          // Textos
          const Column(
            children: [
              Text(
                'Organize suas tarefas de forma simples',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Todos os direitos reservados - 2025',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoCriarCasa() {
    showDialog(
      context: context,
      builder: (context) {
        final themeService = Provider.of<ThemeService>(context, listen: false);
        final textColor = themeService.textColor;
        final primaryColor = themeService.primaryColor;

        return AlertDialog(
          backgroundColor: themeService.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Criar Nova Casa',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Nome da Casa',
                  labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _limparCampos();
              },
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _criarCasa,
              child: const Text(
                'Criar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _criarCasa() {
    final nomeCasa = _nomeController.text.trim();
    
    if (nomeCasa.isEmpty) {
      _mostrarErro('Por favor, insira um nome para a casa');
      return;
    }

    // ✅ VERIFICA SE JÁ EXISTE CASA COM MESMO NOME
    final casaExistente = _casas.any((casa) => 
      casa['nome']?.toLowerCase() == nomeCasa.toLowerCase()
    );

    if (casaExistente) {
      _mostrarErro('Já existe uma casa com este nome');
      return;
    }

    final novaCasa = {
      'nome': nomeCasa,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    setState(() {
      _casas.add(novaCasa);
    });
    
    Navigator.pop(context); // Fecha o dialog
    _limparCampos();
    
    // ✅ MOSTRA MENSAGEM DE SUCESSO E PERGUNTA SE QUER ENTRAR
    _mostrarSucessoEContinuar(novaCasa);
  }

  void _mostrarSucessoEContinuar(Map<String, String> casa) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Casa "${casa['nome']}" criada com sucesso!'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Entrar',
          textColor: Colors.white,
          onPressed: () {
            _entrarNaCasa(casa);
          },
        ),
      ),
    );
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(mensagem),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _limparCampos() {
    _nomeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        final isDarkMode = themeService.isDarkMode;
        final backgroundColor = themeService.backgroundColor;
        final textColor = themeService.textColor;
        final secondaryTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
        final primaryColor = themeService.primaryColor;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: const Text(
              'MINHAS CASAS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Column(
            children: [
              // Lista de casas - ✅ AGORA COMEÇA VAZIA
              Expanded(
                child: Container(
                  color: backgroundColor,
                  child: _casas.isEmpty
                      ? _buildEmptyState(secondaryTextColor: secondaryTextColor)
                      : _buildListaCasas(
                          textColor: textColor,
                          primaryColor: primaryColor,
                        ),
                ),
              ),
              
              // Rodapé com gradiente azul e imagem
              _buildFooter(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: _mostrarDialogoCriarCasa,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }
}