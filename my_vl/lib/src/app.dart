import 'package:flutter/material.dart';
import 'screens/hello_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyVL',
      theme: ThemeData(
        accentColor: Colors.deepOrangeAccent,
      ),
      home: HelloScreen(),
    );
  }
}