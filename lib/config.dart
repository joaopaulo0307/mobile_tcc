import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_tcc/services/theme_service.dart';
import 'package:provider/provider.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _autoSyncEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: ThemeService.primaryColor,
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
            // ✅ SEÇÃO: PREFERÊNCIAS DO USUÁRIO
            _buildSectionTitle('Preferências'),
            _buildThemeSwitch(themeService),
            _buildNotificationSwitch(themeService),
            _buildBiometricSwitch(themeService),
            _buildAutoSyncSwitch(themeService),
            const SizedBox(height: 8),
            const Divider(),

            // ✅ SEÇÃO: PRIVACIDADE E SEGURANÇA
            _buildSectionTitle('Privacidade & Segurança'),
            _buildPrivacyTile(context, themeService),
            _buildSecurityTile(context, themeService),
            const SizedBox(height: 8),
            const Divider(),

            // ✅ SEÇÃO SOBRE
            _buildSectionTitle('Sobre'),
            _buildAppInfo(themeService),
            _buildRateAppTile(themeService),
            _buildShareAppTile(themeService),
            const SizedBox(height: 32),

            // ✅ BOTÕES DE AÇÃO
            _buildActionButtons(context, themeService),
            
            // ✅ RODAPÉ COM INFORMAÇÕES ADICIONAIS
            _buildFooter(context),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ThemeService.primaryColor,
        ),
      ),
    );
  }

  // ✅ SWITCH DO TEMA ATUALIZADO
  Widget _buildThemeSwitch(ThemeService themeService) {
    return ListTile(
      leading: Icon(
        themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: ThemeService.primaryColor,
      ),
      title: Text(themeService.isDarkMode ? 'Modo Escuro' : 'Modo Claro'),
      subtitle: Text(themeService.isDarkMode ? 'Tema escuro ativado' : 'Tema claro ativado'),
      trailing: Switch(
        value: themeService.isDarkMode,
        onChanged: (value) {
          HapticFeedback.lightImpact();
          themeService.setDarkMode(value);
        },
        activeColor: ThemeService.primaryColor,
      ),
    );
  }

  // ✅ SWITCH: NOTIFICAÇÕES
  Widget _buildNotificationSwitch(ThemeService themeService) {
    return ListTile(
      leading: Icon(Icons.notifications, color: ThemeService.primaryColor),
      title: const Text('Notificações'),
      subtitle: Text(_notificationsEnabled ? 'Notificações ativas' : 'Notificações inativas'),
      trailing: Switch(
        value: _notificationsEnabled,
        onChanged: (value) {
          setState(() {
            _notificationsEnabled = value;
          });
          HapticFeedback.lightImpact();
        },
        activeColor: ThemeService.primaryColor,
      ),
    );
  }

  // ✅ SWITCH: BIOMETRIA
  Widget _buildBiometricSwitch(ThemeService themeService) {
    return ListTile(
      leading: Icon(Icons.fingerprint, color: ThemeService.primaryColor),
      title: const Text('Biometria'),
      subtitle: Text(_biometricEnabled ? 'Biometria ativa' : 'Biometria inativa'),
      trailing: Switch(
        value: _biometricEnabled,
        onChanged: (value) {
          setState(() {
            _biometricEnabled = value;
          });
          HapticFeedback.lightImpact();
        },
        activeColor: ThemeService.primaryColor,
      ),
    );
  }

  // ✅ SWITCH: SINCRONIZAÇÃO AUTOMÁTICA
  Widget _buildAutoSyncSwitch(ThemeService themeService) {
    return ListTile(
      leading: Icon(Icons.sync, color: ThemeService.primaryColor),
      title: const Text('Sincronização Automática'),
      subtitle: Text(_autoSyncEnabled ? 'Sincronização automática ativa' : 'Sincronização automática inativa'),
      trailing: Switch(
        value: _autoSyncEnabled,
        onChanged: (value) {
          setState(() {
            _autoSyncEnabled = value;
          });
          HapticFeedback.lightImpact();
        },
        activeColor: ThemeService.primaryColor,
      ),
    );
  }

  // ✅ OPÇÃO: PRIVACIDADE
  Widget _buildPrivacyTile(BuildContext context, ThemeService themeService) {
    return ListTile(
      leading: Icon(Icons.privacy_tip, color: ThemeService.primaryColor),
      title: const Text('Privacidade'),
      subtitle: const Text('Configurar privacidade'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showPrivacyOptions(context),
    );
  }

  // ✅ OPÇÃO: SEGURANÇA
  Widget _buildSecurityTile(BuildContext context, ThemeService themeService) {
    return ListTile(
      leading: Icon(Icons.security, color: ThemeService.primaryColor),
      title: const Text('Segurança'),
      subtitle: const Text('Configurar segurança'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showSecurityOptions(context),
    );
  }

  Widget _buildAppInfo(ThemeService themeService) {
    return ListTile(
      leading: Icon(Icons.info, color: ThemeService.primaryColor),
      title: const Text('Versão do App'),
      subtitle: const Text('1.0.0'),
    );
  }

  // ✅ OPÇÃO: AVALIAR APP
  Widget _buildRateAppTile(ThemeService themeService) {
    return ListTile(
      leading: Icon(Icons.star, color: ThemeService.primaryColor),
      title: const Text('Avaliar App'),
      subtitle: const Text('Avaliar na loja de aplicativos'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _rateApp(context),
    );
  }

  // ✅ OPÇÃO: COMPARTILHAR APP
  Widget _buildShareAppTile(ThemeService themeService) {
    return ListTile(
      leading: Icon(Icons.share, color: ThemeService.primaryColor),
      title: const Text('Compartilhar App'),
      subtitle: const Text('Compartilhar com amigos'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _shareApp(context),
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
            backgroundColor: ThemeService.primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('ALTERNAR TEMA AGORA'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _showResetDialog(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('REDEFINIR CONFIGURAÇÕES'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: ThemeService.primaryColor,
            side: BorderSide(color: ThemeService.primaryColor),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('VOLTAR'),
        ),
      ],
    );
  }

  // ✅ FOOTER
  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            '© Todos os direitos reservados - 2025',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'TaskDomus v1.0.0',
            style: TextStyle(
              color: Colors.grey.withOpacity(0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ MÉTODOS PARA AS NOVAS FUNCIONALIDADES
  void _showPrivacyOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacidade'),
        content: const Text('Funcionalidade em desenvolvimento...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('FECHAR'),
          ),
        ],
      ),
    );
  }

  void _showSecurityOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Segurança'),
        content: const Text('Funcionalidade em desenvolvimento...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('FECHAR'),
          ),
        ],
      ),
    );
  }

  void _rateApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abrindo loja de aplicativos...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Compartilhando aplicativo...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redefinir Configurações'),
        content: const Text('Tem certeza que deseja redefinir todas as configurações para os padrões?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _notificationsEnabled = true;
                _biometricEnabled = false;
                _autoSyncEnabled = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Configurações redefinidas com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('REDEFINIR'),
          ),
        ],
      ),
    );
  }
}