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
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _autoSyncEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<LanguageService>(
          builder: (context, languageService, child) {
            return Text(languageService.translate('configuracoes') ?? 'Configurações');
          },
        ),
        backgroundColor: ThemeService.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Consumer2<ThemeService, LanguageService>(
      builder: (context, themeService, languageService, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ✅ SEÇÃO: PREFERÊNCIAS DO USUÁRIO
            _buildSectionTitle('preferencias', themeService, languageService),
            _buildThemeSwitch(themeService, languageService),
            _buildNotificationSwitch(themeService, languageService),
            _buildBiometricSwitch(themeService, languageService),
            _buildAutoSyncSwitch(themeService, languageService),
            const SizedBox(height: 8),
            const Divider(),
            
            // ✅ SEÇÃO IDIOMA
            _buildSectionTitle('idioma', themeService, languageService),
            _buildLanguageTile(context, themeService, languageService),
            const SizedBox(height: 8),
            const Divider(),

            // ✅ SEÇÃO: PRIVACIDADE E SEGURANÇA
            _buildSectionTitle('privacidade_seguranca', themeService, languageService),
            _buildPrivacyTile(context, themeService, languageService),
            _buildSecurityTile(context, themeService, languageService),
            const SizedBox(height: 8),
            const Divider(),

            // ✅ SEÇÃO SOBRE
            _buildSectionTitle('sobre', themeService, languageService),
            _buildAppInfo(themeService, languageService),
            _buildRateAppTile(themeService, languageService),
            _buildShareAppTile(themeService, languageService),
            const SizedBox(height: 32),

            // ✅ BOTÕES DE AÇÃO
            _buildActionButtons(context, themeService, languageService),
            
            // ✅ RODAPÉ COM INFORMAÇÕES ADICIONAIS
            _buildFooter(themeService, languageService),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String titleKey, ThemeService themeService, LanguageService languageService) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        languageService.translate(titleKey) ?? _getDefaultTitle(titleKey),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ThemeService.primaryColor,
        ),
      ),
    );
  }

  String _getDefaultTitle(String key) {
    switch (key) {
      case 'preferencias': return 'Preferências';
      case 'idioma': return 'Idioma';
      case 'privacidade_seguranca': return 'Privacidade & Segurança';
      case 'sobre': return 'Sobre';
      default: return key;
    }
  }

  // ✅ SWITCH DO TEMA ATUALIZADO
  Widget _buildThemeSwitch(ThemeService themeService, LanguageService languageService) {
    return ListTile(
      leading: Icon(
        themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: ThemeService.primaryColor,
      ),
      title: Text(themeService.isDarkMode ? 
        languageService.translate('modo_escuro') ?? 'Modo Escuro' : 
        languageService.translate('modo_claro') ?? 'Modo Claro'),
      subtitle: Text(themeService.isDarkMode ? 
        languageService.translate('tema_escuro_ativado') ?? 'Tema escuro ativado' : 
        languageService.translate('tema_claro_ativado') ?? 'Tema claro ativado'),
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
  Widget _buildNotificationSwitch(ThemeService themeService, LanguageService languageService) {
    return ListTile(
      leading: Icon(Icons.notifications, color: ThemeService.primaryColor),
      title: Text(languageService.translate('notificacoes') ?? 'Notificações'),
      subtitle: Text(_notificationsEnabled ? 
        languageService.translate('notificacoes_ativas') ?? 'Notificações ativas' : 
        languageService.translate('notificacoes_inativas') ?? 'Notificações inativas'),
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
  Widget _buildBiometricSwitch(ThemeService themeService, LanguageService languageService) {
    return ListTile(
      leading: Icon(Icons.fingerprint, color: ThemeService.primaryColor),
      title: Text(languageService.translate('biometria') ?? 'Biometria'),
      subtitle: Text(_biometricEnabled ? 
        languageService.translate('biometria_ativa') ?? 'Biometria ativa' : 
        languageService.translate('biometria_inativa') ?? 'Biometria inativa'),
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
  Widget _buildAutoSyncSwitch(ThemeService themeService, LanguageService languageService) {
    return ListTile(
      leading: Icon(Icons.sync, color: ThemeService.primaryColor),
      title: Text(languageService.translate('sincronizacao_auto') ?? 'Sincronização Automática'),
      subtitle: Text(_autoSyncEnabled ? 
        languageService.translate('sinc_auto_ativa') ?? 'Sincronização automática ativa' : 
        languageService.translate('sinc_auto_inativa') ?? 'Sincronização automática inativa'),
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

  Widget _buildLanguageTile(BuildContext context, ThemeService themeService, LanguageService languageService) {
    String getCurrentLanguageName() {
      switch (languageService.currentLocale.languageCode) {
        case 'pt':
          return languageService.translate('portugues') ?? 'Português (Brasil)';
        case 'en':
          return languageService.translate('ingles') ?? 'English (US)';
        case 'es':
          return languageService.translate('espanhol') ?? 'Español';
        default:
          return languageService.translate('portugues') ?? 'Português (Brasil)';
      }
    }

    return ListTile(
      leading: Icon(Icons.language, color: ThemeService.primaryColor),
      title: Text(languageService.translate('idioma') ?? 'Idioma'),
      subtitle: Text(getCurrentLanguageName()),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showLanguageOptions(context, languageService),
    );
  }

  // ✅ OPÇÃO: PRIVACIDADE
  Widget _buildPrivacyTile(BuildContext context, ThemeService themeService, LanguageService languageService) {
    return ListTile(
      leading: Icon(Icons.privacy_tip, color: ThemeService.primaryColor),
      title: Text(languageService.translate('privacidade') ?? 'Privacidade'),
      subtitle: Text(languageService.translate('config_privacidade') ?? 'Configurar privacidade'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showPrivacyOptions(context, languageService),
    );
  }

  // ✅ OPÇÃO: SEGURANÇA
  Widget _buildSecurityTile(BuildContext context, ThemeService themeService, LanguageService languageService) {
    return ListTile(
      leading: Icon(Icons.security, color: ThemeService.primaryColor),
      title: Text(languageService.translate('seguranca') ?? 'Segurança'),
      subtitle: Text(languageService.translate('config_seguranca') ?? 'Configurar segurança'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showSecurityOptions(context, languageService),
    );
  }

  Widget _buildAppInfo(ThemeService themeService, LanguageService languageService) {
    return ListTile(
      leading: Icon(Icons.info, color: ThemeService.primaryColor),
      title: Text(languageService.translate('versao_app') ?? 'Versão do App'),
      subtitle: const Text('1.0.0'),
    );
  }

  // ✅ OPÇÃO: AVALIAR APP
  Widget _buildRateAppTile(ThemeService themeService, LanguageService languageService) {
    return ListTile(
      leading: Icon(Icons.star, color: ThemeService.primaryColor),
      title: Text(languageService.translate('avaliar_app') ?? 'Avaliar App'),
      subtitle: Text(languageService.translate('avaliar_na_loja') ?? 'Avaliar na loja de aplicativos'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _rateApp(context, languageService),
    );
  }

  // ✅ OPÇÃO: COMPARTILHAR APP
  Widget _buildShareAppTile(ThemeService themeService, LanguageService languageService) {
    return ListTile(
      leading: Icon(Icons.share, color: ThemeService.primaryColor),
      title: Text(languageService.translate('compartilhar_app') ?? 'Compartilhar App'),
      subtitle: Text(languageService.translate('compartilhar_amigos') ?? 'Compartilhar com amigos'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _shareApp(context, languageService),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeService themeService, LanguageService languageService) {
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
          child: Text(languageService.translate('alternar_tema') ?? 'ALTERNAR TEMA AGORA'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _showResetDialog(context, languageService),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text(languageService.translate('redefinir_config') ?? 'REDEFINIR CONFIGURAÇÕES'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: ThemeService.primaryColor,
            side: BorderSide(color: ThemeService.primaryColor),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text(languageService.translate('voltar') ?? 'VOLTAR'),
        ),
      ],
    );
  }

  // ✅ FOOTER
  Widget _buildFooter(ThemeService themeService, LanguageService languageService) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Text(
            languageService.translate('direitos_reservados') ?? '© Todos os direitos reservados - 2025',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'TaskDomus v1.0.0',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ MÉTODO _showLanguageOptions CORRIGIDO E MELHORADO
  void _showLanguageOptions(BuildContext context, LanguageService languageService) {
    final languages = [
      {
        'name': languageService.translate('portugues') ?? 'Português (Brasil)',
        'code': 'pt',
        'locale': const Locale('pt', 'BR'),
        'flag': '🇧🇷'
      },
      {
        'name': languageService.translate('ingles') ?? 'English (US)',
        'code': 'en', 
        'locale': const Locale('en', 'US'),
        'flag': '🇺🇸'
      },
      {
        'name': languageService.translate('espanhol') ?? 'Español',
        'code': 'es',
        'locale': const Locale('es', 'ES'),
        'flag': '🇪🇸'
      },
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageService.translate('selecionar_idioma') ?? 'Selecionar Idioma'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) {
              final bool isSelected = languageService.currentLocale.languageCode == language['code'];
              
              return ListTile(
                leading: Text(
                  language['flag'] ?? '🏳️', 
                  style: const TextStyle(fontSize: 24)
                ),
                title: Text(language['name'] ?? 'Idioma'),
                trailing: isSelected 
                    ? Icon(Icons.check_circle, color: ThemeService.primaryColor)
                    : null,
                onTap: () {
                  // ✅ CORREÇÃO: Verificação segura do locale
                  final locale = language['locale'];
                  if (locale != null && locale is Locale) {
                    languageService.setLocale(locale);
                  }
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${languageService.translate('idioma_alterado') ?? 'Idioma alterado para'} ${language['name'] ?? ''}'
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageService.translate('fechar') ?? 'FECHAR'),
          ),
        ],
      ),
    );
  }

  // ✅ MÉTODO ALTERNATIVO MAIS SEGURO PARA SELEÇÃO DE IDIOMA
  void _showLanguageOptionsAlternative(BuildContext context, LanguageService languageService) {
    // ✅ Usando o método do LanguageService que já está corrigido
    final languages = languageService.getLanguagesWithFlags();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageService.translate('selecionar_idioma') ?? 'Selecionar Idioma'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) {
              final isSelected = languageService.currentLocale.languageCode == language['code'];
              
              return ListTile(
                leading: Text(
                  language['flag'] ?? '',// ✅ Agora pode usar ! porque temos certeza
                  style: TextStyle(fontSize: 24)
                ),
                title: Text(language['name'] ?? 'Idioma'),
                trailing: isSelected 
                    ? Icon(Icons.check_circle, color: ThemeService.primaryColor)
                    : null,
                onTap: () {
                
                  languageService.changeLanguageByCode(language['code']!);
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${languageService.translate('idioma_alterado') ?? 'Idioma alterado para'} ${language['name']}'
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageService.translate('fechar') ?? 'FECHAR'),
          ),
        ],
      ),
    );
  }

  // ✅ MÉTODOS PARA AS NOVAS FUNCIONALIDADES
  void _showPrivacyOptions(BuildContext context, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageService.translate('privacidade') ?? 'Privacidade'),
        content: Text(languageService.translate('em_desenvolvimento') ?? 'Funcionalidade em desenvolvimento...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageService.translate('fechar') ?? 'FECHAR'),
          ),
        ],
      ),
    );
  }

  void _showSecurityOptions(BuildContext context, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageService.translate('seguranca') ?? 'Segurança'),
        content: Text(languageService.translate('em_desenvolvimento') ?? 'Funcionalidade em desenvolvimento...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageService.translate('fechar') ?? 'FECHAR'),
          ),
        ],
      ),
    );
  }

  void _rateApp(BuildContext context, LanguageService languageService) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(languageService.translate('abrindo_loja') ?? 'Abrindo loja de aplicativos...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareApp(BuildContext context, LanguageService languageService) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(languageService.translate('compartilhando_app') ?? 'Compartilhando aplicativo...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showResetDialog(BuildContext context, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageService.translate('redefinir_config') ?? 'Redefinir Configurações'),
        content: Text(languageService.translate('confirmar_redefinir') ?? 'Tem certeza que deseja redefinir todas as configurações para os padrões?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageService.translate('cancelar') ?? 'CANCELAR'),
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
                SnackBar(
                  content: Text(languageService.translate('config_redefinidas') ?? 'Configurações redefinidas com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(languageService.translate('redefinir') ?? 'REDEFINIR'),
          ),
        ],
      ),
    );
  }

  // ✅ NOVO MÉTODO: Limpar cache (opcional)
  void _clearCache(BuildContext context, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageService.translate('limpar_cache') ?? 'Limpar Cache'),
        content: Text(languageService.translate('confirmar_limpar_cache') ?? 'Tem certeza que deseja limpar o cache do aplicativo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageService.translate('cancelar') ?? 'CANCELAR'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(languageService.translate('cache_limpo') ?? 'Cache limpo com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(languageService.translate('limpar') ?? 'LIMPAR'),
          ),
        ],
      ),
    );
  }
}