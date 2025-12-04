class Transacao {
  final String id;         // <-- NECESSÁRIO (seu código usa id)
  final double valor;
  final String local;
  final DateTime data;
  final String tipo;       // "entrada" ou "saida"
  final String? categoria; // pode ser null

  Transacao({
    required this.id,
    required this.valor,
    required this.local,
    required this.data,
    required this.tipo,
    this.categoria,
  });

  // ---------- CONVERSÃO PARA FIRESTORE (opcional mas recomendado) ----------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'valor': valor,
      'local': local,
      'data': data.toIso8601String(),
      'tipo': tipo,
      'categoria': categoria,
    };
  }

  // ---------- CRIAR OBJETO A PARTIR DO FIRESTORE ----------
  factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(
      id: json['id'],
      valor: (json['valor'] as num).toDouble(),
      local: json['local'],
      data: DateTime.parse(json['data']),
      tipo: json['tipo'],
      categoria: json['categoria'],
    );
  }
}
