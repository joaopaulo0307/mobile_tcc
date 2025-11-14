import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../serviços/theme_service.dart';
import '../serviços/tarefa_service.dart';

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
  Color _selectedColor = Colors.blue;
  
  final List<Color> _coresDisponiveis = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeService.primaryColor,
        title: const Text(
          'CALENDÁRIO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: ThemeService.themeNotifier,
        builder: (context, isDarkMode, child) {
          final backgroundColor = isDarkMode ? ThemeService.backgroundDark : ThemeService.backgroundLight;
          final cardColor = isDarkMode ? ThemeService.cardColorDark : ThemeService.cardColorLight;
          final textColor = isDarkMode ? ThemeService.textColorDark : ThemeService.textColorLight;
          
          return Container(
            color: backgroundColor,
            child: Column(
              children: [
                _buildHeader(textColor),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildCalendar(cardColor, textColor, backgroundColor),
                        const SizedBox(height: 16),
                        _buildTarefasList(cardColor, textColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeService.primaryColor,
        onPressed: _adicionarTarefa,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeService.primaryColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: ThemeService.primaryColor.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            _getMonthYear(_focusedDay),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ThemeService.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hoje: ${_formatarData(DateTime.now())}',
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(Color cardColor, Color textColor, Color backgroundColor) {
    return Consumer<TarefaService>(
      builder: (context, tarefaService, child) {
        return Card(
          margin: const EdgeInsets.all(16),
          elevation: 2,
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                defaultTextStyle: TextStyle(color: textColor),
                weekendTextStyle: TextStyle(color: textColor),
                selectedTextStyle: const TextStyle(color: Colors.white),
                todayTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                todayDecoration: BoxDecoration(
                  color: ThemeService.primaryColor,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: ThemeService.primaryColor.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
                outsideTextStyle: TextStyle(color: textColor.withOpacity(0.3)),
                weekendDecoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.05),
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  border: Border.all(color: ThemeService.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                formatButtonTextStyle: TextStyle(color: ThemeService.primaryColor),
                titleTextStyle: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: ThemeService.primaryColor,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: ThemeService.primaryColor,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
                weekendStyle: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
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
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: ThemeService.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTarefasList(Color cardColor, Color textColor) {
    return Consumer<TarefaService>(
      builder: (context, tarefaService, child) {
        final tarefas = tarefaService.getTarefasPorData(_selectedDay, 'default');
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tarefas para ${_formatarData(_selectedDay)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              
              if (tarefas.isEmpty)
                _buildEmptyTarefas(cardColor, textColor)
              else
                ...tarefas.map((tarefa) => _buildTarefaItem(
                  tarefa: tarefa, 
                  cardColor: cardColor, 
                  textColor: textColor,
                  onConcluir: () => _concluirTarefa(context, tarefa.id),
                )).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTarefaItem({
    required Tarefa tarefa,
    required Color cardColor,
    required Color textColor,
    required VoidCallback onConcluir,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tarefa.titulo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                if (tarefa.descricao.isNotEmpty)
                  Text(
                    tarefa.descricao,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Text(
                  '${tarefa.data.hour.toString().padLeft(2, '0')}:${tarefa.data.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
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
    );
  }

  Widget _buildEmptyTarefas(Color cardColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_note,
            size: 48,
            color: textColor.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'Nenhuma tarefa para esta data',
            style: TextStyle(
              color: textColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toque no botão + para adicionar uma tarefa',
            style: TextStyle(
              color: textColor.withOpacity(0.4),
              fontSize: 12,
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
    _selectedColor = Colors.blue;

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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                'Nova Tarefa',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Data: ${_formatarData(_selectedDay)}',
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _tituloController,
                      decoration: InputDecoration(
                        labelText: 'Título da tarefa *',
                        labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ThemeService.primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ThemeService.primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: TextStyle(color: textColor),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descricaoController,
                      decoration: InputDecoration(
                        labelText: 'Descrição (opcional)',
                        labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ThemeService.primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ThemeService.primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: TextStyle(color: textColor),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cor da tarefa:',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _coresDisponiveis.length,
                        itemBuilder: (context, index) {
                          final cor = _coresDisponiveis[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = cor;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: cor,
                                shape: BoxShape.circle,
                                border: _selectedColor == cor
                                    ? Border.all(color: Colors.white, width: 3)
                                    : Border.all(color: Colors.grey.withOpacity(0.3)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeService.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _salvarTarefa,
                  child: const Text(
                    'Salvar Tarefa',
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

  void _salvarTarefa() {
    final titulo = _tituloController.text.trim();
    
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um título para a tarefa'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final tarefaService = Provider.of<TarefaService>(context, listen: false);
    
    final novaTarefa = Tarefa(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
      descricao: _descricaoController.text.trim(),
      data: _selectedDay,
      cor: _selectedColor,
      casaId: 'default',
      concluida: false,
    );

    tarefaService.adicionarTarefa(novaTarefa);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tarefa adicionada com sucesso!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _concluirTarefa(BuildContext context, String id) {
    final tarefaService = Provider.of<TarefaService>(context, listen: false);
    tarefaService.marcarComoConcluida(id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tarefa concluída!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _getMonthYear(DateTime date) {
    final months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatarData(DateTime date) {
    final days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    final months = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }
}