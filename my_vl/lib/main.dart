import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_vl/src/app.dart';

// Fonction initiale du programme Dart
void main() {
  // Désactivation de l'interface système par dessus notre application
  SystemChrome.setEnabledSystemUIOverlays([]);
  // Fonction Flutterqui lance l'application
  runApp(App());
}