import 'package:flutter/material.dart';

class Tarefa {
  final String id;
  final String titulo;
  final String descricao;
  final DateTime data;
  final Color cor;
  final bool concluida;
  final String casaId;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.cor,
    this.concluida = false,
    required this.casaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data': data.millisecondsSinceEpoch,
      'cor': cor.value,
      'concluida': concluida,
      'casaId': casaId,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      data: DateTime.fromMillisecondsSinceEpoch(map['data']),
      cor: Color(map['cor']),
      concluida: map['concluida'],
      casaId: map['casaId'],
    );
  }
}

class TarefaService extends ChangeNotifier {
  final List<Tarefa> _tarefas = [];

  List<Tarefa> get tarefas => _tarefas;

  List<Tarefa> getTarefasPorCasa(String casaId) {
    return _tarefas.where((tarefa) => tarefa.casaId == casaId).toList();
  }

  List<Tarefa> getTarefasPendentesPorCasa(String casaId) {
    return _tarefas
        .where((tarefa) => tarefa.casaId == casaId && !tarefa.concluida)
        .toList();
  }

  List<Tarefa> getTarefasPorData(DateTime data, String casaId) {
    return _tarefas.where((tarefa) {
      return tarefa.casaId == casaId &&
          tarefa.data.year == data.year &&
          tarefa.data.month == data.month &&
          tarefa.data.day == data.day &&
          !tarefa.concluida;
    }).toList();
  }

  void adicionarTarefa(Tarefa tarefa) {
    _tarefas.add(tarefa);
    notifyListeners();
  }

  void removerTarefa(String id) {
    _tarefas.removeWhere((tarefa) => tarefa.id == id);
    notifyListeners();
  }

  void marcarComoConcluida(String id) {
    final index = _tarefas.indexWhere((tarefa) => tarefa.id == id);
    if (index != -1) {
      _tarefas[index] = Tarefa(
        id: _tarefas[index].id,
        titulo: _tarefas[index].titulo,
        descricao: _tarefas[index].descricao,
        data: _tarefas[index].data,
        cor: _tarefas[index].cor,
        concluida: true,
        casaId: _tarefas[index].casaId,
      );
      notifyListeners();
    }
  }
}