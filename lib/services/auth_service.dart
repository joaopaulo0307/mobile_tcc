import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_repository.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );

    await UserRepository.salvarUsuario(
      uid: cred.user!.uid,
      nome: nome,
      email: email,
    );
  }
}
