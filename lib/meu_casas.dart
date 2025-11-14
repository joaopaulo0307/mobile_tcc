import 'package:flutter/material.dart';
import 'package:mobile_tcc/home.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

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
    // Adiciona uma casa de exemplo para teste
    _casas.add({
      'nome': 'Minha Casa',
      'id': '1',
    });
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
    required int index,
    required Color cardColor,
    required Color textColor,
    required Color primaryColor,
    required Color secondaryTextColor,
  }) {
    return GestureDetector(
      onTap: () => _entrarNaCasa(casa),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.house,
              color: primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                casa['nome']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: secondaryTextColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaCasas({
    required Color cardColor,
    required Color textColor,
    required Color primaryColor,
    required Color secondaryTextColor,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _casas.length,
      itemBuilder: (context, index) {
        final casa = _casas[index];
        return _buildCasaItem(
          casa: casa,
          index: index,
          cardColor: cardColor,
          textColor: textColor,
          primaryColor: primaryColor,
          secondaryTextColor: secondaryTextColor,
        );
      },
    );
  }

  Widget _buildTextoFilosofico({
    required Color backgroundColor,
    required Color secondaryTextColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: backgroundColor,
      child: Text(
        "Quem significa uma família de forma simples?",
        style: TextStyle(
          color: secondaryTextColor,
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFooter({required Color primaryColor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: primaryColor,
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
    );
  }

  void _mostrarDialogoCriarCasa() {
    final isDarkMode = ThemeService.themeNotifier.value;
    final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
    final cardColor = isDarkMode ? ThemeService.cardColorDark : ThemeService.cardColorLight;
    final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;
    final primaryColor = ThemeService.primaryColor;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
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
      ),
    );
  }

  void _criarCasa() {
    final nomeCasa = _nomeController.text.trim();
    
    if (nomeCasa.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Por favor, insira um nome para a casa'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _casas.add({
        'nome': nomeCasa,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    });
    
    Navigator.pop(context);
    _limparCampos();
    
    // Navegar para a Home após criar a casa
    final casaCriada = _casas.last;
    _entrarNaCasa(casaCriada);
  }

  void _limparCampos() {
    _nomeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
        final cardColor = isDarkMode ? ThemeService.cardColorDark : ThemeService.cardColorLight;
        final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;
        final secondaryTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
        final primaryColor = ThemeService.primaryColor;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: const Text(
              'MINHAS CASAS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Column(
            children: [
              // Lista de casas
              Expanded(
                child: Container(
                  color: backgroundColor,
                  child: _casas.isEmpty
                      ? _buildEmptyState(
                          secondaryTextColor: secondaryTextColor,
                        )
                      : _buildListaCasas(
                          cardColor: cardColor,
                          textColor: textColor,
                          primaryColor: primaryColor,
                          secondaryTextColor: secondaryTextColor,
                        ),
                ),
              ),
              
              // Texto filosófico
              _buildTextoFilosofico(
                backgroundColor: backgroundColor,
                secondaryTextColor: secondaryTextColor,
              ),
              
              // Rodapé
              _buildFooter(primaryColor: primaryColor),
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