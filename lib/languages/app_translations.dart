import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'pt_BR': {
      'bem_vindo': 'Bem-vindo!',
      'ir_para_segunda_pagina': 'Ir para Segunda Página',
      'esta_e_segunda_pagina': 'Esta é a segunda página',
      'voltar': 'Voltar',
    },
    'en_US': {
      'bem_vindo': 'Welcome!',
      'ir_para_segunda_pagina': 'Go to Second Page',
      'esta_e_segunda_pagina': 'This is the second page',
      'voltar': 'Back',
    },
    'es_ES': {
      'bem_vindo': '¡Bienvenido!',
      'ir_para_segunda_pagina': 'Ir a Segunda Página',
      'esta_e_segunda_pagina': 'Esta es la segunda página',
      'voltar': 'Volver',
    },
  };
}