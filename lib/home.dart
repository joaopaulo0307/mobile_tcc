import 'package:flutter/material.dart';
import 'package:mobile_tcc/calendario/calendario.dart';
import 'package:mobile_tcc/economic/economico.dart';
import 'package:mobile_tcc/meu_casas.dart';
import 'package:mobile_tcc/perfil.dart';
import 'package:mobile_tcc/usuarios.dart';
import 'package:mobile_tcc/config.dart';
import 'package:provider/provider.dart';
import '../acesso/auth_service.dart';
import '../serviços/theme_service.dart';
import '../serviços/tarefa_service.dart';

class HomePage extends StatefulWidget {
  final Map<String, String> casa;
  
  const HomePage({super.key, required this.casa});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _userName = "Usuário";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userData = await AuthService.getUserData();

      if (!mounted) return;

      if (userData != null) {
        final nome = userData['nome'];
        if (nome is String && nome.isNotEmpty) {
          setState(() {
            _userName = nome;
          });
        }
      }
    } catch (e) {
      debugPrint("Erro ao carregar usuário: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ThemeService.primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Olá, $_userName',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _getCurrentDate(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    final months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    
    return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]}';
  }

  Widget _buildDrawer() {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
        final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;

        return Drawer(
          backgroundColor: backgroundColor,
          child: Column(
            children: [
              _buildDrawerHeader(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      icon: Icons.attach_money,
                      title: 'ECONÔMICO',
                      textColor: textColor,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Economico()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.calendar_today,
                      title: 'CALENDÁRIO',
                      textColor: textColor,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CalendarioPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.people,
                      title: 'USUÁRIOS',
                      textColor: textColor,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Usuarios()),
                        );
                      },
                    ),
                    Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300]),
                    _buildDrawerItem(
                      icon: Icons.house,
                      title: 'MINHAS CASAS',
                      textColor: textColor,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const MeuCasas()),
                          (route) => false,
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.person,
                      title: 'MEU PERFIL',
                      textColor: textColor,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PerfilPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      title: 'CONFIGURAÇÕES',
                      textColor: textColor,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ConfigPage()),
                        );
                      },
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

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: ThemeService.primaryColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Text(
                "TD",
                style: TextStyle(
                  color: Color(0xFF133A67),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.casa['nome'] ?? 'Minha Casa',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _userName,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
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
  }) {
    return ListTile(
      leading: Icon(icon, color: ThemeService.primaryColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildListaTarefas() {
    final tarefaService = Provider.of<TarefaService>(context);
    final casaId = widget.casa['id'] ?? 'default';
    final tarefasPendentes = tarefaService.getTarefasPendentesPorCasa(casaId);

    if (_isLoading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(
            color: ThemeService.primaryColor,
          ),
        ),
      );
    }

    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
        final cardColor = isDarkMode ? ThemeService.cardColorDark : ThemeService.cardColorLight;
        final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;

        return Expanded(
          child: Container(
            color: backgroundColor,
            child: tarefasPendentes.isEmpty 
                ? _buildEmptyState(textColor: textColor)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tarefasPendentes.length,
                    itemBuilder: (context, index) {
                      final tarefa = tarefasPendentes[index];
                      return _buildTarefaItem(
                        tarefa: tarefa,
                        cardColor: cardColor,
                        textColor: textColor,
                        onTap: () {
                          _mostrarDetalhesTarefa(tarefa);
                        },
                        onConcluir: () {
                          _marcarTarefaComoConcluida(tarefa.id);
                        },
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
            Icons.check_circle_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma tarefa pendente',
            style: TextStyle(
              fontSize: 16,
              color: textColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione tarefas no calendário',
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarefaItem({
    required Tarefa tarefa,
    required Color cardColor,
    required Color textColor,
    required VoidCallback onTap,
    required VoidCallback onConcluir,
  }) {
    return GestureDetector(
      onTap: onTap,
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
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: tarefa.cor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tarefa.titulo,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatarData(tarefa.data),
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                  if (tarefa.descricao.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      tarefa.descricao,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.check_circle_outline,
                color: ThemeService.primaryColor,
              ),
              onPressed: onConcluir,
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalhesTarefa(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (context) {
        return ValueListenableBuilder<bool>(
          valueListenable: ThemeService.themeNotifier,
          builder: (context, isDarkMode, child) {
            final cardColor = isDarkMode ? ThemeService.cardColorDark : ThemeService.cardColorLight;
            final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;
            
            return AlertDialog(
              backgroundColor: cardColor,
              title: Text(
                tarefa.titulo,
                style: TextStyle(color: textColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tarefa.descricao.isNotEmpty) ...[
                    Text(
                      tarefa.descricao,
                      style: TextStyle(color: textColor.withOpacity(0.8)),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: tarefa.cor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: tarefa.cor),
                        const SizedBox(width: 8),
                        Text(
                          _formatarDataCompleta(tarefa.data),
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Fechar',
                    style: TextStyle(color: textColor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeService.primaryColor,
                  ),
                  onPressed: () {
                    _marcarTarefaComoConcluida(tarefa.id);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Concluir Tarefa',
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

  void _marcarTarefaComoConcluida(String id) {
    final tarefaService = Provider.of<TarefaService>(context, listen: false);
    tarefaService.marcarComoConcluida(id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tarefa concluída com sucesso!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildSecaoOpcoes() {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
        final cardColor = isDarkMode ? ThemeService.cardColorDark : ThemeService.cardColorLight;
        final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;

        return Container(
          padding: const EdgeInsets.all(16),
          color: backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Acesso Rápido',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildGridOpcoes(cardColor: cardColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGridOpcoes({required Color cardColor}) {
    final opcoes = [
      {
        'icon': Icons.people,
        'label': 'Usuários',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Usuarios())),
      },
      {
        'icon': Icons.attach_money,
        'label': 'Econômico',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Economico())),
      },
      {
        'icon': Icons.calendar_today,
        'label': 'Calendário',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarioPage())),
      },
      {
        'icon': Icons.house,
        'label': 'Minhas Casas',
        'onTap': () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MeuCasas()),
          (route) => false,
        ),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: opcoes.length,
      itemBuilder: (context, index) {
        final opcao = opcoes[index];
        return _buildOpcaoItem(
          icon: opcao['icon'] as IconData,
          label: opcao['label'] as String,
          cardColor: cardColor,
          onTap: opcao['onTap'] as VoidCallback,
        );
      },
    );
  }

  Widget _buildOpcaoItem({
    required IconData icon,
    required String label,
    required Color cardColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: ThemeService.primaryColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: ThemeService.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildDivisor() {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, isDarkMode, child) {
        final divisorColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
        return Container(
          height: 1,
          color: divisorColor,
        );
      },
    );
  }

  String _formatarData(DateTime data) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(data.year, data.month, data.day);
    
    if (taskDate == today) {
      return 'Hoje • ${_formatarHora(data)}';
    } else if (taskDate == today.add(const Duration(days: 1))) {
      return 'Amanhã • ${_formatarHora(data)}';
    } else {
      final days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
      return '${days[data.weekday - 1]}, ${data.day}/${data.month} • ${_formatarHora(data)}';
    }
  }

  String _formatarHora(DateTime data) {
    return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  String _formatarDataCompleta(DateTime data) {
    final days = ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];
    final months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    
    return '${days[data.weekday - 1]}, ${data.day} de ${months[data.month - 1]} de ${data.year} às ${_formatarHora(data)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListaTarefas(),
          _buildDivisor(),
          _buildSecaoOpcoes(),
          _buildFooter(),
        ],
      ),
    );
  }
}