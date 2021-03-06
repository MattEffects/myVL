import 'package:firebase_auth/firebase_auth.dart';

// On crée la classe abstraite BaseAuth
// Qui définit les attributs nécessaires à une classe d'authentification
abstract class AuthBase {
  Stream<FirebaseUser> get onAuthStateChanged;
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> signUpWithEmailAndPassword(String email, String password);
  Future<FirebaseUser> currentUser();
  Future<String> userName();
  Future<void> changeUserPhotoUrl(String photoUrl);
  Future<void> signOut();
}

// Notre classe d'authentification via Firebase
// Implémentant BaseAuth, c'est à dire répondant à ses prérequis
// Et pouvant donc être assignée comme propriété de type BaseAuth
class Auth implements AuthBase {
  // Création d'une instance utilisable de FirebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<FirebaseUser> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged
        .map((FirebaseUser user) => user);
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {

    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> signUpWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null) {
      return user;
    }
    return null;
  }

  Future<String> userName() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null) {
      return user.displayName;
    }
    return null;
  }

  Future<void> changeUserPhotoUrl(String photoUrl) async {
    await FirebaseAuth.instance.currentUser().then((user) async {
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.photoUrl = photoUrl;
      await user.updateProfile(updateInfo);
    });
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  // TODO: Implémenter ici une fonction de suppression de l'utilisateur
}
