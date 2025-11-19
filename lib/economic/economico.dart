import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:mobile_tcc/config.dart';
import 'package:mobile_tcc/home.dart';
import 'package:mobile_tcc/perfil.dart';
import 'package:mobile_tcc/usuarios.dart';
import 'package:mobile_tcc/meu_casas.dart';
import 'historico.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';

// ✅ CLASSE Transacao ADICIONADA
class Transacao {
  final String id;
  final double valor;
  final String local;
  final DateTime data;
  final String tipo;
  final String categoria;

  Transacao({
    required this.id,
    required this.valor,
    required this.local,
    required this.data,
    required this.tipo,
    required this.categoria,
  });
}

class Economico extends StatefulWidget {
  final Map<String, String> casa;
  
  const Economico({super.key, required this.casa});

  @override
  State<Economico> createState() => _EconomicoState();
}

class _EconomicoState extends State<Economico> {
  double saldo = 0.0;
  double renda = 0.0;
  double gastos = 0.0;
  
  List<Transacao> historicoTransacoes = [
    Transacao(
      id: '1',
      valor: 2500.0, // ✅ VALOR CORRIGIDO (não pode ser 0.0)
      local: 'Salário',
      data: DateTime.now().subtract(const Duration(days: 2)),
      tipo: 'entrada',
      categoria: 'renda',
    ),
  ];

  final Map<String, double> valoresMensais = {};

  @override
  void initState() {
    super.initState();
    _atualizarValores();
    _atualizarGrafico();
  }

  void _atualizarValores() {
    double totalEntradas = 0;
    double totalSaidas = 0;
    
    for (var transacao in historicoTransacoes) {
      if (transacao.tipo == 'entrada') {
        totalEntradas += transacao.valor;
      } else {
        totalSaidas += transacao.valor;
      }
    }
    
    setState(() {
      renda = totalEntradas;
      gastos = totalSaidas;
      saldo = totalEntradas - totalSaidas;
    });
  }

  void _atualizarGrafico() {
    // Agrupar transações por mês
    Map<String, double> transacoesPorMes = {};
    
    for (var transacao in historicoTransacoes) {
      String mes = _obterMesAbreviado(transacao.data);
      if (transacoesPorMes.containsKey(mes)) {
        transacoesPorMes[mes] = transacoesPorMes[mes]! + 
          (transacao.tipo == 'entrada' ? transacao.valor : -transacao.valor);
      } else {
        transacoesPorMes[mes] = transacao.tipo == 'entrada' ? transacao.valor : -transacao.valor;
      }
    }
    
    setState(() {
      valoresMensais.clear();
      valoresMensais.addAll(transacoesPorMes);
    });
  }

  String _obterMesAbreviado(DateTime data) {
    final meses = ['JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ'];
    return meses[data.month - 1];
  }

  // ✅ MÉTODO _buildGrafico COMPLETADO
  Widget _buildGrafico() {
    final meses = ['JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ'];
    
    // Criar spots baseados nos valores mensais
    final spots = List.generate(
      meses.length,
      (i) {
        final valor = valoresMensais[meses[i]] ?? 0.0;
        return FlSpot(i.toDouble(), valor);
      },
    );

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value >= 0 && value < meses.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        meses[value.toInt()],
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: ThemeService.primaryColor,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, ThemeService themeService) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        final backgroundColor = themeService.backgroundColor;
        final textColor = themeService.textColor;

