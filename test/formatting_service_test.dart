import 'package:flutter_test/flutter/test.dart';
import 'package:mobile_tcc/services/formatting_service.dart';

void main() {
  group('FormattingService', () {
    late FormattingService formattingService;

    setUp(() {
      formattingService = FormattingService();
    });

    test('Deve formatar data corretamente', () {
      final date = DateTime(2024, 1, 15);
      final formatted = formattingService.formatDate(date);
      expect(formatted, '15/01/2024');
    });

    test('Deve formatar moeda corretamente', () {
      final value = 1500.50;
      final formatted = formattingService.formatCurrency(value);
      expect(formatted, 'R\$ 1.500,50');
    });

    test('Deve formatar moeda compacta corretamente', () {
      final value = 1500.0;
      final formatted = formattingService.formatCompactCurrency(value);
      expect(formatted, 'R\$ 1,5K');
    });

    test('Deve pluralizar corretamente', () {
      expect(formattingService.pluralize('item', 'itens', 1), 'item');
      expect(formattingService.pluralize('item', 'itens', 2), 'itens');
      expect(formattingService.pluralize('item', 'itens', 0), 'itens');
    });
  });
}