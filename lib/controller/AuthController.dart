import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Registro de usuário
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = userCredential.user!;
      return user.uid; // Retorna o ID do usuário registrado
    } catch (e) {
      return 'Erro: $e'; // Trata possíveis erros
    }
  }

  void logoutUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  // Login de usuário
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = userCredential.user!;
      return user.uid; // Retorna o ID do usuário logado
    } catch (e) {
      return 'Erro: $e'; // Trata possíveis erros
    }
  }
}
AuthService authController = AuthService();
