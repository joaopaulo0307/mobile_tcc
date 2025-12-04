import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tcc/meu_casas.dart';
import 'package:provider/provider.dart';
import 'package:mobile_tcc/services/theme_service.dart';

/// Mock simples do ThemeService
class MockThemeService extends BaseThemeService {
  bool _isDarkMode = false;
  
  @override
  bool get isDarkMode => _isDarkMode;
  
  @override
  Color get backgroundColor => _isDarkMode ? Colors.black : Colors.white;
  
  @override
  Color get cardColor => _isDarkMode ? Colors.grey[900]! : Colors.white;
  
  @override
  Color get textColor => _isDarkMode ? Colors.white : Colors.black;
  
  @override
  Color get primaryColor => const Color(0xFF133A67);
  
  @override
  Color get secondaryColor => const Color(0xFF4CAF50);
  
  @override
  ThemeData get themeData => ThemeData.light();
  
  @override
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  @override
  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}

Widget createTestWidget(Widget child) {
  final mockThemeService = MockThemeService();
  
  return ChangeNotifierProvider<BaseThemeService>.value(
    value: mockThemeService,
    child: MaterialApp(
      theme: mockThemeService.themeData,
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  group('MeuCasas - Testes de Widget', () {
    
    testWidgets('Deve renderizar título e botão +', (tester) async {
      await tester.pumpWidget(createTestWidget(const MeuCasas()));
      
      expect(find.text('MINHAS CASAS'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

  });
}
