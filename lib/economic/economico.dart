import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile_tcc/usuarios.dart';
import 'historico.dart'; // Import da tela de histórico

class Economico extends StatefulWidget {
  const Economico({super.key});

  @override
  State<Economico> createState() => _EconomicoState();
}

class _EconomicoState extends State<Economico> {
  double saldo = 1800;
  double entrada = 1800;
  double saida = 1800;

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
    _opcoesDrawer.addAll({
      "HOME": Container(), // substitua por sua HomePage se desejar
      "ECONÔMICO": const Economico(),
      "HISTÓRICO": const HistoricoPage(),
      "USUÁRIOS": const Usuarios(),
      "MINHAS CASAS": Container(),
      "MEU PERFIL": Container(),
      "CONFIGURAÇÕES": Container(),
    });
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
          _drawerItem("ECONÔMICO", () => _navegarParaTela("ECONÔMICO")),
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
    String acao = 'adicionar';
    // ignore: unused_local_variable
    String categoria = 'renda';

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
                    'Alterar Valor',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text('R\$',
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text('Local:',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: localController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Informe o local do pagamento',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text('Ação:',
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
                            value: 'adicionar',
                            child: Text('Deseja adicionar?',
                                style: TextStyle(color: Colors.white))),
                        DropdownMenuItem(
                            value: 'remover',
                            child: Text('Deseja remover?',
                                style: TextStyle(color: Colors.white))),
                      ],
                      onChanged: (v) => setStateModal(() => acao = v ?? 'adicionar'),
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
                            if (valor > 0) {
                              setState(() {
                                if (acao == 'adicionar') {
                                  saldo += valor;
                                  entrada += valor;
                                } else {
                                  saldo -= valor;
                                  saida += valor;
                                }
                              });
                              Navigator.pop(context);
                              _mostrarModalConfirmacao();
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
              const Text('Enviado com sucesso',
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
    final meses = ['JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN'];
    final spots = List.generate(
      meses.length,
      (i) => FlSpot(i.toDouble(), valoresMensais[meses[i]] ?? 0),
    );

    return LineChart(
      LineChartData(
        minY: 0,
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
            belowBarData:
                BarAreaData(show: true, color: const Color(0x552E86C1)),
          ),
        ],
      ),
    );
  }

  Widget _smallInfoBox(String title, String value) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(
                color: Color(0xFF2E86C1),
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
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
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
                    Text('ENTRADA: R\$ ${entrada.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('SAÍDA: R\$ ${saida.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                  ]),
            )
          ]),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _smallInfoBox('Renda', 'R\$ 1800,00'),
            _smallInfoBox('Investimento', 'R\$ 1800,00'),
            _smallInfoBox('Gastos', 'R\$ 1800,00'),
          ]),
          const SizedBox(height: 20),
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
                              style: const TextStyle(color: Colors.white)),
                        ]),
                  );
                }).toList(),
              ),
            )
          ]),
          const SizedBox(height: 25),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoricoPage()),
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
              child: const Text('Alterar Valor',
                  style: TextStyle(color: Colors.white)),
            ),
          ]),
          const SizedBox(height: 40),
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
