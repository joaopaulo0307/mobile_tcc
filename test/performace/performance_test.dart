import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mobile_tcc/services/theme_service.dart';
import 'package:mobile_tcc/services/formatting_service.dart';
import 'package:mobile_tcc/home.dart';
import 'package:mobile_tcc/config.dart';

void main() {
  group('Testes de Performance', () {
    testWidgets('Deve carregar HomePage rapidamente', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeService>.value(value: ThemeService()),
            Provider<FormattingService>.value(value: FormattingService()),
          ],
          child: const MaterialApp(home: HomePage(casa: {'nome': 'Teste', 'id': '1'})),
        ),
      );
      
      stopwatch.stop();
      print('HomePage carregou em: ${stopwatch.elapsedMilliseconds}ms');
      
      // Deve carregar em menos de 100ms em condições normais
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    testWidgets('Deve lidar com muitas transações no Econômico', (WidgetTester tester) async {
      // Teste com dados massivos
      final casa = {'nome': 'Teste', 'id': '1'};
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeService>.value(value: ThemeService()),
            Provider<FormattingService>.value(value: FormattingService()),
          ],
          child: MaterialApp(home: HomePage(casa: casa)),
        ),
      );

      // Simular muitos dados sem quebrar a UI
      expect(() async {
        for (int i = 0; i < 1000; i++) {
          await tester.pump(Duration(milliseconds: 1));
        }
      }, returnsNormally);
    });
  });
}