import 'package:flutter/material.dart';


class Historico extends StatefulWidget {
  const Historico({super.key});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  String periodoSelecionado = '7 dias';

  // Dados de exemplo do histórico
  final List<Map<String, dynamic>> historicoTransacoes = [
    {
      'data': 'Hoje',
      'transacoes': [
        {'valor': 'RS: 50,00', 'descricao': 'Res Supermercades'},
        {'valor': 'RS: 50,00', 'descricao': 'Propelas a Divina'},
      ]
    },
    {
      'data': 'Ortean',
      'transacoes': [
        {'valor': 'RS: 50,00', 'descricao': 'Res Supermercades'},
        {'valor': 'RS: 50,00', 'descricao': 'Propelas a Divina'},
      ]
    },
    {
      'data': 'Antoentem',
      'transacoes': [
        {'valor': 'RS: 50,00', 'descricao': 'Res Supermercades'},
      ]
    },
    {
      'data': '30/02',
      'transacoes': [
        {'valor': 'RS: 50,00', 'descricao': 'Res Supermercades'},
        {'valor': 'RS: 50,00', 'descricao': 'Propelas a Divina'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3B6B),
        title: const Text(
          'HISTÓRICO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filtros de período
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPeriodoFilter('Últimos 7 dias'),
                  _buildPeriodoFilter('Últimos 15 dias'),
                  _buildPeriodoFilter('Últimos 30 dias'),
                ],
              ),
              
              const SizedBox(height: 20),
              const Divider(color: Colors.white54),
              const SizedBox(height: 20),

              // Lista de transações
              ...historicoTransacoes.map((grupo) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Data
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        '${grupo['data']}:',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    // Transações
                    ...(grupo['transacoes'] as List).map((transacao) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8, left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transacao['valor'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              transacao['descricao'],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      );
                    }).toList(),
                    
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),

              const SizedBox(height: 20),
              const Divider(color: Colors.white54),
              const SizedBox(height: 20),

              // Rodapé
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Column(
                  children: [
                    Text(
                      'Órgansos suas tarefas de forma simples',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Todos os direitos reservados - 2025',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodoFilter(String periodo) {
    bool isSelected = periodoSelecionado == periodo;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          periodoSelecionado = periodo;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A3B6B) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF1A3B6B) : Colors.white54,
          ),
        ),
        child: Text(
          periodo,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}