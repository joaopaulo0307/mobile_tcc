import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/tarefa_service.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  bool _isEditing = false;
  String _editingId = '';
  
  // Cores baseadas nas imagens
  final Color _corPrincipal = const Color(0xFF4A6572); // Cinza azulado
  final Color _corSecundaria = const Color(0xFF344955); // Cinza escuro
  final Color _corDestaque = const Color(0xFFF9AA33); // Laranja
  final Color _corTexto = Colors.white;
  final Color _corTextoClaro = const Color(0xFFB0BEC5);

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  // Função para obter o mês atual como string
  String _getMesAtual() {
    final meses = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return meses[DateTime.now().month - 1];
  }

  // Widget da sidebar esquerda
  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: _corSecundaria,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header da sidebar
          Container(
            height: 150,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _corPrincipal,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getMesAtual(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _corTexto,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Calendário',
                  style: TextStyle(
                    fontSize: 16,
                    color: _corTextoClaro,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu da sidebar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuItem(
                    icon: Icons.home,
                    text: 'HOME',
                    isActive: false,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.attach_money,
                    text: 'ECONÓMICO',
                    isActive: false,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.people,
                    text: 'USUÁRIOS',
                    isActive: false,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.calendar_today,
                    text: 'CALENDÁRIO',
                    isActive: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 30),
                  _buildMenuItem(
                    icon: Icons.house,
                    text: 'MINHAS CASAS',
                    isActive: false,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.person,
                    text: 'MEU PERFIL',
                    isActive: false,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.settings,
                    text: 'CONFIGURAÇÕES',
                    isActive: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          
          // Footer da sidebar
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Organize suas tarefas\nde forma simples',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: _corTextoClaro,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '© Todos os direitos reservados - 2025',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: _corTextoClaro.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isActive ? _corPrincipal.withOpacity(0.3) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? _corDestaque : _corTextoClaro,
                size: 20,
              ),
              const SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  color: isActive ? _corTexto : _corTextoClaro,
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget do conteúdo principal (calendário + tarefas)
  Widget _buildMainContent(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            // Header do conteúdo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatarDataCompleta(_focusedDay),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _corPrincipal,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left, color: _corPrincipal),
                        onPressed: _mesAnterior,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _corDestaque,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Hoje',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.chevron_right, color: _corPrincipal),
                        onPressed: _proximoMes,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Calendário
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCalendar(context),
                    const SizedBox(height: 20),
                    _buildTarefasSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return Consumer<TarefaService>(
      builder: (context, tarefaService, child) {
        return Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(
                color: _corPrincipal,
                fontWeight: FontWeight.w500,
              ),
              weekendTextStyle: TextStyle(
                color: _corPrincipal,
                fontWeight: FontWeight.w500,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              todayTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              todayDecoration: BoxDecoration(
                color: _corDestaque,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: _corPrincipal,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
              outsideTextStyle: TextStyle(
                color: _corPrincipal.withOpacity(0.3),
              ),
              weekendDecoration: const BoxDecoration(),
              holidayDecoration: const BoxDecoration(),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              formatButtonShowsNext: false,
              titleTextStyle: TextStyle(
                color: _corPrincipal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: _corPrincipal,
                size: 30,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: _corPrincipal,
                size: 30,
              ),
              headerPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: _corPrincipal,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              weekendStyle: TextStyle(
                color: _corPrincipal,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final tarefasDoDia = tarefaService.getTarefasPorData(date, 'default');
                
                if (tarefasDoDia.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _corDestaque,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTarefasSection(BuildContext context) {
    return Consumer<TarefaService>(
      builder: (context, tarefaService, child) {
        final tarefas = tarefaService.getTarefasPorData(_selectedDay, 'default');
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tarefas do dia',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _corPrincipal,
                ),
              ),
              const SizedBox(height: 15),
              
              if (tarefas.isEmpty)
                _buildEmptyTarefas()
              else
                ...tarefas.map((tarefa) => _buildTarefaCard(
                  tarefa: tarefa,
                  onEdit: () => _editarTarefa(tarefa),
                  onDelete: () => _excluirTarefa(context, tarefa.id),
                  onToggle: () => _toggleTarefa(context, tarefa.id),
                )).toList(),
              
              const SizedBox(height: 20),
              // Botão para adicionar nova tarefa
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('NOVA TAREFA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _corPrincipal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _adicionarTarefa,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTarefaCard({
    required Tarefa tarefa,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required VoidCallback onToggle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    value: tarefa.concluida,
                    onChanged: (value) => onToggle(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    activeColor: _corDestaque,
                  ),
                ),
                
                const SizedBox(width: 10),
                
                // Conteúdo da tarefa
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tarefa.titulo,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _corPrincipal,
                          decoration: tarefa.concluida
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      if (tarefa.descricao.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            tarefa.descricao,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              decoration: tarefa.concluida
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Botões de ação
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: _corPrincipal, size: 20),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[400], size: 20),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTarefas() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_note,
            size: 60,
            color: _corTextoClaro,
          ),
          const SizedBox(height: 20),
          Text(
            'Nenhuma tarefa para hoje',
            style: TextStyle(
              color: _corPrincipal,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Adicione tarefas clicando no botão abaixo',
            style: TextStyle(
              color: _corTextoClaro,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _adicionarTarefa() {
    _tituloController.clear();
    _descricaoController.clear();
    _isEditing = false;
    _editingId = '';

    _showTarefaDialog();
  }

  void _editarTarefa(Tarefa tarefa) {
    _tituloController.text = tarefa.titulo;
    _descricaoController.text = tarefa.descricao;
    _isEditing = true;
    _editingId = tarefa.id;

    _showTarefaDialog();
  }

  void _showTarefaDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            _isEditing ? 'Alteração' : 'Nova Tarefa',
            style: TextStyle(
              color: _corPrincipal,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título
                Text(
                  'Nome:',
                  style: TextStyle(
                    color: _corPrincipal,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    hintText: 'Digite o nome da tarefa',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                  ),
                  style: TextStyle(color: _corPrincipal),
                ),
                
                const SizedBox(height: 20),
                
                // Descrição
                Text(
                  'Descrição:',
                  style: TextStyle(
                    color: _corPrincipal,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                    hintText: 'Digite a descrição da tarefa',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                  ),
                  maxLines: 4,
                  style: TextStyle(color: _corPrincipal),
                ),
                
                const SizedBox(height: 20),
                
                // Data
                Text(
                  'Data: ${_formatarDataSimples(_selectedDay)}',
                  style: TextStyle(
                    color: _corPrincipal.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // Botão REMOVER (só aparece no modo edição)
            if (_isEditing)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _excluirTarefa(context, _editingId);
                },
                child: Text(
                  'REMOVER',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            
            // Botão CANCELAR
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'CANCELAR',
                style: TextStyle(
                  color: _corPrincipal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            // Botão CONFIRMAR/CRIAR
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _corDestaque,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _salvarTarefa,
              child: Text(
                _isEditing ? 'CONFIRMAR' : 'CRIAR',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        );
      },
    );
  }

  void _salvarTarefa() {
    final titulo = _tituloController.text.trim();
    
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, insira um nome para a tarefa'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    final tarefaService = Provider.of<TarefaService>(context, listen: false);
    
    if (_isEditing) {
      // Buscar a tarefa existente para manter o estado de conclusão
      final tarefas = tarefaService.tarefas;
      final tarefaExistente = tarefas.firstWhere(
        (t) => t.id == _editingId,
        orElse: () => Tarefa(
          id: _editingId,
          titulo: '',
          descricao: '',
          data: DateTime.now(),
          cor: Colors.blue,
          concluida: false,
          casaId: 'default',
        ),
      );
      
      // Atualizar tarefa existente
      final tarefaAtualizada = Tarefa(
        id: _editingId,
        titulo: titulo,
        descricao: _descricaoController.text.trim(),
        data: _selectedDay,
        cor: const Color(0xFFF9AA33),
        casaId: 'default',
        concluida: tarefaExistente.concluida, // Mantém o estado de conclusão
      );
      
      tarefaService.atualizarTarefa(tarefaAtualizada);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarefa atualizada com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Criar nova tarefa
      final novaTarefa = Tarefa(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: titulo,
        descricao: _descricaoController.text.trim(),
        data: _selectedDay,
        cor: const Color(0xFFF9AA33),
        casaId: 'default',
        concluida: false,
      );

      tarefaService.adicionarTarefa(novaTarefa);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarefa criada com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }

    Navigator.pop(context);
    _tituloController.clear();
    _descricaoController.clear();
  }

  void _excluirTarefa(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Confirmar exclusão',
            style: TextStyle(
              color: _corPrincipal,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Tem certeza que deseja excluir esta tarefa?',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: _corPrincipal),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final tarefaService = Provider.of<TarefaService>(
                  context,
                  listen: false,
                );
                tarefaService.removerTarefa(id);
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tarefa excluída!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _toggleTarefa(BuildContext context, String id) {
    final tarefaService = Provider.of<TarefaService>(context, listen: false);
    tarefaService.toggleConcluida(id);
  }

  void _mesAnterior() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
    });
  }

  void _proximoMes() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
    });
  }

  String _formatarDataCompleta(DateTime date) {
    final days = ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];
    final months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    
    return '${days[date.weekday - 1]}, ${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  String _formatarDataSimples(DateTime date) {
    final days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    final months = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar esquerda
          _buildSidebar(context),
          
          // Conteúdo principal
          _buildMainContent(context),
        ],
      ),
    );
  }
}