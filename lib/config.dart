import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para feedback tátil
import 'package:mobile_tcc/home.dart';
import 'package:mobile_tcc/main.dart';

// 🔹 Cores do app (mantidas iguais às do main.dart)
const Color primaryColor = Color(0xFF133A67);
const Color secondaryColor = Color(0xFF5E83AE);
const Color backgroundLight = Color(0xFFF0E8D5);

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
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Opções gerais',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ------------------ CONTEÚDO ------------------
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // ---------- SEÇÃO: NOTIFICAÇÕES ----------
          ListTile(
            leading: const Icon(Icons.notifications, color: primaryColor),
            title: const Text(
              'Notificações',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Ativar/desativar sons e alertas'),
            trailing: Switch(
              value: notificacoesAtivas,
              thumbColor: WidgetStateProperty.resolveWith<Color>(
                (states) => notificacoesAtivas ? secondaryColor : Colors.grey,
              ),
              trackColor: WidgetStateProperty.resolveWith<Color>(
                (states) => notificacoesAtivas
                    ? secondaryColor.withOpacity(0.4)
                    : Colors.grey.shade400,
              ),
              onChanged: (valor) {
                HapticFeedback.lightImpact(); // vibração leve
                setState(() {
                  notificacoesAtivas = valor;
                });
              },
            ),
          ),
          const Divider(),

          // ---------- SEÇÃO: IDIOMA ----------
          ListTile(
            leading: const Icon(Icons.language, color: primaryColor),
            title: const Text('Idioma'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Português'),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
            onTap: () {
              HapticFeedback.selectionClick();
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => _idiomaSheet(context),
              );
            },
          ),
          const Divider(),

          // ---------- SEÇÃO: PRIVACIDADE ----------
          ListTile(
            leading: const Icon(Icons.lock, color: primaryColor),
            title: const Text('Privacidade'),
            onTap: () {
              HapticFeedback.selectionClick();
            },
          ),
          const Divider(thickness: 1),

          // ---------- SEÇÃO: CONTA ----------
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 12, 8, 6),
            child: Text(
              'Conta',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: primaryColor),
            title: const Text('Editar perfil'),
            onTap: () {
              HapticFeedback.selectionClick();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.vpn_key, color: primaryColor),
            title: const Text('Alterar senha'),
            onTap: () {
              HapticFeedback.selectionClick();
            },
          ),
          const Divider(thickness: 1),

          // ---------- SEÇÃO: SOBRE O APP ----------
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 12, 8, 6),
            child: Text(
              'Sobre o app',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.lightbulb_outline, color: primaryColor),
            title: Text('Versão do aplicativo'),
            subtitle: Text('1.0.0'),
          ),
          const Divider(),
          ListTile(
            leading:
                const Icon(Icons.description_outlined, color: primaryColor),
            title: const Text('Termos e Política'),
            onTap: () {
              HapticFeedback.selectionClick();
            },
          ),

          const SizedBox(height: 24),

          // ---------- BOTÃO SAIR ----------
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              label: const Text(
                'Voltar',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Modal de seleção de idioma ----------
  Widget _idiomaSheet(BuildContext context) {
    return Container(
      color: backgroundLight,
      padding: const EdgeInsets.all(16),
      child: Wrap(
        children: [
          const Center(
            child: Text(
              'Selecione o idioma',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: primaryColor,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.flag, color: primaryColor),
            title: const Text('Português (Brasil)'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.language, color: primaryColor),
            title: const Text('Inglês (EUA)'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.translate, color: primaryColor),
            title: const Text('Espanhol'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
