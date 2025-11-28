import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tcc/services/formatting_service.dart';

void main() {
  group('FormattingService - Testes de Erro', () {
    late FormattingService formattingService;

    setUp(() {
      formattingService = FormattingService();
    });

    test('Deve lidar com valores nulos na formatação de data', () {
      expect(() {
        formattingService.formatDate(DateTime.now());
      }, returnsNormally);
    });

    test('Deve formatar valores monetários extremos', () {
      expect(formattingService.formatCurrency(0), 'R\$ 0,00');
      expect(formattingService.formatCurrency(-100), 'R\$ -100,00');
      
      expect(() => formattingService.formatCurrency(double.infinity), returnsNormally);
      expect(() => formattingService.formatCurrency(double.nan), returnsNormally);
    });

    test('Deve lidar com valores muito grandes', () {
      final largeValue = 999999999.99;
      expect(() {
        formattingService.formatCurrency(largeValue);
      }, returnsNormally);
      
    });

    test('Deve pluralizar com valores negativos', () {
      expect(formattingService.pluralize('item', 'itens', -1), 'itens');
      expect(formattingService.pluralize('item', 'itens', -5), 'itens');
    });

    test('Deve lidar com strings vazias na pluralização', () {
      expect(formattingService.pluralize('', '', 1), '');
      expect(formattingService.pluralize('', '', 2), '');
    });

    test('Deve ter todos os métodos necessários', () {
      expect(formattingService.formatDate is Function, true);
      expect(formattingService.formatCurrency is Function, true);
      expect(formattingService.pluralize is Function, true);
    });
  });
}