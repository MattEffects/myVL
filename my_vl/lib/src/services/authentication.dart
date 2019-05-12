import 'package:firebase_auth/firebase_auth.dart';

// On crée la classe abstraite BaseAuth
// Qui définit les attributs nécessaires à une classe d'authentification
abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> signUpWithEmailAndPassword(String email, String password);
}

// Notre classe d'authentification via Firebase
// Implémentant BaseAuth, c'est à dire répondant à ses prérequis
// Et pouvant donc être assignée comme propriété de type BaseAuth
class Auth implements BaseAuth {
  // Création d'une instance utilisable de FirebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
    return user.uid;
  }
  Future<String> signUpWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
    return user.uid;
  }
}