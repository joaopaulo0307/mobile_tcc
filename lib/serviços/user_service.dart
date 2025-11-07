
class UserService {
  static String _userEmail = "usuario@exemplo.com";
  static List<String> _tarefasRealizadas = [];
  static String _userName = "Usuário";

  static void setUserData(String email, String name) {
    _userEmail = email;
    _userName = name;
  }

  static String get userEmail => _userEmail;
  static String get userName => _userName;
  
  static void setTarefasRealizadas(List<String> tarefas) {
    _tarefasRealizadas = tarefas;
  }

  static List<String> get tarefasRealizadas => _tarefasRealizadas;

  // Adicione algumas tarefas de exemplo
  static void initializeWithSampleData() {
    _tarefasRealizadas = [
      "Passear com o cachorro",
      "Comprar arroz",
      "Limpar a casa",
      "Fazer exercícios",
      "Estudar Flutter"
    ];
  }
}