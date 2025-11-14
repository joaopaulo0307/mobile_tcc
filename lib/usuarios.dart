import 'package:flutter/material.dart';
import '../serviços/theme_service.dart';
import 'package:mobile_tcc/calendario/calendario.dart';
import 'package:mobile_tcc/economic/economico.dart';
import 'package:mobile_tcc/meu_casas.dart';
import 'package:mobile_tcc/perfil.dart';
import 'package:mobile_tcc/usuarios.dart';
import 'package:mobile_tcc/config.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({super.key});

  @override
  State<Usuarios> createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  final List<Map<String, String>> _membros = [];

  // ==================== MODAL ADICIONAR MEMBRO ====================
  void _showAddMemberModal() {
    final nomeController = TextEditingController();
    final descricaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder<bool>(
          valueListenable: ThemeService.themeNotifier,
          builder: (context, isDarkMode, child) {
            final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
            final cardColor = isDarkMode ? ThemeService.cardColorDark : ThemeService.cardColorLight;
            final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;

            return AlertDialog(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                'Adicionar Membro',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ThemeService.primaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descricaoController,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ThemeService.primaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: TextStyle(color: textColor),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nomeController.text.trim().isNotEmpty) {
                      setState(() {
                        _membros.add({
                          'nome': nomeController.text.trim(),
                          'descricao': descricaoController.text.trim(),
                        });
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeService.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==================== MODAL REMOVER MEMBRO ====================
  void _showRemoveMemberModal(int index) {
    final membro = _membros[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder<bool>(
          valueListenable: ThemeService.themeNotifier,
          builder: (context, isDarkMode, child) {
            final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
            final cardColor = isDarkMode ? ThemeService.cardColorDark : ThemeService.cardColorLight;
            final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;

            return AlertDialog(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                'Remover Membro',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome: ${membro['nome']}',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Descrição: ${membro['descricao']}',
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tem certeza que deseja remover este membro?',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _membros.removeAt(index);
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Remover',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==================== HEADER ====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ThemeService.primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: const Text(
        'Membros',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  // ==================== LISTA DE MEMBROS ====================
  Widget _buildListaMembros() {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
        final cardColor = isDarkMode ? ThemeService.cardColorDark : ThemeService.cardColorLight;
        final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;

        return Expanded(
          child: Container(
            color: backgroundColor,
            child: _membros.isEmpty
                ? _buildEmptyState(textColor: textColor)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _membros.length,
                    itemBuilder: (context, index) {
                      return _buildMembroItem(
                        membro: _membros[index],
                        index: index,
                        cardColor: cardColor,
                        textColor: textColor,
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({required Color textColor}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: textColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum membro cadastrado',
            style: TextStyle(
              color: textColor.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Clique em "+ Add Membro" para adicionar',
            style: TextStyle(
              color: textColor.withOpacity(0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembroItem({
    required Map<String, String> membro,
    required int index,
    required Color cardColor,
    required Color textColor,
  }) {
    return Container(
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
          // Ícone do usuário
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ThemeService.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: ThemeService.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          // Informações do membro
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  membro['nome']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                if (membro['descricao']!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    membro['descricao']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Botão remover
          IconButton(
            onPressed: () => _showRemoveMemberModal(index),
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== BOTÕES DE AÇÃO ====================
  Widget _buildBotoesAcao() {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;

        return Container(
          padding: const EdgeInsets.all(16),
          color: backgroundColor,
          child: Row(
            children: [
              // Botão Adicionar Membro
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showAddMemberModal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeService.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: const Text(
                    '+ Add Membro',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Botão Remover Membro
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _membros.isEmpty ? null : () {
                    // Pode mostrar uma modal de confirmação para remover todos ou outra lógica
                    _showRemoveMemberModal(0); // Remove o primeiro como exemplo
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.remove, color: Colors.white, size: 20),
                  label: const Text(
                    '- Remover Membro',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== FOOTER ====================
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: ThemeService.primaryColor,
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

  // ==================== BUILD PRINCIPAL ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildListaMembros(),
          _buildBotoesAcao(),
          _buildFooter(),
        ],
      ),
    );
  }
}