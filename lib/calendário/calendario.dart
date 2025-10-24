import 'package:flutter/material.dart';
import 'package:mobile_tcc/home.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  int selectedDayIndex = 3; // Dia selecionado (quarta-feira)
  final List<String> days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
  final List<int> dates = [18, 19, 20, 21, 22, 23, 24];

  // Estrutura: { 21: [ {name, description, done}, {...} ] }
  final Map<int, List<Map<String, dynamic>>> tasksByDay = {};

  void _openAddTaskDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF133C74),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E83AE),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        final day = dates[selectedDayIndex];
                        setState(() {
                          tasksByDay.putIfAbsent(day, () => []);
                          tasksByDay[day]!.add({
                            'name': nameController.text,
                            'description': descriptionController.text,
                            'done': false,
                          });
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'Criar',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  bool _hasIncompleteTasks(int day) {
    final dayTasks = tasksByDay[day];
    if (dayTasks == null || dayTasks.isEmpty) return false;
    return dayTasks.any((task) => task['done'] == false);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = dates[selectedDayIndex];
    final currentTasks = tasksByDay[selectedDay] ?? [];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              const Text(
                'Calendário',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(days.length, (index) {
                  final bool isSelected = index == selectedDayIndex;
                  final int dayNumber = dates[index];
                  final bool hasIncomplete = _hasIncompleteTasks(dayNumber);

                  Color circleColor;
                  if (isSelected) {
                    circleColor = const Color(0xFF5E83AE); // azul selecionado
                  } else if (hasIncomplete) {
                    circleColor = Colors.red; // vermelho se houver pendências
                  } else {
                    circleColor = Colors.transparent;
                  }

                  return GestureDetector(
                    onTap: () => setState(() => selectedDayIndex = index),
                    child: Column(
                      children: [
                        Text(
                          days[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: circleColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white24,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              dayNumber.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: currentTasks.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma tarefa adicionada',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: currentTasks.length,
                        itemBuilder: (context, index) {
                          final task = currentTasks[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5E83AE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    task['done'] = !(task['done'] as bool);
                                  });
                                },
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: task['done']
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              title: Text(
                                task['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: task['done']
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(
                                task['description'] ?? '',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing:
                                  const Icon(Icons.edit, color: Colors.white),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5E83AE),
        onPressed: _openAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
