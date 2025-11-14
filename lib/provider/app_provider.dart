import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    // Adicione aqui todos os providers do seu app
    ChangeNotifierProvider(create: (context) => TarefaService()),
    ChangeNotifierProvider(create: (context) => ThemeService()),
    Provider(create: (context) => AuthService()),
  ];

  static T of<T>(BuildContext context, {bool listen = true}) {
    return Provider.of<T>(context, listen: listen);
  }

  static T watch<T>(BuildContext context) {
    return Provider.of<T>(context, listen: true);
  }

  static T read<T>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }
}