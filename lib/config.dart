import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import 'package:provider/provider.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: ThemeService.primaryColor, // ✅ CORRIGIDO: uso estático
        foregroundColor: Colors.white,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('Aparência', themeService),
            _buildThemeSwitch(themeService),
            const Divider(),
            
            _buildSectionTitle('Idioma', themeService),
            _buildLanguageTile(context, themeService),
            const Divider(),

            _buildSectionTitle('Sobre', themeService),
            _buildAppInfo(themeService),
            const SizedBox(height: 32),

            _buildActionButtons(context, themeService),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, ThemeService themeService) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ThemeService.primaryColor, // ✅ CORRIGIDO: uso estático
        ),
      ),
    );
  }

  Widget _buildThemeSwitch(ThemeService themeService) {
    return ListTile(
      leading: Icon(
        themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: ThemeService.primaryColor, // ✅ CORRIGIDO: uso estático
      ),
      title: Text(themeService.isDarkMode ? 'Modo Escuro' : 'Modo Claro'),
      subtitle: Text(themeService.isDarkMode ? 
        'Tema escuro ativado' : 'Tema claro ativado'),
      trailing: Switch(
        value: themeService.isDarkMode,
        onChanged: (value) {
          HapticFeedback.lightImpact();
          themeService.setDarkMode(value);
        },
        activeColor: ThemeService.secondaryColor, // ✅ CORRIGIDO: uso estático
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, ThemeService themeService) {
    return ListTile(
      leading: Icon(Icons.language, color: ThemeService.primaryColor), // ✅ CORRIGIDO
      title: const Text('Idioma'),
      subtitle: const Text('Português (Brasil)'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showLanguageOptions(context, themeService),
    );
  }

  Widget _buildAppInfo(ThemeService themeService) {
    return ListTile(
      leading: Icon(Icons.info, color: ThemeService.primaryColor), // ✅ CORRIGIDO
      title: const Text('Versão do App'),
      subtitle: const Text('1.0.0'),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeService themeService) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            themeService.toggleTheme();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeService.primaryColor, // ✅ CORRIGIDO
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('ALTERNAR TEMA AGORA'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: ThemeService.primaryColor, // ✅ CORRIGIDO
            side: BorderSide(color: ThemeService.primaryColor), // ✅ CORRIGIDO
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('VOLTAR'),
        ),
      ],
    );
  }

  void _showLanguageOptions(BuildContext context, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageItem('Português (Brasil)', 'pt_BR'),
            _buildLanguageItem('English (US)', 'en_US'),
            _buildLanguageItem('Español', 'es_ES'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('FECHAR'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(String language, String code) {
    return ListTile(
      title: Text(language),
      leading: const Icon(Icons.check, color: Colors.green),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Idioma alterado para $language')),
        );
      },
    );
  }
}