import 'dart:async';
import '../mixins/validators.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc with Validators{
  // Déclaration des StreamControllers nécessaires
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _confirmPassword = BehaviorSubject<String>();
  final _obscureText = StreamController<bool>.broadcast();
  final _error = BehaviorSubject<String>();

  // Getters de lecture des données des streams
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<String> get confirmPassword => _confirmPassword.stream.transform(validateConfirm);
  Stream<bool> get submitValid =>
    Observable.combineLatest3(email, password, confirmPassword, (e, p, c) {
      return (c == p);
    });
  Stream<bool> get obscureText => _obscureText.stream;
  Stream<String> get error => _error.stream;

  // Getters d'ajout de données aux streams
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeConfirmPassword => _confirmPassword.sink.add;
  Function(bool) get toggle => _obscureText.sink.add;
  Function(String) get addError => _error.sink.add;

  // Fonction d'envoi des informations renseignées à Firebase
  submit() {
    final validEmail = _email.value;
    final validPassword = _password.value;
    // error.drain();
    print('Email is $validEmail');
    print('Password is $validPassword');
  }

  // Par convention, on crée une fonction 'dispose' à nos classes
  // pour nettoyer les objets et variables créés par cette classe

  // Nous permet de fermer le sink de nos StreamControllers
  dispose() {
    _email.close();
    _password.close();
    _confirmPassword.close();
    _obscureText.close();
    _error.close();
  }
}