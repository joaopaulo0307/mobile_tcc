import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  final String nome;
  const HomePage({super.key, required this.nome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top bar
            Container(
              color: const Color(0xFF1A3B6B),
              height: 50,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Icon(Icons.menu, color: Colors.white),
            ),

            const SizedBox(height: 16),

            // Card de boas-vindas (mais largo)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF27226D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "quarta-feira, 4 de Maio",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Olá, $nome",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Linha da data e tarefas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateChip("Qua", "4"), // campo da data menor
                  const SizedBox(width: 12),

                  // Tarefas (mesma largura e alinhadas)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTaskButton("PASSEAR COM O CACHORRO"),
                        const SizedBox(height: 8),
                        _buildTaskButton("COMPRAR ARROZ"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Opções centralizadas
            const Divider(color: Colors.white54),
            const SizedBox(height: 8),
            const Text("Opções",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildOptionButton("Usuários", FontAwesomeIcons.user),
                _buildOptionButton("Econômico", FontAwesomeIcons.moneyBill),
                _buildOptionButton("Calendário", FontAwesomeIcons.calendar),
                _buildOptionButton("Minhas Casas", FontAwesomeIcons.house),
              ],
            ),

            const SizedBox(height: 40),

            // Rodapé
            Container(
              color: const Color(0xFF1A3B6B),
              padding: const EdgeInsets.symmetric(vertical: 24),
              width: double.infinity,
              child: Column(
                children: const [
                  Text("Alarma",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(
                    "Organize suas tarefas de forma simples",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.instagram, color: Colors.white),
                      SizedBox(width: 16),
                      Icon(FontAwesomeIcons.facebook, color: Colors.white),
                      SizedBox(width: 16),
                      Icon(FontAwesomeIcons.google, color: Colors.white),
                      SizedBox(width: 16),
                      Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "© Todos os direitos reservados – 2025",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Campo de data (menor)
  Widget _buildDateChip(String dia, String numero) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2C4A77),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          Text(
            dia,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF102B4E),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              numero,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Botão de tarefa (igual largura)
  Widget _buildTaskButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF466A91),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  // Botões de opções centralizados
  static Widget _buildOptionButton(String text, IconData icon) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3B6B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