        return Drawer(
          backgroundColor: backgroundColor,
          child: Column(
            children: [
              _buildDrawerHeader(themeService, languageService), // ✅ languageService adicionado
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      icon: Icons.home,
                      title: languageService.translate('home') ?? 'Home',
                      textColor: textColor,
                      onTap: () => _navigateToHome(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.history,
                      title: languageService.translate('historico') ?? 'Histórico',
                      textColor: textColor,
                      onTap: () => _navigateToHistorico(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.people,
                      title: languageService.translate('usuarios') ?? 'Usuários',
                      textColor: textColor,
                      onTap: () => _navigateToUsuarios(context),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.3)),
                    _buildDrawerItem(
                      icon: Icons.house,
                      title: languageService.translate('minhas_casas') ?? 'Minhas Casas',
                      textColor: textColor,
                      onTap: () => _navigateToMinhasCasas(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.person,
                      title: languageService.translate('meu_perfil') ?? 'Meu Perfil',
                      textColor: textColor,
                      onTap: () => _navigateToPerfil(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      title: languageService.translate('configuracoes') ?? 'Configurações',
                      textColor: textColor,
                      onTap: () => _navigateToConfig(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ✅ CORREÇÃO: languageService adicionado como parâmetro
  Widget _buildDrawerHeader(ThemeService themeService, LanguageService languageService) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: ThemeService.primaryColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Text(
                "TD",
                style: TextStyle(
                  color: Color(0xFF133A67),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.casa['nome'] ?? 'Minha Casa',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              languageService.translate('usuario') ?? 'Usuário', // ✅ CORRIGIDO
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: ThemeService.primaryColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      onTap: onTap,
    );
  }

  // Métodos de navegação
  void _navigateToHome(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(casa: widget.casa),
      ),
    );
  }

  void _navigateToHistorico(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoricoPage(transacoes: historicoTransacoes),
      ),
    );
  }

  void _navigateToUsuarios(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Usuarios()),
    );
  }

  void _navigateToMinhasCasas(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MeuCasas()),
      (route) => false,
    );
  }

  void _navigateToPerfil(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerfilPage()),
    );
  }

  void _navigateToConfig(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfigPage()),
    );
  }

  // ✅ MÉTODO build ADICIONADO (estava faltando)
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeService, LanguageService>(
      builder: (context, themeService, languageService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(languageService.translate('economico') ?? 'Econômico'),
            backgroundColor: ThemeService.primaryColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _mostrarModalAlterarValor,
              ),
            ],
          ),
          drawer: _buildDrawer(context, themeService),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cards de Resumo
                _buildResumoCards(languageService),
                const SizedBox(height: 24),
                
                // Gráfico
                _buildGraficoSection(languageService),
                const SizedBox(height: 24),
                
                // Histórico Recente
                _buildHistoricoRecente(languageService),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResumoCards(LanguageService languageService) {
    return Row(
      children: [
        Expanded(
          child: _buildResumoCard(
            title: languageService.translate('saldo') ?? 'Saldo',
            valor: saldo,
            cor: saldo >= 0 ? Colors.green : Colors.red,
            icon: Icons.account_balance_wallet,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildResumoCard(
            title: languageService.translate('receitas') ?? 'Receitas',
            valor: renda,
            cor: Colors.green,
            icon: Icons.arrow_upward,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildResumoCard(
            title: languageService.translate('despesas') ?? 'Despesas',
            valor: gastos,
            cor: Colors.red,
            icon: Icons.arrow_downward,
          ),
        ),
      ],
    );
  }

  Widget _buildResumoCard({
    required String title,
    required double valor,
    required Color cor,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: cor, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'R\$${valor.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraficoSection(LanguageService languageService) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageService.translate('resumo_mensal') ?? 'Resumo Mensal',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildGrafico(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricoRecente(LanguageService languageService) {
    final transacoesRecentes = historicoTransacoes.take(5).toList();
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  languageService.translate('historico_recente') ?? 'Histórico Recente',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _navigateToHistorico(context),
                  child: Text(languageService.translate('ver_tudo') ?? 'Ver tudo'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...transacoesRecentes.map((transacao) => _buildItemHistorico(transacao)),
          ],
        ),
      ),
    );
  }

  Widget _buildItemHistorico(Transacao transacao) {
    return ListTile(
      leading: Icon(
        transacao.tipo == 'entrada' ? Icons.arrow_upward : Icons.arrow_downward,
        color: transacao.tipo == 'entrada' ? Colors.green : Colors.red,
      ),
      title: Text(transacao.local),
      subtitle: Text('${transacao.data.day}/${transacao.data.month}/${transacao.data.year}'),
      trailing: Text(
        'R\$${transacao.valor.toStringAsFixed(2)}',
        style: TextStyle(
          color: transacao.tipo == 'entrada' ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ------------------- MODAL: Alterar Valor -------------------
  void _mostrarModalAlterarValor() {
    final TextEditingController valorController = TextEditingController();
    final TextEditingController localController = TextEditingController();
    String acao = 'entrada';
    String categoria = 'outros';

    showDialog(
      context: context,
      builder: (context) {
        return Consumer2<ThemeService, LanguageService>(
          builder: (context, themeService, languageService, child) {
            final cardColor = themeService.cardColor;
            final textColor = themeService.textColor;
            
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: cardColor,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      languageService.translate('adicionar_transacao') ?? 'Adicionar Transação',
                      style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    
                    // Campo Valor
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${languageService.translate('valor') ?? 'Valor'} (R\$):',
                          style: TextStyle(color: textColor.withOpacity(0.7), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: valorController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: '0,00',
                        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                        filled: true,
                        fillColor: themeService.backgroundColor.withOpacity(0.8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Campo Local
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${languageService.translate('descricao') ?? 'Descrição'}:',
                          style: TextStyle(color: textColor.withOpacity(0.7), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: localController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: languageService.translate('informe_descricao') ?? 'Informe a descrição',
                        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                        filled: true,
                        fillColor: themeService.backgroundColor.withOpacity(0.8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Seletor de Ação
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${languageService.translate('tipo') ?? 'Tipo'}:',
                          style: TextStyle(color: textColor.withOpacity(0.7), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: themeService.backgroundColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8)),
                      child: DropdownButton<String>(
                        value: acao,
                        dropdownColor: cardColor,
                        underline: const SizedBox(),
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                              value: 'entrada',
                              child: Text('${languageService.translate('entrada') ?? 'Entrada'} (${languageService.translate('renda') ?? 'Renda'})',
                                  style: TextStyle(color: textColor))),
                          DropdownMenuItem(
                              value: 'saida',
                              child: Text('${languageService.translate('saida') ?? 'Saída'} (${languageService.translate('gasto') ?? 'Gasto'})',
                                  style: TextStyle(color: textColor))),
                        ],
                        onChanged: (v) => setState(() => acao = v ?? 'entrada'),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Seletor de Categoria
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${languageService.translate('categoria') ?? 'Categoria'}:',
                          style: TextStyle(color: textColor.withOpacity(0.7), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: themeService.backgroundColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8)),
                      child: DropdownButton<String>(
                        value: categoria,
                        dropdownColor: cardColor,
                        underline: const SizedBox(),
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                              value: 'alimentacao',
                              child: Text(languageService.translate('alimentacao') ?? 'Alimentação',
                                  style: TextStyle(color: textColor))),
                          DropdownMenuItem(
                              value: 'transporte',
                              child: Text(languageService.translate('transporte') ?? 'Transporte',
                                  style: TextStyle(color: textColor))),
                          DropdownMenuItem(
                              value: 'lazer',
                              child: Text(languageService.translate('lazer') ?? 'Lazer',
                                  style: TextStyle(color: textColor))),
                          DropdownMenuItem(
                              value: 'saude',
                              child: Text(languageService.translate('saude') ?? 'Saúde',
                                  style: TextStyle(color: textColor))),
                          DropdownMenuItem(
                              value: 'educacao',
                              child: Text(languageService.translate('educacao') ?? 'Educação',
                                  style: TextStyle(color: textColor))),
                          DropdownMenuItem(
                              value: 'outros',
                              child: Text(languageService.translate('outros') ?? 'Outros',
                                  style: TextStyle(color: textColor))),
                        ],
                        onChanged: (v) => setState(() => categoria = v ?? 'outros'),
                      ),
                    ),
                    
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(languageService.translate('cancelar') ?? 'Cancelar',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final valor = double.tryParse(
                                      valorController.text.replaceAll(',', '.')) ??
                                  0;
                              final descricao = localController.text.trim();
                              
                              if (valor > 0 && descricao.isNotEmpty) {
                                // Adicionar nova transação
                                final novaTransacao = Transacao(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  valor: valor,
                                  local: descricao,
                                  data: DateTime.now(),
                                  tipo: acao,
                                  categoria: categoria,
                                );
                                
                                setState(() {
                                  historicoTransacoes.insert(0, novaTransacao);
                                  _atualizarValores();
                                  _atualizarGrafico();
                                });
                                
                                Navigator.pop(context);
                                _mostrarModalConfirmacao(languageService);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(languageService.translate('preencha_campos') ?? 'Preencha todos os campos corretamente'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(languageService.translate('confirmar') ?? 'Confirmar',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _mostrarModalConfirmacao(LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<ThemeService>(
          builder: (context, themeService, child) {
            final cardColor = themeService.cardColor;
            final textColor = themeService.textColor;
            
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: cardColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 22),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 60),
                  const SizedBox(height: 12),
                  Text(languageService.translate('transacao_adicionada') ?? 'Transação adicionada!',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeService.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(languageService.translate('ok') ?? 'OK', style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ]),
              ),
            );
          },
        );
      },
    );
  }
}