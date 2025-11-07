import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../serviços/theme_service.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool notificacoesAtivas = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: ThemeService.themeNotifier,
        builder: (context, isDarkMode, child) {
          return _buildContent(context, isDarkMode);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDarkMode) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('Aparência'),
        _buildThemeSwitch(isDarkMode),
        const Divider(),
        
        _buildSectionTitle('Notificações'),
        _buildNotificationSwitch(),
        const Divider(),

        _buildSectionTitle('Idioma'),
        _buildLanguageTile(context),
        const Divider(),

        _buildSectionTitle('Privacidade'),
        _buildPrivacyTile(),
        const Divider(),

        _buildSectionTitle('Conta'),
        _buildAccountOptions(),
        const Divider(),

        _buildSectionTitle('Sobre o App'),
        _buildAppInfo(),
        const SizedBox(height: 32),

        _buildBackButton(context),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ThemeService.primaryColor,
        ),
      ),
    );
  }

  Widget _buildThemeSwitch(bool isDarkMode) {
    return ListTile(
      leading: const Icon(Icons.dark_mode, color: ThemeService.primaryColor),
      title: const Text('Modo Escuro'),
      subtitle: const Text('Ativar tema escuro'),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) {
          HapticFeedback.lightImpact();
          ThemeService.setDarkMode(value);
        },
        activeColor: ThemeService.secondaryColor,
      ),
    );
  }

  Widget _buildNotificationSwitch() {
    return StatefulBuilder(
      builder: (context, setState) {
        bool notifications = true;
        return ListTile(
          leading: const Icon(Icons.notifications, color: ThemeService.primaryColor),
          title: const Text('Notificações'),
          subtitle: const Text('Receber notificações do app'),
          trailing: Switch(
            value: notifications,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => notifications = value);
            },
            activeColor: ThemeService.secondaryColor,
          ),
        );
      },
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language, color: ThemeService.primaryColor),
      title: const Text('Idioma'),
      subtitle: const Text('Português (Brasil)'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        HapticFeedback.selectionClick();
        _showLanguageBottomSheet(context);
      },
    );
  }

  Widget _buildPrivacyTile() {
    return ListTile(
      leading: const Icon(Icons.security, color: ThemeService.primaryColor),
      title: const Text('Privacidade e Segurança'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        HapticFeedback.selectionClick();
      },
    );
  }

  Widget _buildAccountOptions() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person, color: ThemeService.primaryColor),
          title: const Text('Editar Perfil'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            HapticFeedback.selectionClick();
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.lock, color: ThemeService.primaryColor),
          title: const Text('Alterar Senha'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            HapticFeedback.selectionClick();
          },
        ),
      ],
    );
  }

  Widget _buildAppInfo() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info, color: ThemeService.primaryColor),
          title: const Text('Versão do App'),
          subtitle: const Text('1.0.0'),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.description, color: ThemeService.primaryColor),
          title: const Text('Termos de Uso'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            HapticFeedback.selectionClick();
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.privacy_tip, color: ThemeService.primaryColor),
          title: const Text('Política de Privacidade'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            HapticFeedback.selectionClick();
          },
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeService.secondaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          HapticFeedback.mediumImpact();
          Navigator.pop(context);
        },
        child: const Text(
          'Voltar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecione o Idioma',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeService.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildLanguageOption('Português (Brasil)', true, context),
              _buildLanguageOption('English (US)', false, context),
              _buildLanguageOption('Español', false, context),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('FECHAR'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, bool isSelected, BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.check,
        color: isSelected ? ThemeService.primaryColor : Colors.transparent,
      ),
      title: Text(language),
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pop(context);
      },
    );
  }
}