import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Usuarios extends StatelessWidget {
  const Usuarios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E), 
      body: Column(
        children: [
          
          // HEADER
          Container(
            color: const Color(0xFF133A67),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),
          const Text(
            "Membros",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),

   
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(
                5,
                (index) => _membroCard(),
              ),
            ),
          ),

          const SizedBox(height: 30),

      
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionButton("+ Add Membro"),
              _actionButton("- Remover Membro"),
            ],
          ),

          const Spacer(),

          // FOOTER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.blue[900],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Organize suas tarefas de forma simples",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(FontAwesomeIcons.facebook, color: Colors.white),
                    Icon(FontAwesomeIcons.instagram, color: Colors.white),
                    Icon(FontAwesomeIcons.google, color: Colors.white),
                    Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Contato | Sobre | Termos de Uso",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                const Text(
                  "© Todos os direitos reservados - 2025",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _navItem(String title, {bool isActive = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.blue[200] : Colors.white,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 50,
            color: Colors.white,
          ),
      ],
    );
  }


  Widget _membroCard() {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF133A67),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: const [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
          ),
          SizedBox(height: 8),
          Text("Nome", style: TextStyle(color: Colors.white)),
          SizedBox(height: 4),
          Text("Descrição", style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }


  Widget _actionButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF133A67),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }
}
