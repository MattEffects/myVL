import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// On crée la classe abstraite BaseAuth
// Qui définit les attributs nécessaires à une classe d'authentification
abstract class AuthBase {
  Stream<String> get onAuthStateChanged;
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> signUpWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<String> userName();
  // Future<void> reload();
  Future<void> signOut();
}

// Notre classe d'authentification via Firebase
// Implémentant BaseAuth, c'est à dire répondant à ses prérequis
// Et pouvant donc être assignée comme propriété de type BaseAuth
class Auth implements AuthBase {
  // Création d'une instance utilisable de FirebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  Stream<String> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    // UserUpdateInfo updateInfo = UserUpdateInfo();
    // updateInfo.displayName = 'Noémie Currato';

    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    ).then((user) async {
      
      await _firestore.collection('users').document('${user.uid}').setData({
        'name': {
          'first': 'Noémie',
          'last': 'Currato',
        },
        'email': '${user.email}'
      }, merge: true);
      UserUpdateInfo updateInfo = UserUpdateInfo();
      await _firestore.collection('users').document('${user.uid}').get().then((doc) {
        updateInfo.displayName = '${doc.data['name']['first']} ${doc.data['name']['last']}';
      });
      await user.updateProfile(updateInfo);
      await user.reload();
      return user;
    });
    return user.uid;
  }
  Future<String> signUpWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
    return user.uid;
  }
  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null) {
      return user.uid;
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

  // Future<void> reload() async {
  //   UserUpdateInfo updateInfo = UserUpdateInfo();
  //   updateInfo.displayName = 'ZBEUB';
  // 
  //   updateName(FirebaseUser user, String name) async {
  //     await user.updateProfile(updateInfo);
  //     await user.reload();
  //   }
  // 
  //   FirebaseUser user = await _firebaseAuth.currentUser();
  //   if (user != null) {
  //     await updateName(user, 'Oui');
  //   }
  // 
  // }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}