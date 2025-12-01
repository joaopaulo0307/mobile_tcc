// test/services/tarefa_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tcc/services/tarefa_service.dart';
import 'package:flutter/material.dart';

void main() {
  group('TarefaService - Testes de Sucesso', () {
    late TarefaService tarefaService;

    setUp(() {
      tarefaService = TarefaService();
    });

    test('Deve adicionar tarefa corretamente', () {
      final tarefa = Tarefa(
        id: '1',
        titulo: 'Tarefa Teste',
        descricao: 'Descrição teste',
        data: DateTime.now(),
        cor: Colors.blue,
        casaId: 'casa1',
      );

      expect(tarefaService.tarefas.length, 0);
      
      tarefaService.adicionarTarefa(tarefa);
      
      expect(tarefaService.tarefas.length, 1);
      expect(tarefaService.tarefas[0].titulo, 'Tarefa Teste');
    });

    test('Deve filtrar tarefas por casa', () {
      // Adiciona tarefas para diferentes casas
      tarefaService.adicionarTarefa(Tarefa(
        id: '1',
        titulo: 'Tarefa Casa 1',
        descricao: 'Desc',
        data: DateTime.now(),
        cor: Colors.blue,
        casaId: 'casa1',
      ));

      tarefaService.adicionarTarefa(Tarefa(
        id: '2',
        titulo: 'Tarefa Casa 2',
        descricao: 'Desc',
        data: DateTime.now(),
        cor: Colors.red,
        casaId: 'casa2',
      ));

      final tarefasCasa1 = tarefaService.getTarefasPorCasa('casa1');
      expect(tarefasCasa1.length, 1);
      expect(tarefasCasa1[0].titulo, 'Tarefa Casa 1');
    });

    test('Deve filtrar tarefas pendentes por casa', () {
      tarefaService.adicionarTarefa(Tarefa(
        id: '1',
        titulo: 'Pendente',
        descricao: 'Desc',
        data: DateTime.now(),
        cor: Colors.blue,
        casaId: 'casa1',
        concluida: false,
      ));

      tarefaService.adicionarTarefa(Tarefa(
        id: '2',
        titulo: 'Concluída',
        descricao: 'Desc',
        data: DateTime.now(),
        cor: Colors.red,
        casaId: 'casa1',
        concluida: true,
      ));

      final pendentes = tarefaService.getTarefasPendentesPorCasa('casa1');
      expect(pendentes.length, 1);
      expect(pendentes[0].titulo, 'Pendente');
    });

    test('Deve filtrar tarefas por data', () {
      final dataEspecifica = DateTime(2024, 1, 15);
      
      tarefaService.adicionarTarefa(Tarefa(
        id: '1',
        titulo: 'Tarefa Data',
        descricao: 'Desc',
        data: dataEspecifica,
        cor: Colors.blue,
        casaId: 'casa1',
      ));

      tarefaService.adicionarTarefa(Tarefa(
        id: '2',
        titulo: 'Outra Data',
        descricao: 'Desc',
        data: DateTime(2024, 1, 16),
        cor: Colors.red,
        casaId: 'casa1',
      ));

      final tarefasData = tarefaService.getTarefasPorData(dataEspecifica, 'casa1');
      expect(tarefasData.length, 1);
      expect(tarefasData[0].titulo, 'Tarefa Data');
    });

    test('Deve marcar tarefa como concluída', () {
      final tarefa = Tarefa(
        id: '1',
        titulo: 'Tarefa',
        descricao: 'Desc',
        data: DateTime.now(),
        cor: Colors.blue,
        casaId: 'casa1',
        concluida: false,
      );

      tarefaService.adicionarTarefa(tarefa);
      expect(tarefaService.tarefas[0].concluida, false);
      
      tarefaService.marcarComoConcluida('1');
      expect(tarefaService.tarefas[0].concluida, true);
    });

    test('Deve remover tarefa corretamente', () {
      final tarefa = Tarefa(
        id: '1',
        titulo: 'Tarefa para Remover',
        descricao: 'Desc',
        data: DateTime.now(),
        cor: Colors.blue,
        casaId: 'casa1',
      );

      tarefaService.adicionarTarefa(tarefa);
      expect(tarefaService.tarefas.length, 1);
      
      tarefaService.removerTarefa('1');
      expect(tarefaService.tarefas.length, 0);
    });
  });

  group('TarefaService - Testes de Falha/Erro', () {
    late TarefaService tarefaService;

    setUp(() {
      tarefaService = TarefaService();
    });

    test('Não deve quebrar ao remover tarefa inexistente', () {
      expect(() => tarefaService.removerTarefa('inexistente'), returnsNormally);
      expect(tarefaService.tarefas.length, 0);
    });

    test('Não deve quebrar ao marcar tarefa inexistente como concluída', () {
      expect(() => tarefaService.marcarComoConcluida('inexistente'), returnsNormally);
    });

    test('Deve retornar lista vazia para casa sem tarefas', () {
      final tarefas = tarefaService.getTarefasPorCasa('casa-inexistente');
      expect(tarefas, isEmpty);
    });

    test('Deve retornar lista vazia para data sem tarefas', () {
      final tarefas = tarefaService.getTarefasPorData(DateTime.now(), 'casa1');
      expect(tarefas, isEmpty);
    });
  });

  group('Model Tarefa - Testes', () {
    test('Deve serializar e desserializar corretamente', () {
      final tarefaOriginal = Tarefa(
        id: '123',
        titulo: 'Título Teste',
        descricao: 'Descrição Teste',
        data: DateTime(2024, 1, 15, 10, 30),
        cor: Colors.blue,
        casaId: 'casa1',
        concluida: true,
      );

      final mapa = tarefaOriginal.toMap();
      final tarefaDesserializada = Tarefa.fromMap(mapa);

      expect(tarefaDesserializada.id, '123');
      expect(tarefaDesserializada.titulo, 'Título Teste');
      expect(tarefaDesserializada.descricao, 'Descrição Teste');
      expect(tarefaDesserializada.data, DateTime(2024, 1, 15, 10, 30));
      expect(tarefaDesserializada.cor, Colors.blue);
      expect(tarefaDesserializada.casaId, 'casa1');
      expect(tarefaDesserializada.concluida, true);
    });
  });
}