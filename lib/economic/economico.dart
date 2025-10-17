import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Economico extends StatefulWidget {
  const Economico({super.key});

  @override
  State<Economico> createState() => _EconomicoPageState();
}

class _EconomicoPageState extends State<Economico> {
  double saldo = 1800.00;
  double entrada = 1800.00;
  double saida = 1800.00;

  final List<Map<String, dynamic>> monthlyUsage = [
    {'month': 'JAN', 'value': 1800.00},
    {'month': 'FEV', 'value': 1800.00},
    {'month': 'MAR', 'value': 1800.00},
    {'month': 'ABR', 'value': 1800.00},
    {'month': 'MAI', 'value': 1800.00},
    {'month': 'JUN', 'value': 1800.00},
  ];

  void _mostrarModal(BuildContext context) {
    String? categoriaSelecionada = 'renda';
    String? acaoSelecionada = 'adicionar';
    final TextEditingController valorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: const Color(0xFF2B3E5E),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Alterar Valor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
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
                        value: acaoSelecionada,
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
                            child: Text('Deseja adicionar?'),
                          ),
                          DropdownMenuItem(
                            value: 'remover',
                            child: Text('Deseja remover?'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            acaoSelecionada = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Renda', style: TextStyle(color: Colors.white)),
                            value: 'renda',
                            groupValue: categoriaSelecionada,
                            onChanged: (value) {
                              setState(() {
                                categoriaSelecionada = value;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Gastos', style: TextStyle(color: Colors.white)),
                            value: 'gastos',
                            groupValue: categoriaSelecionada,
                            onChanged: (value) {
                              setState(() {
                                categoriaSelecionada = value;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Investimento', style: TextStyle(color: Colors.white)),
                            value: 'investimento',
                            groupValue: categoriaSelecionada,
                            onChanged: (value) {
                              setState(() {
                                categoriaSelecionada = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final valor = double.tryParse(valorController.text) ?? 0.0;
                              if (valor > 0) {
                                setState(() {
                                  if (acaoSelecionada == 'adicionar') {
                                    saldo += valor;
                                    entrada += valor;
                                  } else {
                                    saldo -= valor;
                                    saida += valor;
                                  }
                                });
                              }
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF184B8A),
        centerTitle: true,
        title: const Text(
          'ECONÔMICO',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Saldo Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text('Saldo', style: TextStyle(fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 5),
                  Text(
                    'R\$$saldo',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Entrada/Saída
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ENTRADA: R\$$entrada', 
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  Text('SAÍDA: R\$$saida', 
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Categorias
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoriaCard('Renda', 'R\$ 1800,00', Colors.green),
                _buildCategoriaCard('Investimento', 'R\$ 1800,00', Colors.blue),
                _buildCategoriaCard('Gastos', 'R\$ 1800,00', Colors.orange),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Uso Mensal
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Uso Mensal', 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Valor Gasto
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Valor Gasto', 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('JAN   R\$ 1800,00', style: TextStyle(color: Colors.white)),
                  Text('FEV   R\$ 1800,00', style: TextStyle(color: Colors.white)),
                  Text('MAR   R\$ 1800,00', style: TextStyle(color: Colors.white)),
                  Text('ABR   R\$ 1800,00', style: TextStyle(color: Colors.white)),
                  Text('MAI   R\$ 1800,00', style: TextStyle(color: Colors.white)),
                  Text('JUN   R\$ 1800,00', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Botões
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBotao('Histórico', Colors.blue, () {}),
                _buildBotao('Alterar Valor', Colors.blue, () => _mostrarModal(context)),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Rodapé
            _buildRodape(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriaCard(String titulo, String valor, Color color) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(titulo, 
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 5),
          Text(valor, 
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBotao(String texto, Color cor, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: cor,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(texto, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildRodape() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF184B8A),
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Icon(Icons.account_circle, color: Colors.white, size: 40),
          const SizedBox(height: 10),
          const Text(
            'Organize suas tarefas de forma simples',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(FontAwesomeIcons.instagram, color: Colors.white),
              SizedBox(width: 15),
              Icon(FontAwesomeIcons.facebook, color: Colors.white),
              SizedBox(width: 15),
              Icon(FontAwesomeIcons.google, color: Colors.white),
              SizedBox(width: 15),
              Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            '© Todos os direitos reservados - 2025',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}