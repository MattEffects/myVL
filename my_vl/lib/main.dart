import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'src/app.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  // statusBarColor: Colors.black.withOpacity(0.0),
  // ));
  debugPaintSizeEnabled = false;
  runApp(App());
}