import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bloc_provider.dart';
import '../models/user_model.dart';

class StateBloc implements BlocBase {
  // Déclaration des StreamControllers nécessaires
  final _darkMode = BehaviorSubject();
  final _activeUser = BehaviorSubject<StudentUser>();

  // Getters de lecture des données des streams
  Stream<dynamic> get darkMode => _darkMode.stream;
  Stream<StudentUser> get activeUserStream => _activeUser.stream;
  Future<StudentUser> get activeUser => _activeUser.stream.first.then((value) => value);

  // Getters d'ajout de données aux streams
  Function(bool) get toggleDarkMode => _darkMode.sink.add;
  Function(StudentUser) get changeActiveUser => _activeUser.sink.add;

  // Par convention, on crée une fonction 'dispose' à nos classes
  // pour nettoyer les objets et variables créés par cette classe

  // Nous permet de fermer le sink de nos StreamControllers
  dispose() {
    _darkMode.close();
    _activeUser.close();
  }
}