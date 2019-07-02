import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_vl/src/app.dart';
import 'package:flutter/rendering.dart';

// Fonction initiale du programme Dart
void main() async {
  debugPaintSizeEnabled = false;
  // Désactivation de l'interface système par dessus notre application
  await SystemChrome.setEnabledSystemUIOverlays([]);
  // Verrouillage de l'applicatio en mode portrait
  // TODO: Développement d'un mode paysage
  await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
  ]).then((_) {
    // Fonction Flutter qui lance l'application
    runApp(App());
  });
}