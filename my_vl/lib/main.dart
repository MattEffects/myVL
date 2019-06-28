import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_vl/src/app.dart';
import 'package:flutter/rendering.dart';

// Fonction initiale du programme Dart
void main() {
  debugPaintSizeEnabled = false;
  // Désactivation de l'interface système par dessus notre application
  SystemChrome.setEnabledSystemUIOverlays([]);
  // Fonction Flutterqui lance l'application
  runApp(App());
}