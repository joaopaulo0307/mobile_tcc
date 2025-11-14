import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile_tcc/config.dart';
import 'package:mobile_tcc/home.dart';
import 'package:mobile_tcc/perfil.dart';
import 'package:mobile_tcc/usuarios.dart';
import 'package:mobile_tcc/meu_casas.dart';
import 'historico.dart';
import '../serviços/language_service.dart';

class Economico extends StatefulWidget {
  const Economico({super.key});

  @override
  State<Economico> createState() => _EconomicoState();
}

class _EconomicoState extends State<Economico> {
  double saldo = 1800.0;
  double renda = 1800.0;
  double gastos = 0.0;
  
  List<Transacao> historicoTransacoes = [
    Transacao(
      id: '1',
      valor: 1800.0,
      local: 'Salário',
      data: DateTime.now().subtract(const Duration(days: 2)),
      tipo: 'entrada',
      categoria: 'renda',
    ),
  ];

  final Map<String, double> valoresMensais = {
    'JAN': 1800,
    'FEV': 1800,
    'MAR': 1800,
    'ABR': 1800,
    'MAI': 1800,
    'JUN': 1800,
  };

  // Drawer navigation options
  final Map<String, Widget> _opcoesDrawer = {};

  @override
  void initState() {
    super.initState();
    _atualizarValores();
    _opcoesDrawer.addAll({
      "HOME": const HomePage(),
      "HISTÓRICO": HistoricoPage(transacoes: historicoTransacoes),
      "USUÁRIOS": const Usuarios(),
      "MINHAS CASAS": const MeuCasas(),
      "MEU PERFIL": const PerfilPage(),
      "CONFIGURAÇÕES": const ConfigPage(),
    });
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

  void _navegarParaTela(String titulo) {
    if (_opcoesDrawer.containsKey(titulo)) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _opcoesDrawer[titulo]!),
      );
    }
  }

  Widget _drawerItem(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 35, 35, 35),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          dense: true,
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 60, 60, 60),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.white54, thickness: 1, indent: 25, endIndent: 25),
          _drawerItem("HOME", () => _navegarParaTela("HOME")),
          _drawerItem("HISTÓRICO", () => _navegarParaTela("HISTÓRICO")),
          _drawerItem("USUÁRIOS", () => _navegarParaTela("USUÁRIOS")),
          const Divider(color: Colors.white54, thickness: 1, indent: 25, endIndent: 25),
          _drawerItem("MINHAS CASAS", () => _navegarParaTela("MINHAS CASAS")),
          _drawerItem("MEU PERFIL", () => _navegarParaTela("MEU PERFIL")),
          _drawerItem("CONFIGURAÇÕES", () => _navegarParaTela("CONFIGURAÇÕES")),
        ],
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
        return StatefulBuilder(builder: (context, setStateModal) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: const Color(0xFF133A67),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text(
                    'Adicionar Transação',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  
                  // Campo Valor
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text('Valor (R\$):',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: valorController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: '0,00',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Campo Local
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text('Descrição:',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: localController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Informe a descrição',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Seletor de Ação
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text('Tipo:',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButton<String>(
                      value: acao,
                      dropdownColor: const Color(0xFF133A67),
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
                      onChanged: (v) => setStateModal(() => acao = v ?? 'entrada'),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Seletor de Categoria
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text('Categoria:',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButton<String>(
                      value: categoria,
                      dropdownColor: const Color(0xFF133A67),
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
                      onChanged: (v) => setStateModal(() => categoria = v ?? 'outros'),
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
        });
      },
    );
  }

  void _mostrarModalConfirmacao() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white.withOpacity(0.06),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 22),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 12),
              const Text('Transação adicionada!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF133A67),
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
        titlesData: FlTitlesData(show: false),
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

  Widget _smallInfoBox(String title, String value, Color color) {
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
              color: const Color(0xFFCCCCCC),
              borderRadius: BorderRadius.circular(12)),
          child: Center(
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF133A67),
        centerTitle: true,
        title: const Text('ECONÔMICO',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                decoration: BoxDecoration(
                    color: const Color(0xFFCCCCCC),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Saldo',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('R\$ ${saldo.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 22,
                              color: saldo >= 0 ? Colors.green : Colors.red)),
                      const SizedBox(height: 8),
                      Container(height: 4, width: 120, color: const Color(0xFF133A67)),
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
            _smallInfoBox('Renda', 'R\$ ${renda.toStringAsFixed(2)}', Colors.green),
            _smallInfoBox('Gastos', 'R\$ ${gastos.toStringAsFixed(2)}', Colors.red),
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
                          Text(e.key, style: const TextStyle(color: Colors.white)),
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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoricoPage(transacoes: historicoTransacoes),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF133A67),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: const Text('Histórico',
                  style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: _mostrarModalAlterarValor,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF133A67),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
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
              color: const Color(0xFF133A67),
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