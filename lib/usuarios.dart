import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart'; 
import '../home.dart'; 
import '../meu_casas.dart'; 
import '../perfil.dart';
import '../config.dart'; 
import '../calendario/calendario.dart'; 
import '../economic/economico.dart'; 

class Usuarios extends StatefulWidget {
  const Usuarios({super.key});

  @override
  State<Usuarios> createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  final List<Map<String, String>> _membros = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // ✅ MEMBROS DE EXEMPLO PARA TESTE
    _membros.addAll([
      {
        'nome': 'João Silva',
        'descricao': 'Administrador',
        'email': 'joao@email.com',
        'telefone': '(11) 99999-9999',
        'cargo': 'Admin',
        'data_cadastro': '2024-01-15'
      },
      {
        'nome': 'Maria Santos',
        'descricao': 'Membro da família',
        'email': 'maria@email.com',
        'telefone': '(11) 88888-8888',
        'cargo': 'Membro',
        'data_cadastro': '2024-01-20'
      },
    ]);
  }

  // ✅ FILTRAR MEMBROS POR PESQUISA
  List<Map<String, String>> get _filteredMembros {
    if (_searchQuery.isEmpty) return _membros;
    return _membros.where((membro) =>
      membro['nome']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      membro['descricao']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      membro['email']!.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  // ==================== DRAWER ====================
  Widget _buildDrawer(BuildContext context) {
    return Consumer2<ThemeService, LanguageService>(
      builder: (context, themeService, languageService, child) {
        final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
        final textColor = Theme.of(context).colorScheme.onSurface;

        return Drawer(
          backgroundColor: backgroundColor,
          child: Column(
            children: [
              _buildDrawerHeader(context, languageService),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      icon: Icons.attach_money,
                      title: languageService.translate('economico') ?? 'Econômico',
                      textColor: textColor,
                      onTap: () => _navigateToEconomico(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.calendar_today,
                      title: languageService.translate('calendario') ?? 'Calendário',
                      textColor: textColor,
                      onTap: () => _navigateTo(context, const CalendarioPage()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.people,
                      title: languageService.translate('usuarios') ?? 'Usuários',
                      textColor: textColor,
                      onTap: () => Navigator.pop(context),
                      isSelected: true,
                    ),
                    Divider(color: Theme.of(context).dividerColor),
                    _buildDrawerItem(
                      icon: Icons.house,
                      title: languageService.translate('minhas_casas') ?? 'Minhas Casas',
                      textColor: textColor,
                      onTap: () => _navigateToHome(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.person,
                      title: languageService.translate('meu_perfil') ?? 'Meu Perfil',
                      textColor: textColor,
                      onTap: () => _navigateTo(context, const PerfilPage()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      title: languageService.translate('configuracoes') ?? 'Configurações',
                      textColor: textColor,
                      onTap: () => _navigateTo(context, const ConfigPage()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerHeader(BuildContext context, LanguageService languageService) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              child: Text(
                "TD",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              languageService.translate('membros') ?? 'Membros',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              languageService.translate('administracao_usuarios') ?? 'Administração de Usuários',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Color textColor,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? ThemeService.primaryColor : Theme.of(context).primaryColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? ThemeService.primaryColor : textColor,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: ThemeService.primaryColor, size: 16) : null,
      onTap: onTap,
    );
  }

  // ==================== APP BAR ====================
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return AppBar(
          backgroundColor: ThemeService.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                languageService.translate('membros') ?? 'Membros',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                // ✅ CORREÇÃO: Versão simplificada sem translateWithParams
                _membros.isEmpty 
                  ? (languageService.translate('nenhum_membro') ?? 'Nenhum membro')
                  : '${_membros.length} ${languageService.translate('membros') ?? 'membros'}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => _showSearchDialog(context, languageService),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.language, color: Colors.white),
              onSelected: (value) {
                if (value == 'pt') {
                  languageService.setLocale(const Locale('pt', 'BR'));
                } else if (value == 'en') {
                  languageService.setLocale(const Locale('en', 'US'));
                } else if (value == 'es') {
                  languageService.setLocale(const Locale('es', 'ES'));
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'pt',
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: Colors.green),
                      const SizedBox(width: 8),
                      const Text('Português'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'en',
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text('English'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'es',
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Text('Español'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ==================== BARRA DE PESQUISA ====================
  void _showSearchDialog(BuildContext context, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageService.translate('pesquisar') ?? 'Pesquisar'),
        content: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: languageService.translate('pesquisar_membros') ?? 'Pesquisar membros...',
            prefixIcon: const Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
              Navigator.pop(context);
            },
            child: Text(languageService.translate('limpar') ?? 'Limpar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageService.translate('fechar') ?? 'Fechar'),
          ),
        ],
      ),
    );
  }

  // ==================== MODAL ADICIONAR MEMBRO ====================
  void _showAddMemberModal(BuildContext context) {
    final nomeController = TextEditingController();
    final emailController = TextEditingController();
    final telefoneController = TextEditingController();
    final descricaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final languageService = Provider.of<LanguageService>(context, listen: false);
        
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            languageService.translate('adicionar_membro') ?? 'Adicionar Membro',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: nomeController,
                  label: languageService.translate('nome') ?? 'Nome',
                  isRequired: true,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: emailController,
                  label: languageService.translate('email') ?? 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: telefoneController,
                  label: languageService.translate('telefone') ?? 'Telefone',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: descricaoController,
                  label: languageService.translate('descricao') ?? 'Descrição',
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(languageService.translate('cancelar') ?? 'Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nomeController.text.trim().isNotEmpty) {
                  setState(() {
                    _membros.add({
                      'nome': nomeController.text.trim(),
                      'email': emailController.text.trim(),
                      'telefone': telefoneController.text.trim(),
                      'descricao': descricaoController.text.trim(),
                      'cargo': 'Membro',
                      'data_cadastro': DateTime.now().toIso8601String(),
                    });
                  });
                  Navigator.of(context).pop();
                  _showSuccessMessage(context, languageService);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeService.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(languageService.translate('confirmar') ?? 'Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: '$label${isRequired ? ' *' : ''}',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ThemeService.primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // ==================== MODAL DETALHES DO MEMBRO ====================
  void _showMemberDetailsModal(int index, BuildContext context) {
    final membro = _filteredMembros[index];
    final languageService = Provider.of<LanguageService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(membro['nome']!),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('E-mail', membro['email']),
              _buildDetailItem('Telefone', membro['telefone']),
              _buildDetailItem('Descrição', membro['descricao']),
              _buildDetailItem('Cargo', membro['cargo']),
              _buildDetailItem('Data de Cadastro', membro['data_cadastro']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageService.translate('fechar') ?? 'Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? 'Não informado')),
        ],
      ),
    );
  }

  // ==================== LISTA DE MEMBROS ====================
  Widget _buildListaMembros(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Expanded(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: _filteredMembros.isEmpty
                ? _buildEmptyState(languageService: languageService)
                : Column(
                    children: [
                      // ✅ CONTADOR DE RESULTADOS (CORRIGIDO)
                      if (_searchQuery.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Icon(Icons.search, size: 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                              const SizedBox(width: 8),
                              Text(
                                // ✅ CORREÇÃO: Texto simples sem translateWithParams
                                '${_filteredMembros.length} resultados encontrados',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      // ✅ LISTA DE MEMBROS
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredMembros.length,
                          itemBuilder: (context, index) {
                            return _buildMembroItem(
                              membro: _filteredMembros[index],
                              index: index,
                              languageService: languageService,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({required LanguageService languageService}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            languageService.translate('nenhum_membro_cadastrado') ?? 'Nenhum membro cadastrado',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            languageService.translate('clique_adicionar_membro') ?? 'Clique em "+ Add Membro" para adicionar',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMembroItem({
    required Map<String, String> membro,
    required int index,
    required LanguageService languageService,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
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
        title: Text(
          membro['nome']!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (membro['descricao']!.isNotEmpty)
              Text(
                membro['descricao']!,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            if (membro['email']!.isNotEmpty)
              Text(
                membro['email']!,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          onSelected: (value) {
            if (value == 'details') {
              _showMemberDetailsModal(index, context);
            } else if (value == 'edit') {
              // TODO: Implementar edição
            } else if (value == 'delete') {
              _showRemoveMemberModal(index, context);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'details',
              child: Row(
                children: [
                  const Icon(Icons.info, size: 18),
                  const SizedBox(width: 8),
                  Text(languageService.translate('detalhes') ?? 'Detalhes'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 18),
                  const SizedBox(width: 8),
                  Text(languageService.translate('editar') ?? 'Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Text(languageService.translate('excluir') ?? 'Excluir'),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _showMemberDetailsModal(index, context),
      ),
    );
  }

  // ==================== BOTÕES DE AÇÃO ====================
  Widget _buildBotoesAcao(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: [
              // ✅ BOTÃO ADICIONAR MEMBRO
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddMemberModal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeService.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: Text(
                    languageService.translate('adicionar_membro') ?? '+ Add Membro',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // ✅ BOTÃO EXPORTAR
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _membros.isEmpty ? null : () => _exportMembers(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ThemeService.primaryColor,
                    side: BorderSide(color: ThemeService.primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.file_download, size: 20),
                  label: Text(
                    languageService.translate('exportar') ?? 'Exportar',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== MODAL REMOVER MEMBRO ====================
  void _showRemoveMemberModal(int index, BuildContext context) {
    final membro = _filteredMembros[index];
    final languageService = Provider.of<LanguageService>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            languageService.translate('remover_membro') ?? 'Remover Membro',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${languageService.translate('nome') ?? 'Nome'}: ${membro['nome']}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              if (membro['descricao']!.isNotEmpty)
                Text(
                  '${languageService.translate('descricao') ?? 'Descrição'}: ${membro['descricao']}',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
                ),
              const SizedBox(height: 16),
              Text(
                languageService.translate('confirmar_exclusao') ?? 'Tem certeza que deseja remover este membro?',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(languageService.translate('cancelar') ?? 'Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final originalIndex = _membros.indexWhere((m) => m['nome'] == membro['nome']);
                if (originalIndex != -1) {
                  setState(() {
                    _membros.removeAt(originalIndex);
                  });
                }
                Navigator.of(context).pop();
                _showSuccessMessage(context, languageService, isDelete: true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(languageService.translate('remover') ?? 'Remover'),
            ),
          ],
        );
      },
    );
  }

  // ==================== MENSAGENS DE SUCESSO ====================
  void _showSuccessMessage(BuildContext context, LanguageService languageService, {bool isDelete = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isDelete
            ? languageService.translate('membro_removido_sucesso') ?? 'Membro removido com sucesso!'
            : languageService.translate('membro_adicionado_sucesso') ?? 'Membro adicionado com sucesso!'
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ==================== EXPORTAR MEMBROS ====================
  void _exportMembers(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(languageService.translate('exportando_membros') ?? 'Exportando lista de membros...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // ==================== FOOTER ====================
  Widget _buildFooter(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          color: ThemeService.primaryColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                languageService.translate('organize_tarefas') ?? "Organize suas tarefas de forma simples",
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                languageService.translate('direitos_reservados') ?? "© Todos os direitos reservados - 2025",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== MÉTODOS DE NAVEGAÇÃO ====================
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _navigateToEconomico(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Economico(casa: {'nome': 'Casa Atual', 'id': '1'})),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MeuCasas()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==================== BUILD PRINCIPAL ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          _buildListaMembros(context),
          _buildBotoesAcao(context),
          _buildFooter(context),
        ],
      ),
    );
  }
}