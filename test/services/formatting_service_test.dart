import 'package:flutter_test/flutter_test.dart';
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
  });
}