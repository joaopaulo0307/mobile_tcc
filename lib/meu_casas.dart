import 'package:flutter/material.dart';
import 'package:mobile_tcc/home.dart';
import 'acesso/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_tcc/main.dart';
import '../serviços/theme_service.dart'; // Adicionado

class MeuCasas extends StatefulWidget {
  const MeuCasas({super.key});

  @override
  State<MeuCasas> createState() => _MeuCasasState();
}

class _MeuCasasState extends State<MeuCasas> {
  final List<Map<String, String>> _casas = [];
  final TextEditingController _nomeController = TextEditingController();
  
  // Cores baseadas nas imagens fornecidas (mantidas para compatibilidade)
  final Color _primaryColor = const Color(0xFF133A67); // Azul escuro das imagens
  final Color _lightBackground = Colors.white;
  final Color _darkBackground = Color(0xFF121212);
  final Color _lightCardColor = Colors.white;
  final Color _darkCardColor = Color(0xFF1E1E1E);
  final Color _lightTextColor = Colors.black87;
  final Color _darkTextColor = Colors.white70;
  final Color _lightSecondaryText = Colors.grey[600]!;
  final Color _darkSecondaryText = Colors.grey[400]!;

  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Usar o tema do ThemeService se disponível, caso contrário usar o local
    final bool useGlobalTheme = ThemeService.themeNotifier.hasListeners;
    final bool isDarkMode = useGlobalTheme ? ThemeService.isDarkMode : _isDarkMode;
    
    final backgroundColor = isDarkMode ? 
        (useGlobalTheme ? ThemeService.backgroundDark : _darkBackground) : 
        (useGlobalTheme ? ThemeService.backgroundLight : _lightBackground);
    
    final cardColor = isDarkMode ? 
        (useGlobalTheme ? ThemeService.cardColorDark : _darkCardColor) : 
        (useGlobalTheme ? ThemeService.cardColorLight : _lightCardColor);
    
    final textColor = isDarkMode ? 
        (useGlobalTheme ? ThemeService.textColorDark : _darkTextColor) : 
        (useGlobalTheme ? ThemeService.textColorLight : _lightTextColor);
    
    final secondaryTextColor = isDarkMode ? 
        (useGlobalTheme ? ThemeService.secondaryTextDark : _darkSecondaryText) : 
        (useGlobalTheme ? ThemeService.secondaryTextLight : _lightSecondaryText);

    final primaryColor = useGlobalTheme ? ThemeService.primaryColor : _primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('MINHAS CASAS'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Mostrar botão de tema apenas se não estiver usando o tema global
          if (!useGlobalTheme) 
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: _toggleTheme,
            ),
        ],
      ),
      body: Column(
        children: [
          // Lista de casas
          Expanded(
            child: Container(
              color: backgroundColor,
              child: _casas.isEmpty
                  ? Center(
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
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _casas.length,
                      itemBuilder: (context, index) {
                        final casa = _casas[index];
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
                            child: Text(
                              casa['nome']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          
          // Texto "Quem significa uma família de forma simples?"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: backgroundColor,
            child: Text(
              "Quem significa uma família de forma simples?",
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Rodapé
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: primaryColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Organize suas tarefas de forma simples",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "© Todos os direitos reservados - 2025",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.white70,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: _mostrarDialogoCriarCasa,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _mostrarDialogoCriarCasa() {
    final bool useGlobalTheme = ThemeService.themeNotifier.hasListeners;
    final bool isDarkMode = useGlobalTheme ? ThemeService.isDarkMode : _isDarkMode;
    
    final backgroundColor = isDarkMode ? 
        (useGlobalTheme ? ThemeService.backgroundDark : _darkBackground) : 
        (useGlobalTheme ? ThemeService.backgroundLight : _lightBackground);
    
    final cardColor = isDarkMode ? 
        (useGlobalTheme ? ThemeService.cardColorDark : _darkCardColor) : 
        (useGlobalTheme ? ThemeService.cardColorLight : _lightCardColor);
    
    final textColor = isDarkMode ? 
        (useGlobalTheme ? ThemeService.textColorDark : _darkTextColor) : 
        (useGlobalTheme ? ThemeService.textColorLight : _lightTextColor);

    final primaryColor = useGlobalTheme ? ThemeService.primaryColor : _primaryColor;

    showDialog(
      context: context,
      builder: (context) => Theme(
        data: isDarkMode 
            ? ThemeData.dark().copyWith(
                dialogBackgroundColor: cardColor,
              )
            : ThemeData.light().copyWith(
                dialogBackgroundColor: cardColor,
              ),
        child: AlertDialog(
          backgroundColor: cardColor,
          title: Text(
            'Criar Nova Casa',
            style: TextStyle(color: textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Nome da Casa',
                  labelStyle: TextStyle(color: textColor),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
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
              child: Text(
                'Cancelar',
                style: TextStyle(color: textColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              onPressed: _criarCasa,
              child: const Text('Criar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _criarCasa() {
    if (_nomeController.text.trim().isNotEmpty) {
      setState(() {
        _casas.add({
          'nome': _nomeController.text.trim(),
        });
      });
      Navigator.pop(context);
      _limparCampos();
      
      // Navegar para a Home após criar a casa
      final casaCriada = _casas.last;
      _entrarNaCasa(casaCriada);
    } else {
      // Mostrar erro se o nome estiver vazio
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Por favor, insira um nome para a casa'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _entrarNaCasa(Map<String, String> casa) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(casa: casa),
      ),
    );
  }

  void _limparCampos() {
    _nomeController.clear();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }
}