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
      valor: 0.0,
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

  Widget _buildDrawer(BuildContext context, ThemeService themeService) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        final backgroundColor = themeService.backgroundColor;
        final textColor = themeService.textColor;

        return Drawer(
          backgroundColor: backgroundColor,
          child: Column(
            children: [
              _buildDrawerHeader(themeService),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      icon: Icons.home,
                      title: languageService.translate('home'),
                      textColor: textColor,
                      onTap: () => _navigateToHome(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.history,
                      title: languageService.translate('historico'),
                      textColor: textColor,
                      onTap: () => _navigateToHistorico(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.people,
                      title: languageService.translate('usuarios'),
                      textColor: textColor,
                      onTap: () => _navigateToUsuarios(context),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.3)), // Corrigido
                    _buildDrawerItem(
                      icon: Icons.house,
                      title: languageService.translate('minhas_casas'),
                      textColor: textColor,
                      onTap: () => _navigateToMinhasCasas(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.person,
                      title: languageService.translate('meu_perfil'),
                      textColor: textColor,
                      onTap: () => _navigateToPerfil(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      title: languageService.translate('configuracoes'),
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

  Widget _buildDrawerHeader(ThemeService themeService) {
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
              'Usuário',
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

  // ------------------- MODAL: Alterar Valor -------------------
  void _mostrarModalAlterarValor() {
    final TextEditingController valorController = TextEditingController();
    final TextEditingController localController = TextEditingController();
    String acao = 'entrada';
    String categoria = 'outros';

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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      'Adicionar Transação',
                      style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    
                    // Campo Valor
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Valor (R\$):',
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
                      child: Text('Descrição:',
                          style: TextStyle(color: textColor.withOpacity(0.7), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: localController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Informe a descrição',
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
                      child: Text('Tipo:',
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
                        items: const [
                          DropdownMenuItem(
                              value: 'entrada',
                              child: Text('Entrada (Renda)',
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'saida',
                              child: Text('Saída (Gasto)',
                                  style: TextStyle(color: Colors.white))),
                        ],
                        onChanged: (v) => setState(() => acao = v ?? 'entrada'),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Seletor de Categoria
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Categoria:',
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
                        items: const [
                          DropdownMenuItem(
                              value: 'alimentacao',
                              child: Text('Alimentação',
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'transporte',
                              child: Text('Transporte',
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'lazer',
                              child: Text('Lazer',
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'saude',
                              child: Text('Saúde',
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'educacao',
                              child: Text('Educação',
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'outros',
                              child: Text('Outros',
                                  style: TextStyle(color: Colors.white))),
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
                            child: const Text('Cancelar',
                                style: TextStyle(color: Colors.white)),
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
                                _mostrarModalConfirmacao();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Preencha todos os campos corretamente'),
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
                            child: const Text('Confirmar',
                                style: TextStyle(color: Colors.white)),
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

  void _mostrarModalConfirmacao() {
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
                  Text('Transação adicionada!',
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
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text('OK', style: TextStyle(color: Colors.white)),
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

  Widget _buildGrafico() {
    final meses = ['JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ'];
    
    // Criar spots baseados nos valores mensais
    final spots = List.generate(
      meses.length,
      (i) {
        final valor = valoresMensais[meses[i]] ?? 0;
        return FlSpot(i.toDouble(), valor);
      },
    );

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: _calcularMaxY(),
        titlesData: const FlTitlesData(show: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: const Color(0xFF2E86C1),
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true, 
              color: const Color(0x552E86C1),
            ),
          ),
        ],
      ),
    );
  }

  double _calcularMaxY() {
    if (valoresMensais.isEmpty) return 2000;
    final maxValor = valoresMensais.values.reduce((a, b) => a > b ? a : b);
    return maxValor * 1.2; // Adiciona 20% de margem
  }

  Widget _smallInfoBox(String title, String value, Color color, ThemeService themeService) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(
                color: color,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          width: 110,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
              color: themeService.cardColor,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
              child: Text(value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeService.textColor,
                  )),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          backgroundColor: themeService.backgroundColor,
          drawer: _buildDrawer(context, themeService),
          appBar: AppBar(
            backgroundColor: ThemeService.primaryColor,
            centerTitle: true,
            title: const Text('ECONÔMICO',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Saldo e Valores
              Row(children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                    decoration: BoxDecoration(
                        color: themeService.cardColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Saldo', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeService.textColor,
                          )),
                          const SizedBox(height: 6),
                          Text('R\$ ${saldo.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 22,
                                  color: saldo >= 0 ? Colors.green : Colors.red)),
                          const SizedBox(height: 8),
                          Container(height: 4, width: 120, color: ThemeService.primaryColor),
                        ]),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ENTRADA: R\$ ${renda.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.green, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text('SAÍDA: R\$ ${gastos.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold)),
                      ]),
                )
              ]),
              const SizedBox(height: 20),
              
              // Renda e Gastos
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _smallInfoBox('Renda', 'R\$ ${renda.toStringAsFixed(2)}', Colors.green, themeService),
                _smallInfoBox('Gastos', 'R\$ ${gastos.toStringAsFixed(2)}', Colors.red, themeService),
              ]),
              const SizedBox(height: 20),
              
              // Gráfico e Tabela
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(flex: 2, child: SizedBox(height: 180, child: _buildGrafico())),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: valoresMensais.entries.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key, style: TextStyle(color: themeService.textColor)),
                              Text('R\$ ${e.value.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: e.value >= 0 ? Colors.green : Colors.red,
                                  )),
                            ]),
                      );
                    }).toList(),
                  ),
                )
              ]),
              const SizedBox(height: 25),
              
              // Botões
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ElevatedButton(
                  onPressed: () => _navigateToHistorico(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeService.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text('Histórico',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: _mostrarModalAlterarValor,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeService.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text('Nova Transação',
                      style: TextStyle(color: Colors.white)),
                ),
              ]),
              const SizedBox(height: 40),
              
              // Rodapé
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeService.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Column(
                  children: const [
                    Text("Organize suas tarefas de forma simples",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    SizedBox(height: 10),
                    Text("© Todos os direitos reservados - 2025",
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

// Modelo para as transações
class Transacao {
  final String id;
  final double valor;
  final String local;
  final DateTime data;
  final String tipo; // 'entrada' ou 'saida'
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