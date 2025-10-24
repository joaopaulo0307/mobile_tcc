import 'package:flutter/material.dart';
import 'package:mobile_tcc/economic/economico.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  // Botão selecionado: 7, 15 ou 30 dias
  int selecionado = 7;

  // Lista simulada de despesas (exemplo)
  final Map<String, List<Map<String, String>>> historico = {
    "Hoje": [
      {"valor": "R\$ 50,00", "local": "Boa Supermercados"},
      {"valor": "R\$ 50,00", "local": "Papelaria Divina"},
    ],
    "Ontem": [
      {"valor": "R\$ 50,00", "local": "Boa Supermercados"},
      {"valor": "R\$ 50,00", "local": "Papelaria Divina"},
    ],
    "Anteontem": [
      {"valor": "R\$ 50,00", "local": "Boa Supermercados"},
    ],
    "30/09": [
      {"valor": "R\$ 50,00", "local": "Boa Supermercados"},
      {"valor": "R\$ 50,00", "local": "Papelaria Divina"},
    ],
    "29/09": [],
  };

  Widget _buildPeriodoButton(String label, int dias) {
    final bool ativo = selecionado == dias;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selecionado = dias),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: ativo ? const Color(0xFF133A67) : const Color(0xFF446B9F),
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistro(String valor, String local) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF446B9F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(valor, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(local, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSecao(String titulo, List<Map<String, String>> itens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "$titulo:",
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        ...itens.map((i) => _buildRegistro(i["valor"]!, i["local"]!)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF133A67),
        centerTitle: true,
        title: const Text("HISTÓRICO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // Botões de filtro de período
            Row(
              children: [
                _buildPeriodoButton("Últimos 7 dias", 7),
                const SizedBox(width: 6),
                _buildPeriodoButton("Últimos 15 dias", 15),
                const SizedBox(width: 6),
                _buildPeriodoButton("Últimos 30 dias", 30),
              ],
            ),

            const SizedBox(height: 20),

            // Lista de históricos por dia
            ...historico.entries.map((entry) => _buildSecao(entry.key, entry.value)).toList(),

            const SizedBox(height: 40),

            // Rodapé igual ao do app
            Container(
              width: double.infinity,
              color: const Color(0xFF133A67),
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: const [
                  Text("Organize suas tarefas de forma simples",
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.facebook, color: Colors.white),
                      SizedBox(width: 16),
                      Icon(FontAwesomeIcons.instagram, color: Colors.white),
                      const SizedBox(width: 16),
                      Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("© Todos os direitos reservados - 2025",
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
