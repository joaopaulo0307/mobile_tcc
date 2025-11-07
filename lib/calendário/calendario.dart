import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../serviços/theme_service.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  // Controladores do calendário
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  
  // Eventos do calendário (exemplo)
  final Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    _initializeCalendar();
    _loadSampleEvents();
  }

  void _initializeCalendar() {
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  void _loadSampleEvents() {
    final now = DateTime.now();
    
    // Eventos de exemplo
    _events[DateTime(now.year, now.month, now.day)] = [
      Event('Reunião familiar', Colors.blue),
      Event('Compras do mês', Colors.green),
    ];
    
    _events[DateTime(now.year, now.month, now.day + 1)] = [
      Event('Consulta médica', Colors.red),
    ];
    
    _events[DateTime(now.year, now.month, now.day + 3)] = [
      Event('Aniversário do João', Colors.orange),
      Event('Pagamento de contas', Colors.purple),
    ];
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
                // Cabeçalho com data atual
                _buildHeader(textColor),
                
                // Calendário
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildCalendar(cardColor, textColor, backgroundColor),
                        const SizedBox(height: 16),
                        _buildEventsList(cardColor, textColor),
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
        onPressed: _adicionarEvento,
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
            'Hoje: ${_formatDate(DateTime.now())}',
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
          
          // Estilização do calendário
          calendarStyle: CalendarStyle(
            defaultTextStyle: TextStyle(color: textColor),
            weekendTextStyle: TextStyle(color: textColor),
            selectedTextStyle: const TextStyle(color: Colors.white),
            todayTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            todayDecoration: BoxDecoration(
              color: ThemeService.primaryColor,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: ThemeService.secondaryColor,
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
          ),
          
          // Estilização dos cabeçalhos
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
          
          // Estilização dos dias da semana
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
          
          // Builders personalizados
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: ThemeService.secondaryColor,
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
  }

  Widget _buildEventsList(Color cardColor, Color textColor) {
    final events = _events[_selectedDay] ?? [];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Eventos para ${_formatDate(_selectedDay)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          
          if (events.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event_busy,
                    color: textColor.withOpacity(0.5),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Nenhum evento para esta data',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          else
            ...events.map((event) => _buildEventItem(event, cardColor, textColor)),
        ],
      ),
    );
  }

  Widget _buildEventItem(Event event, Color cardColor, Color textColor) {
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
              color: event.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dia inteiro',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.event,
            color: event.color,
          ),
        ],
      ),
    );
  }

  void _adicionarEvento() {
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
                'Novo Evento',
                style: TextStyle(color: textColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Adicionar evento para ${_formatDate(_selectedDay)}',
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Título do evento',
                      labelStyle: TextStyle(color: textColor),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ThemeService.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ThemeService.primaryColor),
                      ),
                    ),
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: textColor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeService.primaryColor,
                  ),
                  onPressed: () {
                    // Aqui você implementaria a lógica para salvar o evento
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Adicionar',
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

  // Métodos auxiliares
  String _getMonthYear(DateTime date) {
    final months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatDate(DateTime date) {
    final days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    final months = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    
    return '${days[date.weekday - 1]}, ${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}

// Classe para representar eventos
class Event {
  final String title;
  final Color color;
  
  Event(this.title, this.color);
}