import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../serviços/theme_service.dart';
import '../serviços/language_service.dart';

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
        title: Text('settings'.translate(context)),
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
        _buildSectionTitle('appearance'.translate(context)),
        _buildThemeSwitch(isDarkMode),
        const Divider(),
        
        _buildSectionTitle('notifications'.translate(context)),
        _buildNotificationSwitch(),
        const Divider(),

        _buildSectionTitle('language'.translate(context)),
        _buildLanguageTile(context),
        const Divider(),

        _buildSectionTitle('privacy'.translate(context)),
        _buildPrivacyTile(),
        const Divider(),

        _buildSectionTitle('account'.translate(context)),
        _buildAccountOptions(),
        const Divider(),

        _buildSectionTitle('about_app'.translate(context)),
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
      title: Text('dark_mode'.translate(context)),
      subtitle: Text('dark_mode_subtitle'.translate(context)),
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
          title: Text('notifications'.translate(context)),
          subtitle: Text('notifications_subtitle'.translate(context)),
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
    return ValueListenableBuilder<Locale>(
      valueListenable: LanguageService().localeNotifier,
      builder: (context, locale, child) {
        return ListTile(
          leading: const Icon(Icons.language, color: ThemeService.primaryColor),
          title: Text('language'.translate(context)),
          subtitle: Text(LanguageService().getCurrentLanguageName()),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            HapticFeedback.selectionClick();
            _showLanguageBottomSheet(context);
          },
        );
      },
    );
  }

  Widget _buildPrivacyTile() {
    return ListTile(
      leading: const Icon(Icons.security, color: ThemeService.primaryColor),
      title: Text('privacy_security'.translate(context)),
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
          title: Text('edit_profile'.translate(context)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            HapticFeedback.selectionClick();
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.lock, color: ThemeService.primaryColor),
          title: Text('change_password'.translate(context)),
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
          title: Text('app_version'.translate(context)),
          subtitle: const Text('1.0.0'),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.description, color: ThemeService.primaryColor),
          title: Text('terms_of_use'.translate(context)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            HapticFeedback.selectionClick();
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.privacy_tip, color: ThemeService.primaryColor),
          title: Text('privacy_policy'.translate(context)),
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
        child: Text(
          'back'.translate(context),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final languageService = LanguageService();
    final availableLanguages = languageService.getAvailableLanguages();
    
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
              Text(
                'select_language'.translate(context),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeService.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              ...availableLanguages.map((language) => 
                _buildLanguageOption(
                  language['name']!,
                  language['code']!,
                  context,
                )
              ).toList(),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('close'.translate(context)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, String languageCode, BuildContext context) {
    final isSelected = LanguageService().currentLocale == _parseLocale(languageCode);
    
    return ListTile(
      leading: Icon(
        Icons.check,
        color: isSelected ? ThemeService.primaryColor : Colors.transparent,
      ),
      title: Text(language),
      onTap: () {
        HapticFeedback.selectionClick();
        LanguageService().setLocale(_parseLocale(languageCode));
        Navigator.pop(context);
        setState(() {}); // Força o rebuild para atualizar os textos
      },
    );
  }

  Locale _parseLocale(String localeString) {
    final parts = localeString.split('_');
    return Locale(parts[0], parts[1]);
  }
}