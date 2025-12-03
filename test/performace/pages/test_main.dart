
import '../pages/cadastro_test.dart' as cadastro_test;
import '../pages/calendario_test.dart' as calendario_test;
import '../pages/config_page_error_test.dart' as config_page_error_test;
import '../pages/config_page_test.dart' as config_page_test;
import '../pages/economico_test.dart' as economico_test;
import '../pages/esqueci_senha_test.dart' as esqueci_senha_test;
import '../pages/historico_test.dart' as historico_test;
import '../pages/home_page_error_test.dart' as home_page_error_test;
import '../pages/home_page_test.dart' as home_page_test;
import '../pages/lista_compras_test.dart' as lista_compras_test;
import '../pages/meu_casas_test.dart' as meu_casas_test;
import '../pages/perfil_test.dart' as perfil_test;

void main() {
  print('🚀 Iniciando todos os testes das páginas...\n');
  
  try {
    print('1. Executando testes de Cadastro...');
    cadastro_test.main();
    print('  Cadastro - Concluído\n');
  } catch (e) {
    print('  Cadastro - Erro: $e\n');
  }
  
  try {
    print('2. Executando testes de Calendário...');
    calendario_test.main();
    print('   Calendário - Concluído\n');
  } catch (e) {
    print('   Calendário - Erro: $e\n');
  }
  
  try {
    print('3. Executando testes de Config Page...');
    config_page_test.main();
    print('   ✅ Config Page - Concluído\n');
  } catch (e) {
    print('   ❌ Config Page - Erro: $e\n');
  }
  
  try {
    print('4. Executando testes de Config Page Error...');
    config_page_error_test.main();
    print('   ✅ Config Page Error - Concluído\n');
  } catch (e) {
    print('   ❌ Config Page Error - Erro: $e\n');
  }
  
  try {
    print('5. Executando testes de Econômico...');
    economico_test.main();
    print('   ✅ Econômico - Concluído\n');
  } catch (e) {
    print('   ❌ Econômico - Erro: $e\n');
  }
  
  try {
    print('6. Executando testes de Esqueci Senha...');
    esqueci_senha_test.main();
    print('   ✅ Esqueci Senha - Concluído\n');
  } catch (e) {
    print('   ❌ Esqueci Senha - Erro: $e\n');
  }
  
  try {
    print('7. Executando testes de Histórico...');
    historico_test.main();
    print('   ✅ Histórico - Concluído\n');
  } catch (e) {
    print('   ❌ Histórico - Erro: $e\n');
  }
  
  try {
    print('8. Executando testes de Home Page...');
    home_page_test.main();
    print('   ✅ Home Page - Concluído\n');
  } catch (e) {
    print('   ❌ Home Page - Erro: $e\n');
  }
  
  try {
    print('9. Executando testes de Home Page Error...');
    home_page_error_test.main();
    print('   ✅ Home Page Error - Concluído\n');
  } catch (e) {
    print('   ❌ Home Page Error - Erro: $e\n');
  }
  
  try {
    print('10. Executando testes de Lista Compras...');
    lista_compras_test.main();
    print('   ✅ Lista Compras - Concluído\n');
  } catch (e) {
    print('   ❌ Lista Compras - Erro: $e\n');
  }
  
  try {
    print('11. Executando testes de Meu Casas...');
    meu_casas_test.main();
    print('   ✅ Meu Casas - Concluído\n');
  } catch (e) {
    print('   ❌ Meu Casas - Erro: $e\n');
  }
  
  try {
    print('12. Executando testes de Perfil...');
    perfil_test.main();
    print('   ✅ Perfil - Concluído\n');
  } catch (e) {
    print('   ❌ Perfil - Erro: $e\n');
  }
  
  print('🎉 Todos os 12 testes foram executados!');
  print('📊 Resumo:');
  print('   - Total de testes de página: 12');
  print('   - Testes executados com sucesso: [contagem]');
  print('   - Testes com erro: [contagem]');
}