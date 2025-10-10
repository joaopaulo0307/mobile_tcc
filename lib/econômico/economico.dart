import 'package:flutter/material.dart';

class EconomicoPage extends StatefulWidget {
  const EconomicoPage({super.key});

  @override
  State<EconomicoPage> createState() => _EconomicoPageState();
}

class _EconomicoPageState extends State<EconomicoPage> {
  String? _categoriaSelecionada;
  String? _acaoSelecionada;
  final TextEditingController _valorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0A347E),
        title: const Center(
          child: Text(
            "ECONÔMICO",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ======= CARD DE SALDO =======
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 235, 235, 235),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                children: [
                  Text(
                    "Saldo",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "R\$ 1800,00",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "ENTRADA:  R\$ 1800,00",
                  style: TextStyle(color: Colors.green, fontSize: 14),
                ),
                Text(
                  "SAÍDA:  R\$ 1800,00",
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ======= BLOCOS DE INFORMAÇÕES =======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoBox("Renda", "R\$ 1800,00"),
                _infoBox("Investimento", "R\$ 1800,00"),
                _infoBox("Gastos", "R\$ 1800,00"),
              ],
            ),

            const SizedBox(height: 25),
            const Divider(color: Colors.white54, indent: 30, endIndent: 30),
            const SizedBox(height: 25),

            // ======= USO MENSAL =======
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Uso Mensal",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text("gráfico simulado"),
                    ),
                  ),
                  Container(
                    width: 120,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _valorGasto("JAN"),
                        _valorGasto("FEV"),
                        _valorGasto("MAR"),
                        _valorGasto("ABR"),
                        _valorGasto("MAI"),
                        _valorGasto("JUN"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ======= BOTÕES =======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _botaoAzul("Histórico", () {}),
                _botaoAzul("alterar valor", _abrirModal),
              ],
            ),

            const SizedBox(height: 40),

            // ======= RODAPÉ =======
            Container(
              width: double.infinity,
              color: const Color(0xFF0A347E),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Organize suas tarefas de forma simples",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.facebook, color: Colors.white),
                      SizedBox(width: 15),
                      Icon(Icons.camera_alt, color: Colors.white),
                      SizedBox(width: 15),
                      Icon(Icons.mail, color: Colors.white),
                      SizedBox(width: 15),
                      Icon(Icons.whatsapp, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "© Todos os direitos reservados - 2025",
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======= COMPONENTES REUTILIZÁVEIS =======
  Widget _infoBox(String titulo, String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 230, 230, 230),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Text(
            valor,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _botaoAzul(String texto, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0A347E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      ),
      child: Text(
        texto,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  void _abrirModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2C5B).withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Alterar Valor",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(height: 15),

            // CAMPO VALOR
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: "R\$ ",
                prefixStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF3C5FB5),
                hintText: "Digite o valor",
                hintStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 15),

            // AÇÃO
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF3C5FB5),
              decoration: InputDecoration(
                labelText: "Ação:",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF3C5FB5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(value: "Adicionar", child: Text("Adicionar")),
                DropdownMenuItem(value: "Remover", child: Text("Remover")),
              ],
              onChanged: (v) => setState(() => _acaoSelecionada = v),
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 10),
            const Text("Selecione a categoria:",
                style: TextStyle(color: Colors.white70)),

            // RADIO BUTTONS
            Column(
              children: [
                RadioListTile(
                  title: const Text("Renda", style: TextStyle(color: Colors.white)),
                  value: "Renda",
                  groupValue: _categoriaSelecionada,
                  onChanged: (v) => setState(() => _categoriaSelecionada = v),
                ),
                RadioListTile(
                  title: const Text("Gastos", style: TextStyle(color: Colors.white)),
                  value: "Gastos",
                  groupValue: _categoriaSelecionada,
                  onChanged: (v) => setState(() => _categoriaSelecionada = v),
                ),
                RadioListTile(
                  title: const Text("Investimento", style: TextStyle(color: Colors.white)),
                  value: "Investimento",
                  groupValue: _categoriaSelecionada,
                  onChanged: (v) => setState(() => _categoriaSelecionada = v),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // BOTÕES DO MODAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Confirmar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ======= COMPONENTE EXTRA PARA VALORES =======
class _valorGasto extends StatelessWidget {
  final String mes;
  const _valorGasto(this.mes);

  @override
  Widget build(BuildContext context) {
    return Text(
      "$mes  R\$ 1800,00",
      style: const TextStyle(
          color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
    );
  }
}
