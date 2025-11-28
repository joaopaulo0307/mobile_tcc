// test/services/user_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_tcc/services/user_service.dart';

void main() {
  group('UserService - Testes de Sucesso', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await UserService.initialize();
    });

    test('Deve inicializar com dados padrão', () {
      expect(UserService.isInitialized, true);
      expect(UserService.userName, isNotEmpty);
      expect(UserService.userEmail, isNotEmpty);
      expect(UserService.tarefasRealizadas, isNotEmpty);
    });

    test('Deve atualizar dados do usuário', () async {
      await UserService.setUserData('novo@email.com', 'Novo Nome');
      
      expect(UserService.userEmail, 'novo@email.com');
      expect(UserService.userName, 'Novo Nome');
    });

    test('Deve adicionar tarefa realizada', () async {
      final tarefa = 'Nova Tarefa Realizada';
      final tarefasAntes = UserService.tarefasRealizadas.length;
      
      await UserService.adicionarTarefaRealizada(tarefa);
      
      expect(UserService.tarefasRealizadas.length, tarefasAntes + 1);
      expect(UserService.contemTarefa(tarefa), true);
    });

    test('Deve remover tarefa realizada', () async {
      const tarefa = 'Tarefa para Remover';
      await UserService.adicionarTarefaRealizada(tarefa);
      expect(UserService.contemTarefa(tarefa), true);
      
      await UserService.removerTarefaRealizada(tarefa);
      expect(UserService.contemTarefa(tarefa), false);
    });

    test('Deve limpar todas as tarefas', () async {
      await UserService.limparTarefasRealizadas();
      expect(UserService.tarefasRealizadas, isEmpty);
    });

    test('Deve retornar dados do usuário em mapa', () {
      final userData = UserService.getUserData();
      
      expect(userData['email'], isNotEmpty);
      expect(userData['nome'], isNotEmpty);
      expect(userData['tarefasRealizadas'], isList);
      expect(userData['quantidadeTarefas'], isNonNegative);
    });

    test('Deve atualizar apenas o nome', () async {
      await UserService.updateUserName('Nome Atualizado');
      expect(UserService.userName, 'Nome Atualizado');
    });

    test('Deve atualizar apenas o email', () async {
      await UserService.updateUserEmail('email@atualizado.com');
      expect(UserService.userEmail, 'email@atualizado.com');
    });
  });

  group('UserService - Testes de Falha/Erro', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await UserService.initialize();
    });

    test('Deve lidar com remoção de tarefa inexistente', () async {
      await UserService.removerTarefaRealizada('tarefa_inexistente');
      // Não deve lançar exceção
      expect(UserService.tarefasRealizadas, isNotNull);
    });

    test('Deve retornar falso para tarefa não existente', () {
      expect(UserService.contemTarefa('tarefa_que_nao_existe'), false);
    });

    test('Deve reinicializar com dados padrão após clear', () async {
      await UserService.clearUserData();
      
      expect(UserService.isDefaultUser, true);
      expect(UserService.tarefasRealizadas, isNotEmpty);
    });

    test('Deve manter funcionamento com SharedPreferences vazio', () async {
      SharedPreferences.setMockInitialValues({});
      await UserService.initialize();
      
      expect(UserService.isInitialized, true);
      expect(UserService.tarefasRealizadas, isNotEmpty);
    });
  });

  group('UserService - Testes de Integração', () {
    test('Deve manter consistência entre múltiplas operações', () async {
      SharedPreferences.setMockInitialValues({});
      await UserService.initialize();

      // Adiciona várias tarefas
      await UserService.adicionarTarefaRealizada('Tarefa 1');
      await UserService.adicionarTarefaRealizada('Tarefa 2');
      
      expect(UserService.quantidadeTarefasRealizadas, greaterThan(1));
      expect(UserService.contemTarefa('Tarefa 1'), true);
      expect(UserService.contemTarefa('Tarefa 2'), true);

      // Remove uma tarefa
      await UserService.removerTarefaRealizada('Tarefa 1');
      expect(UserService.contemTarefa('Tarefa 1'), false);
      expect(UserService.contemTarefa('Tarefa 2'), true);
    });
  });
}