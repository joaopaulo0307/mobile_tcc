import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Economico extends StatefulWidget {
  const Economico({super.key});

  @override
  State<Economico> createState() => _EconomicoState();
}

class _EconomicoState extends State<Economico> {
  double saldo = 1800;
  double entrada = 1800;
  double saida = 1800;

  // Valores de gastos mensais
  Map<String, double> valoresMensais = {
    'JAN': 1800,
    'FEV': 1800,
    'MAR': 1800,
    'ABR': 1800,
    'MAI': 1800,
    'JUN': 1800,
  };

  // Atualiza valores via modal
  void _mostrarModalAlterarValor() {
    final TextEditingController valorController = TextEditingController();
    String? categoria = 'gastos';
    String? acao = 'adicionar';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: const Color(0xFF2B3E5E),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Alterar Valor',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: valorController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'R\$',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: acao,
                      dropdownColor: const Color(0xFF2B3E5E),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Ação:',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'adicionar',
                          child: Text('Adicionar'),
                        ),
                        DropdownMenuItem(
                          value: 'remover',
                          child: Text('Remover'),
                        ),
                      ],
                      onChanged: (value) => setStateModal(() => acao = value),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final valor = double.tryParse(valorController.text) ?? 0;
                        if (valor > 0) {
                          setState(() {
                            if (acao == 'adicionar') {
                              saldo += valor;
                              entrada += valor;
                              valoresMensais['JUN'] =
                                  (valoresMensais['JUN'] ?? 0) + valor;
                            } else {
                              saldo -= valor;
                              saida += valor;
                              valoresMensais['JUN'] =
                                  (valoresMensais['JUN'] ?? 0) - valor;
                            }
                          });
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: const Text('Confirmar',
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCardInfo(String titulo, String valor) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFCCCCCC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(
                color: Colors.blueAccent, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            valor,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildGrafico() {
    final List<FlSpot> spots = [];
    final meses = ['JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN'];

    for (int i = 0; i < meses.length; i++) {
      spots.add(FlSpot(i.toDouble(), valoresMensais[meses[i]] ?? 0));
    }

    return LineChart(
      LineChartData(
        backgroundColor: const Color(0xFFCCCCCC),
        titlesData: FlTitlesData(show: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: spots,
            barWidth: 3,
            color: Colors.blueAccent,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF133A67),
        title: const Text(
          'ECONÔMICO',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Card Saldo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCCCCC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text('Saldo',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      'R\$ ${saldo.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('ENTRADA:  R\$ ${entrada.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                        Text('SAÍDA:  R\$ ${saida.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Cards Renda / Investimento / Gastos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCardInfo('Renda', 'R\$ 1800,00'),
                  _buildCardInfo('Investimento', 'R\$ 1800,00'),
                  _buildCardInfo('Gastos', 'R\$ 1800,00'),
                ],
              ),
              const SizedBox(height: 20),

              // Uso Mensal (gráfico + tabela)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(height: 180, child: _buildGrafico()),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: valoresMensais.entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key,
                                  style: const TextStyle(color: Colors.white)),
                              Text('R\$ ${e.value.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF133A67),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12)),
                    child: const Text('Histórico',
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: _mostrarModalAlterarValor,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF133A67),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12)),
                    child: const Text('Alterar valor',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Rodapé
              Container(
                width: double.infinity,
                color: const Color(0xFF133A67),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: const [
                    Text(
                      'Organize suas tarefas de forma simples',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '© Todos os direitos reservados - 2025',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
