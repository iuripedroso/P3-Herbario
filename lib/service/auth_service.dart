import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String code;
  final String message;

  AuthException(this.code, this.message);

  @override
  String toString() => "AuthException ($code): $message";
}

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> login({
    required String email,
    required String senha,
  }) async {
      if (email.isEmpty) {
      throw AuthException('email', "Digite seu e-mail.");
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      throw AuthException('email', "E-mail inválido. (ex: exemplo@gmail.com)");
    }

    if (senha.isEmpty) {
      throw AuthException('senha', "Digite sua senha.");
    }
    
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } on FirebaseAuthException catch (e) {
      // Tratamento de erros do Firebase
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        throw AuthException('email', "Usuário não encontrado.");
      } else if (e.code == 'wrong-password') {
        throw AuthException('senha', "Senha incorreta.");
      } else if (e.code == 'invalid-credential') {
        throw AuthException('geral', "E-mail ou senha incorretos.");
      } else {
        throw AuthException('geral', "Erro: ${e.code}");
      }
    }
  }

  Future<void> registrar({
    required String email,
    required String senha,
    required String confirmaSenha,
  }) async {
    // Validações
    if (email.isEmpty) {
      throw AuthException('email', "Obrigatório.");
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      throw AuthException('email', "E-mail inválido. (ex: exemplo@gmail.com)");
    }

    if (senha.isEmpty) {
      throw AuthException('senha', "Obrigatório.");
    }

    if (senha.length < 6) {
      throw AuthException('senha', "Mínimo de 6 caracteres.");
    }

    if (senha != confirmaSenha) {
      throw AuthException('confirmacao', "As senhas não conferem.");
    }

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw AuthException('email', "E-mail já cadastrado.");
      } else if (e.code == 'invalid-email') {
        throw AuthException('email', "E-mail inválido.");
      } else if (e.code == 'weak-password') {
        throw AuthException('senha', "Senha muito fraca.");
      } else {
        throw AuthException('geral', "Erro: ${e.code}");
      }
    }
  }
}
