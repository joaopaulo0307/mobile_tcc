import 'package:flutter/material.dart';
import 'package:mobile_tcc/economic/economico.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoricoPage extends StatefulWidget {
  final List<Transacao> transacoes;
  
  const HistoricoPage({super.key, required this.transacoes});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  // Botão selecionado: 7, 15 ou 30 dias
  int selecionado = 7;

  // Agrupar transações por data
  Map<String, List<Transacao>> get _transacoesAgrupadas {
    Map<String, List<Transacao>> agrupadas = {};
    
    for (var transacao in widget.transacoes) {
      String dataKey = _formatarData(transacao.data);
      if (!agrupadas.containsKey(dataKey)) {
        agrupadas[dataKey] = [];
      }
      agrupadas[dataKey]!.add(transacao);
    }
    
    return agrupadas;
  }

  String _formatarData(DateTime data) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dataTransacao = DateTime(data.year, data.month, data.day);
    
    if (dataTransacao == today) return 'Hoje';
    if (dataTransacao == yesterday) return 'Ontem';
    
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}';
  }

  List<Transacao> get _transacoesFiltradas {
    final dias = selecionado;
    final dataLimite = DateTime.now().subtract(Duration(days: dias));
    
    return widget.transacoes.where((transacao) => 
      transacao.data.isAfter(dataLimite)
    ).toList();
  }

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

  Widget _buildRegistro(Transacao transacao) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transacao.tipo == 'entrada' ? 
                  'R\$ +${transacao.valor.toStringAsFixed(2)}' : 
                  'R\$ -${transacao.valor.toStringAsFixed(2)}',
                style: TextStyle(
                  color: transacao.tipo == 'entrada' ? Colors.green : Colors.red, 
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transacao.local,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                'Categoria: ${_formatarCategoria(transacao.categoria)}',
                style: const TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ],
          ),
          Text(
            '${transacao.data.hour.toString().padLeft(2, '0')}:${transacao.data.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _formatarCategoria(String categoria) {
    switch (categoria) {
      case 'alimentacao': return 'Alimentação';
      case 'transporte': return 'Transporte';
      case 'lazer': return 'Lazer';
      case 'saude': return 'Saúde';
      case 'educacao': return 'Educação';
      case 'outros': return 'Outros';
      default: return categoria;
    }
  }

  Widget _buildSecao(String titulo, List<Transacao> transacoes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "$titulo:",
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        ...transacoes.map((transacao) => _buildRegistro(transacao)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final transacoesAgrupadasFiltradas = <String, List<Transacao>>{};
    
    for (var transacao in _transacoesFiltradas) {
      String dataKey = _formatarData(transacao.data);
      if (!transacoesAgrupadasFiltradas.containsKey(dataKey)) {
        transacoesAgrupadasFiltradas[dataKey] = [];
      }
      transacoesAgrupadasFiltradas[dataKey]!.add(transacao);
    }

    // Ordenar por data (mais recente primeiro)
    final entries = transacoesAgrupadasFiltradas.entries.toList()
      ..sort((a, b) {
        // Ordenar por data (mais recente primeiro)
        final transacaoA = a.value.first;
        final transacaoB = b.value.first;
        return transacaoB.data.compareTo(transacaoA.data);
      });

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

            // Lista de históricos
            if (entries.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Nenhuma transação no período selecionado',
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...entries.map((entry) => _buildSecao(entry.key, entry.value)),

            const SizedBox(height: 40),

            // Rodapé
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
                      SizedBox(width: 16),
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