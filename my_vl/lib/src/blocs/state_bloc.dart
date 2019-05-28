import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';

class StateBloc implements BlocBase {
  // Déclaration des StreamControllers nécessaires
  final _darkMode = BehaviorSubject();

  // Getters de lecture des données des streams
  Stream<dynamic> get darkMode => _darkMode.stream;

  // Getters d'ajout de données aux streams
  Function(bool) get toggleDarkMode => _darkMode.sink.add;

  // Par convention, on crée une fonction 'dispose' à nos classes
  // pour nettoyer les objets et variables créés par cette classe

  // Nous permet de fermer le sink de nos StreamControllers
  dispose() {
    _darkMode.close();
  }
}